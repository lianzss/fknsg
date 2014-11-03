using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PacketDotNet;
using System.IO;
using System.Collections;
using WPE.AMF.AmfData;
using System.Threading;
using System.Windows.Forms;

namespace WPE
{
    class SanGuoCapture : BaseCapture
    {
        public SanGuoCapture(OutputDelegate o)
            : base(o)
        {
            ShowHex = true;
            ShowChar = true;
            IsShowInspector = false;

        }
        override  public void ParseReceiveData()
        {
            lock (ReceiveData)
            {
                if (ReceiveData.Length - ReceiveIndex < 4)
                    return;
                ReceiveData.Seek(ReceiveIndex, SeekOrigin.Begin);
                int length = (ReceiveData.ReadByte() << 24) + (ReceiveData.ReadByte() << 16) + (ReceiveData.ReadByte() << 8) + ReceiveData.ReadByte();
                if (length + 8 > ReceiveData.Length - ReceiveIndex)
                    return;
                byte[] data = new byte[length];
                byte[] header = new byte[8];
                ReceiveData.Seek(ReceiveIndex, SeekOrigin.Begin);
                ReceiveData.Read(header, 0, 8);
                ReceiveData.Read(data, 0, length);
                ReceiveIndex = ReceiveData.Position;
                if (ReceiveData.Length == ReceiveIndex)
                {
                    ReceiveData = new MemoryStream();
                    ReceiveIndex = 0;
                }
                try
                {
                   
                   
                   CNameObjDict co= ParseAMF3(data);
                   if (co.ContainsKey("callback"))
                   {
                       if (((CNameObjDict)co["callback"])["callbackName"].ToString() == "re.chat.getMsg")
                           return;
                   }
                   OutPut("\r\nReceiveData:\r\n" + co.ToString());
                }
                catch { }

            }
        }
        override public void ParseSendData()
        {
            lock (SendData)
            {
                if (SendData.Length - SendDataIndex < 4)
                    return;
                SendData.Seek(SendDataIndex, SeekOrigin.Begin);
                int length = (SendData.ReadByte() << 24) + (SendData.ReadByte() << 16) + (SendData.ReadByte() << 8) + SendData.ReadByte();
                if (length + 8 > SendData.Length - SendDataIndex)
                    return;
                byte[] data = new byte[length];
                byte[] header = new byte[24];
                SendData.Seek(SendDataIndex, SeekOrigin.Begin);
                SendData.Read(header, 0, 24);
                SendData.Read(data, 0, length);
                SendDataIndex = SendData.Position;
                if (SendData.Length == SendDataIndex)
                {
                    SendData = new MemoryStream();
                    SendDataIndex = 0;
                }
                try
                {
                   CNameObjDict co= ParseAMF3(data);
                   OutPut("\r\nSendData:\r\n" + co.ToString());
                }
                catch (Exception e) { OutPut("send err:" + e.Message); }

            }
        }
       
       

     


        public CNameObjDict ParseAMF3(byte[] data)
        {
            CNameObjDict co = null;
            try
            {
                co = ((CNameObjDict)CAmf3Helper.GetObject(data));
            }
            catch (Exception e) {
                MessageBox.Show(e.Message);
                return null; }
           
            return co;
        }

 
       
    }
}
