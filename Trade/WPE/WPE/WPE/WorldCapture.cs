using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Windows.Forms;
using PacketDotNet;

namespace WPE
{
    class WorldCapture
    {
        public delegate void OutputDelegate(String str);
        public OutputDelegate OutPut;
        MemoryStream MS1 = new MemoryStream();
        long MSindex1 = 0;
        MemoryStream MS2 = new MemoryStream();
        long MSindex2 = 0;
        public WorldCapture(OutputDelegate o)
        {
            OutPut = o;
        }
        public void Parse(TcpPacket packet)
        {
            Boolean issend = packet.DestinationPort == 14000;
            if (issend)
            {
                send(packet);
            }
            else
            {
                receiver(packet);
            }
        }

        public void send(TcpPacket packet)
        {
            lock (MS2)
            {
                Boolean issend = packet.DestinationPort == 14000;
                byte[] data = packet.PayloadData;
                if (issend && data.Length < 16 && MS2.Length - MSindex2 < 16)
                    return;
                MS2.Seek(0, SeekOrigin.End);
                int mscount = 0;
                while (mscount < data.Length)
                {
                    MS2.WriteByte(data[mscount++]);
                }
                do
                {
                    MS2.Seek(MSindex2, SeekOrigin.Begin);

                    if (MS2.Length - MSindex2 < 16)
                    {
                        //OutPut(Inspector.Inspect("零散数据" + MSindex2 + "/" + MS2.Length, data, 16));
                        return;
                    }
                    byte[] head = new byte[16];
                    MSindex2 += MS2.Read(head, 0, 16);
                    int count = (int)readNum(head, 0, 4);
                    int type = (int)readNum(head, 8, 2);
                    int packcount = (int)readNum(head, 10, 2);
                    long QQ = readNum(head, 4, 4);
                    //OutPut("###############数据长度:" + count);
                    if (count - 16 < 0 || count > 0x32000)
                    {

                        //OutPut(Inspector.Inspect("读取数据错误" + MSindex2 + "/" + MS2.Length, MS2.ToArray(), 16));

                        MS2 = new MemoryStream();
                        MSindex2 = 0;
                        return;
                    }
                    if (MS2.Length - MSindex2 < count - 16)
                    {
                        MSindex2 -= 16;
                        return;
                    }
                    byte[] body;
                    if (count - 16 > 0)
                    {
                        body = new byte[count - 16];
                        MSindex2 += MS2.Read(body, 0, count - 16);
                    }
                    else
                    {
                        body = new byte[] { 0xFF };
                    }
                    if (!Filter(type)) 
                    //OutPut(Inspector.Inspect("                          Direction:" + (issend ? "发送" : "接收").ToString() + "count:" + packcount + "    Type:" + type, body, 16));
                    if (MS2.Length == MSindex2)
                    {
                        MS2 = new MemoryStream();
                        MSindex2 = 0;
                    }
                } while (MS2.Length - MSindex2 > 0);
            }
        }


        public void receiver(TcpPacket packet)
        {
            lock (MS1)
            {
                Boolean issend = packet.DestinationPort == 14000;
                byte[] data = packet.PayloadData;
                if (issend && data.Length < 16 && MS1.Length - MSindex1 > 0)
                    return;
                MS1.Seek(0, SeekOrigin.End);
                int mscount = 0;
                while (mscount < data.Length)
                {
                    MS1.WriteByte(data[mscount++]);
                }
                do
                {
                    MS1.Seek(MSindex1, SeekOrigin.Begin);

                    if (MS1.Length - MSindex1 < 16)
                    {
                        //OutPut(Inspector.Inspect("零散数据" + MSindex1 + "/" + MS1.Length, data, 16));
                        return;
                    }
                    byte[] head = new byte[16];
                    MSindex1 += MS1.Read(head, 0, 16);
                    int count = (int)readNum(head, 0, 4);
                    int type = (int)readNum(head, 8, 2);
                    int packcount = (int)readNum(head, 10, 2);
                    long QQ = readNum(head, 4, 4);
                    if (count - 16 < 0 || count > 0x32000)
                    {

                        //OutPut(Inspector.Inspect("读取数据错误" + MSindex1 + "/" + MS1.Length, MS1.ToArray(), 16));

                        MS1 = new MemoryStream();
                        MSindex1 = 0;
                        return;
                    }
                    if (MS1.Length - MSindex1 < count - 16)
                    {
                        MSindex1 -= 16;
                        return;
                    }
                    byte[] body;
                    if (count - 16 > 0)
                    {
                        body = new byte[count - 16];
                        MSindex1 += MS1.Read(body, 0, count - 16);
                    }
                    else
                    {
                        body = new byte[] { 0xFF };
                    }
                    if (!Filter(type))
                        //OutPut(Inspector.Inspect("                                                  Direction:" + (issend ? "发送" : "接收").ToString() + "count:" + packcount + "    Type:" + type, body, 16));
                    if (MS1.Length == MSindex1)
                    {
                        MS1 = new MemoryStream();
                        MSindex1 = 0;
                    }
                } while (MS1.Length - MSindex1 > 0);
            }
        }

        public void Parse2(TcpPacket packet)
        {


        }

        public byte[] CopyArray(byte[] a)
        {
            byte[] result = new byte[a.Length];
            int mscount = 0;
            while (mscount < a.Length)
            {
                result[mscount] = a[mscount++];
            }
            return result;
        }

        public bool Filter(int type)
        {
            List<int> i = new List<int>();
            //i.AddRange(new int[] { 1503, 911, 1903, 1810, 113, 324, 532, 914, 1942, 2, 308, 201, 208, 222, 1000, 204, 203, 215, 202, 1500 ,308,208,1500,307});
            return i.Contains(type);

        }

        public static byte[] join(byte[] b1, byte[] b2)
        {
            byte[] b = new byte[b1.Length + b2.Length];
            for (int i = 0; i < b1.Length; i++)
            {
                b[i] = b1[i];
            }

            for (int i = b1.Length; i < b1.Length + b2.Length; i++)
            {
                b[i] = b2[i - b1.Length];
            }
            return b;
        }

        public static long readNum(byte[] abyte0, int i1, int j1)
        {
            long l1 = 0L;
            for (int k1 = 0; k1 < j1; k1++)
                l1 = (l1 <<= 8) + (long)(abyte0[i1 + k1] & 0xff);

            return l1;
        }
    }


}
