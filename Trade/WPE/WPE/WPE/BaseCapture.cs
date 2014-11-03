using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Collections;
using PacketDotNet;
using System.Threading;

namespace WPE
{
    abstract class BaseCapture
    {
        public delegate void OutputDelegate(String str);
        public OutputDelegate OutPut;
        public bool ShowHex = true;
        public bool ShowChar = true;
        public MemoryStream SendData = new MemoryStream();
        public long SendDataIndex = 0;
        public MemoryStream ReceiveData = new MemoryStream();
        public long ReceiveIndex = 0;
        public bool IsShowInspector = true;
        public abstract void ParseReceiveData();
        public abstract void ParseSendData();
        public void Parse(TcpPacket packet)
        {
            if (!checkDataAvail(packet))
                return;
            
            if (checkIsHTTP(packet))
            {
                parseHTTPData(packet);
                return;
            }
            bool issend = checkIsSend(packet);
            if (issend)
            {
                lock (ReceiveData)
                {
                    SendData.Seek(0, SeekOrigin.End);
                    SendData.Write(packet.PayloadData, 0, packet.PayloadData.Length);
                }
            }
            else
            {
                lock (ReceiveData)
                {
                    ReceiveData.Seek(0, SeekOrigin.End);
                    ReceiveData.Write(packet.PayloadData, 0, packet.PayloadData.Length);
                }
                
            }
            if (IsShowInspector)
                OutPut(Inspector.Inspect((issend ? "发送" : "接收__" + ReceiveData.Length), packet.PayloadData, 16, ShowHex, ShowChar));
        }

        public Hashtable _DATASEQ = new Hashtable();
        public bool checkDataAvail(TcpPacket packet)
        {
            var ipPacket = (PacketDotNet.IpPacket)packet.ParentPacket;
            StringBuilder sb = new StringBuilder();
            sb.Append(ipPacket.SourceAddress).Append(packet.SourcePort).Append(ipPacket.DestinationAddress).Append(packet.DestinationPort);
            string id = sb.ToString();
            if (!_DATASEQ.ContainsKey(id))
            {
                _DATASEQ.Add(id, (long)(packet.SequenceNumber + packet.PayloadData.Length));
                return true;
            }
            long lastseq = (long)_DATASEQ[id];
            uint currentseq = packet.SequenceNumber;
            int datalength = packet.PayloadData.Length;
            if (currentseq + datalength <= lastseq)
                return false;

            _DATASEQ[id] = (long)(currentseq + datalength);
            return true;
        }

        public BaseCapture(OutputDelegate o)
        {
            OutPut = o;
            new Thread(new ThreadStart(Receiver)).Start();
            new Thread(new ThreadStart(Sender)).Start();
        }

        public void Receiver()
        {
            while (true)
            {
                Thread.Sleep(50);
                lock (ReceiveData)
                {                    
                    ParseReceiveData();
                }
            }
        }

        public void Sender()
        {
            while (true)
            {
                Thread.Sleep(50);
                lock (SendData)
                {                    
                    ParseSendData();
                }
            }
        }

  

        public bool checkIsSend(TcpPacket packet)
        {
            var ipPacket = (PacketDotNet.IpPacket)packet.ParentPacket;
            if (ipPacket.SourceAddress.ToString().IndexOf("192.168.") >= 0)
            {
                return true;
            }
            return false;
        }

        public bool checkIsHTTP(TcpPacket packet)
        {
            return packet.SourcePort == 80 || packet.DestinationPort == 80;
        }

        public void parseHTTPData(TcpPacket packet)
        {
            bool IsSend = true;
            bool IsPOST = true;
            string s = Encoding.GetEncoding("utf-8").GetString(packet.PayloadData);
            string[] ss = s.Split(new char[] { '\r', '\n' });
            Hashtable header = new Hashtable();
            for (int i = 0; i < ss.Length; i++)
            {
                if (i == 0)
                {
                    if (ss[i].StartsWith("GET"))
                    {
                        IsPOST = false;
                        header.Add("url", ss[i].Split(' ')[1]);
                    }
                    else if (ss[i].StartsWith("POST"))
                    {
                        IsPOST = true;
                        header.Add("url", ss[i].Split(' ')[1]);
                    }
                    else
                    {
                        IsSend = false;
                    }
                }
                if (ss[i].IndexOf(":") > 0)
                {
                    string[] sss = ss[i].Split(':');
                    header.Add(sss[0].Trim(), sss[1].Trim());
                }
            }
            if (IsSend)
            {
                OutPut("Method:" + (IsPOST ? "POST" : "GET") + "  http://" + header["Host"] + header["url"]);
            }
            else
            {
                OutPut("Receive data.");
            }
            OutPut("==========================================================================");
            int dataindex = GetIndexOf(packet.PayloadData, new byte[] { 0xd, 0xa, 0xd, 0xa });
            if (dataindex >= 0)
            {
                byte[] data = new byte[packet.PayloadData.Length - dataindex - 4];
                Array.Copy(packet.PayloadData, dataindex + 4, data, 0, data.Length);
                OutPut(Inspector.Inspect(data));
            }
            else
            {
                OutPut(Inspector.Inspect(packet.PayloadData));
            }
        }

        public int GetIndexOf(byte[] b, byte[] bb)
        {
            if (b == null || bb == null || b.Length == 0 || bb.Length == 0)
                return -1;

            int i, j;
            for (i = 0; i < b.Length; i++)
            {
                if (b[i] == bb[0])
                {
                    for (j = 1; j < bb.Length; j++)
                    {
                        if (i + j >= b.Length)
                            break;
                        if (b[i + j] != bb[j])
                            break;
                    }
                    if (j == bb.Length)
                        return i;
                }
            }
            return -1;
        }

    }
}
