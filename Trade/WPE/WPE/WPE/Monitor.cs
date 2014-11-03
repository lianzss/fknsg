using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SharpPcap;
using System.Threading;
using PacketDotNet;
using System.Text.RegularExpressions;

namespace WPE
{
    class Monitor
    {
        public static ICaptureDevice CurrentDevice;
        public static Thread CurrentThread;
        public static String Filter = "ip and tcp and port 2001";
        public delegate void OutputDelegate(String str);
        public delegate void ParseDataDelegate(TcpPacket data);
        public static ParseDataDelegate ParseData=DataInfo;
        public static OutputDelegate OutPut=Print;
        public static bool IsPrintIPInfo = false;
        public static bool IsPrintDataInfo = true;
        public static bool IsFilterEmpty = true;
        public static bool ShowHex = true;
        public static bool ShowChar = true;

        public static CaptureDeviceList GetDevice(){
            var devices = CaptureDeviceList.New();
            if (devices.Count < 1)
                return null;
            Regex r = new Regex("FriendlyName:(.+)");
            int i=0;
            OutPut("List of Current Adapters.Modify the adapter index to capture.");
            foreach (var d in devices)
            {
                string info = d.ToString();
                string friendlyName = r.Match(info).Groups[1].Value;
                OutPut("["+i+"] "+friendlyName);
                //OutPut(d.ToString());
                i++;
            }
            OutPut("------------------------------------------------------------");
            return devices;
        }

        public static void Open()
        {
            var device = CurrentDevice;
            device.OnPacketArrival +=
                new PacketArrivalEventHandler(device_OnPacketArrival);
            int readTimeoutMilliseconds = 5000;
            device.Open(DeviceMode.Normal, readTimeoutMilliseconds);
        }

        public static void Close()
        {
            CurrentDevice.StopCapture();
            CurrentThread.Interrupt();
            CurrentDevice.Close();
        }

        public static void StartCapture()
        {
            CurrentDevice.Filter = Filter;
            CurrentThread = new Thread(new ThreadStart(CurrentDevice.StartCapture));
            CurrentThread.Start();
        }

        public static void StopCapture()
        {
            try
            {
                CurrentThread.Interrupt();
                CurrentDevice.StopCapture();
            }
            catch { }
        }

        private static void device_OnPacketArrival(object sender, CaptureEventArgs e)
        {
            ParsePacket(e.Packet);
        }

        public static void ParsePacket(RawCapture packet1){
            var time = packet1.Timeval.Date;
            var len = packet1.Data.Length;
            var packet = PacketDotNet.Packet.ParsePacket(packet1.LinkLayerType, packet1.Data);
            var tcpPacket =  PacketDotNet.TcpPacket.GetEncapsulated(packet);
            if (tcpPacket != null)
            {
                var ipPacket = (PacketDotNet.IpPacket)tcpPacket.ParentPacket;
                
                System.Net.IPAddress srcIp = ipPacket.SourceAddress;
                System.Net.IPAddress dstIp = ipPacket.DestinationAddress;
                int srcPort = tcpPacket.SourcePort;
                int dstPort = tcpPacket.DestinationPort;
                //OutPut(tcpPacket.AcknowledgmentNumber+" , "+tcpPacket.CalculateTCPChecksum()+" , "+tcpPacket.Checksum+" , "+tcpPacket.DataOffset+" , "+tcpPacket.SequenceNumber);

                string ipinfo = srcIp + ":" + srcPort + " ->" + dstIp + ":" + dstPort + " --Seq:" + tcpPacket.SequenceNumber + " DataLength:" + tcpPacket.PayloadData.Length + " NextSeq:" + (tcpPacket.SequenceNumber + tcpPacket.PayloadData.Length);
                if ((tcpPacket.PayloadData.Length == 0 && !IsFilterEmpty) || tcpPacket.PayloadData.Length > 0)
                {
                    if (IsPrintIPInfo)
                        OutPut(ipinfo);
                    if (IsPrintDataInfo)
                    {
                        ParseData(tcpPacket);
                    }
                }
            }
        }
        public static void Print(string str) { }
        public static void DataInfo(TcpPacket packet)
        {
            OutPut(Inspector.Inspect(packet.PayloadData,ShowHex,ShowChar));
        }
    }
}
