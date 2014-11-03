using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PacketDotNet;

namespace WPE
{
    class DataBuffer
    {
        string sIp;
        string dIp;
        int sPort;
        int dProt;

        public void init(TcpPacket tcp)
        {
            //var ipPacket = (PacketDotNet.IpPacket)tcpPacket.ParentPacket;
            //if(ipPacket.DestinationAddress)
        }

        public bool checkIsSend(TcpPacket tcp)
        {
            if (sIp.IndexOf("192.168.") >= 0)
            {
                return true;
            }
            return false;
        }
    }
}
