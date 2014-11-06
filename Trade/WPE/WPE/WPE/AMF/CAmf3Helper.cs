// AMF3协议格式的部分处理
//
// see: <<Action Message Format - AMF 3>>
//      https://code.google.com/p/amf3cplusplus/
//

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace WPE.AMF.AmfData
{
   public class CAmf3Helper
    {
        public enum DataType
        {
            Undefined = 0x00,
            Null = 0x01,
            False = 0x02,
            True = 0x03,
            Integer = 0x04,
            Double = 0x05,
            String = 0x06,
            XmlDoc = 0x07,
            Date = 0x08,
            Array = 0x09,
            Object = 0x0A,
            Xml = 0x0B,
            ByteArray = 0x0C
        }

        public class CObjTraits
        {
            public bool dynamic;
            public string name;
            public string[] keys;
        }

        public class CRefTable
        {
            public List<string> str = new List<string>();
            public List<CNameObjDict> obj = new List<CNameObjDict>();
            public List<CObjTraits> ot = new List<CObjTraits>();
        }

        const int MaxU29 = 0x1FFFFFFF;

        // 无需构造实例
        private CAmf3Helper()
        {
        }

        public static object Read(Stream stm)
        {
            return ReadAmf(stm, new CRefTable());
        }

        public static object ReadAmf(Stream stm, CRefTable rt)
        {
            int type = stm.ReadByte();
            switch ((DataType)type)
            {
                case DataType.Undefined:
                    return null;
                case DataType.Null:
                    return null;
                case DataType.False:
                    //Console.WriteLine(false);
                    return false;
                case DataType.True:
                    //Console.WriteLine(true);
                    return true;
                case DataType.Integer:
                    uint aaa = ReadInt(stm);
                    //Console.WriteLine(aaa);
                    return aaa;
                case DataType.Double:
                    double aaa1 = CDataHelper.BE_ReadDouble(stm);
                    //Console.WriteLine(aaa1);
                    return aaa1;
                case DataType.String:

                    string sss = ReadString(stm, rt);
                    //Console.WriteLine(sss);
                    return sss;
                case DataType.XmlDoc:
                    break;
                case DataType.Date:
                    break;
                case DataType.Array:
                    return ReadArray(stm, rt);
                case DataType.Object:
                    return ReadHashObject(stm, rt);
                case DataType.Xml:
                    break;
                case DataType.ByteArray:
                    return CAmf3Helper.GetObject( ReadByteArray(stm, rt));
                default:
                    break;
            }
            //throw new Exception("暂未处理的数据类型"+type);
            return null;
        }

        public static byte[] ReadByteArray(Stream stm, CRefTable rt)
        {
            uint head = ReadInt(stm);

            Trace.Assert((head & 0x1) == 0x1);

            int count = (int)(head >> 1);
            byte[] ary = new byte[count];

            for (int i = 0; i < count; i++)
                ary[i] = (byte)stm.ReadByte();

            return ary;
        }

        public static uint ReadInt(Stream stm)
        {
            uint b = (uint)stm.ReadByte();
            int num = 0;
            uint value = 0;
            while (((b & 0x80) != 0) && (num < 3))
            {
                value = (value << 7) | (b & 0x7F);
                ++num;
                b = (uint)stm.ReadByte();
            }

            //最后一字节
            if (num < 3)
                value = (value << 7) | (b & 0x7F);
            else
                value = (value << 8) | (b & 0xFF);

            return value;
        }

        public static string ReadString(Stream stm, CRefTable rt)
        {
            uint head = ReadInt(stm);
            int len = (int)(head >> 1);
            if (len <= 0)
                return "";

            if (IsRefrence(head))
                return rt.str[len];

            string str = CDataHelper.ReadUtfStr(stm, len);
            rt.str.Add(str);

            return str;
        }

        public static CMixArray ReadArray(Stream stm, CRefTable rt)
        {
            uint head = ReadInt(stm);

            Trace.Assert((head & 0x1) == 0x1);

            int count = (int)(head >> 1);
            CMixArray ary = new CMixArray(count);
            for (string key = ReadString(stm, rt); key != ""; key = ReadString(stm, rt))
                ary[key] = ReadAmf(stm, rt);

            //读取子元素
            for (int i = 0; i < count; i++)
                ary[i] = ReadAmf(stm, rt);

            return ary;
        }

        public static CNameObjDict ReadHashObject(Stream stm, CRefTable rt)
        {
            uint head = ReadInt(stm);
            CObjTraits ot = null;

            if (IsRefrence(head))
                return rt.obj[(int)(head >> 1)];

            if (IsRefrence(head >> 1))
            {
                ot = rt.ot[(int)(head >> 2)];
            }
            else
            {
                ot = new CObjTraits();
                Trace.Assert(((head >> 2) & 0x1) == 0, "暂不支持");
                ot.dynamic = ((head >> 3) & 0x1) != 0;
                int count = (int)(head >> 4);
                ot.name = ReadString(stm, rt);
                ot.keys = new string[count];
                for (int i = 0; i < count; i++)
                    ot.keys[i] = ReadString(stm, rt);
                rt.ot.Add(ot);
            }

            CNameObjDict obj = new CNameObjDict(ot.name);
            for (int i = 0; i < ot.keys.Length; i++)
                obj[ot.keys[i]] = ReadAmf(stm, rt);

            //读取动态属性
            if (ot.dynamic)
            {
                while (true)
                {
                    string key = ReadString(stm, rt);
                    //Console.WriteLine(":::  " + key);
                    if (key == "")
                        break;

                    obj[key] = ReadAmf(stm, rt);
                }
            }

            rt.obj.Add(obj);

            return obj;
        }

        public static bool IsRefrence(uint header)
        {
            return (header & 0x1) == 0;
        }

        public static void Write(Stream stm, object obj)
        {
            WriteAmf(stm, obj);
        }

        public static void WriteAmf(Stream stm, object obj)
        {
            if (obj == null)
            {
                stm.WriteByte((byte)DataType.Null);
            }
            else if (obj is byte || (obj is int && (uint)(int)obj < MaxU29) || (obj is uint && (uint)obj < MaxU29)) // U29无符号整形
            {
                stm.WriteByte((byte)DataType.Integer);
                WriteInt(stm, uint.Parse(obj.ToString()));
            }
            else if (obj is int || obj is uint || obj is float || obj is double) // 只列举了常用的
            {
                stm.WriteByte((byte)DataType.Double);
                CDataHelper.BE_WriteDouble(stm, double.Parse(obj.ToString()));
            }
            else if (obj is bool)
            {
                if ((bool)obj)
                    stm.WriteByte((byte)DataType.True);
                else
                    stm.WriteByte((byte)DataType.False);
            }
            else if (obj is string)
            {
                stm.WriteByte((byte)DataType.String);
                WriteString(stm, obj as string);
            }
            else if (obj is CMixArray)
            {
                stm.WriteByte((byte)DataType.Array);
                CMixArray ary = obj as CMixArray;
                uint head = ((uint)ary.FixedLength << 1) | 1;
                WriteInt(stm, head);
                foreach (KeyValuePair<string, object> pair in ary.Dynamic)
                {
                    WriteString(stm, pair.Key);
                    WriteAmf(stm, pair.Value);
                }
                WriteString(stm, "");
                foreach (object o in ary.Fixed)
                    WriteAmf(stm, o);
            }
            else if (obj is Array)
            {
                stm.WriteByte((byte)DataType.Array);
                Array ary = obj as Array;
                uint head = ((uint)ary.Length << 1) | 1;
                WriteInt(stm, head);
                WriteString(stm, "");
                foreach (object o in ary)
                    WriteAmf(stm, o);
            }
            else if (obj is IDictionary)
            {
                stm.WriteByte((byte)DataType.Object);
                IDictionary dic = obj as IDictionary;
                uint head = 0x0B;
                WriteInt(stm, head);
                if (obj is CNameObjDict)
                    WriteString(stm, (obj as CNameObjDict).className);
                else
                    WriteString(stm, "");
                foreach (DictionaryEntry e in obj as IDictionary)
                {
                    if (e.Key.ToString() == "" && e.Value is string)    //解析时为了好看放进去的ClassName
                        continue;
                    WriteString(stm, e.Key.ToString());
                    WriteAmf(stm, e.Value);
                }
                WriteString(stm, "");
            }
            else
            {
                throw new Exception( "暂未处理的数据类型");
                stm.WriteByte((byte)DataType.Undefined);
            }
        }

        public static void WriteInt(Stream stm, uint data)
        {
            Trace.Assert(data <= MaxU29);

            if (data <= 0x7F)
            {
                stm.WriteByte((byte)data);
            }
            else if (data <= 0x3FFF)
            {
                stm.WriteByte((byte)((data >> 7) | 0x80));
                stm.WriteByte((byte)(data & 0x7F));
            }
            else if (data <= 0x001FFFFF)
            {
                stm.WriteByte((byte)((data >> 14) | 0x80));
                stm.WriteByte((byte)(((data >> 7) & 0x7F) | 0x80));
                stm.WriteByte((byte)(data & 0x7F));
            }
            else
            {
                stm.WriteByte((byte)((data >> 22) | 0x80));
                stm.WriteByte((byte)(((data >> 15) & 0x7F) | 0x80));
                stm.WriteByte((byte)(((data >> 8) & 0x7F) | 0x80));
                stm.WriteByte((byte)(data & 0xFF));
            }
        }

        public static void WriteString(Stream stm, string str)
        {
            byte[] buf = Encoding.UTF8.GetBytes(str);
            uint head = ((uint)buf.Length << 1) | 1;
            WriteInt(stm, head);
            stm.Write(buf, 0, buf.Length);
        }
        public static byte[] _currentdata;

        public static object GetObject(byte[] buf)
        {
            _currentdata = buf;
            return Read(new MemoryStream(buf));
        }

        public static byte[] GetBytes(object obj)
        {
            MemoryStream stm = new MemoryStream();
            Write(stm, obj);
            return stm.ToArray();
        }

        public void CheckData(bool b)
        {
            if (!b)
            {
                
                
                throw new Exception("AMF3格式化错误\r\n"+Inspector.Inspect(_currentdata));
            }
        }
    }
}
