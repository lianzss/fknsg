using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using WPE;

namespace Auxiliary
{
    public abstract class Engine
    {
        public Auxiliary MyAuxiliary;
        public ArrayList PacketList;
        public String SocketUrl;
        public int Port;
        public bool IsNeedReconnect;
        public long LastReceived;
        public TcpClient SocketEngine;
        public NetworkStream EngineStream;
        public bool IsStop = false;
        public Engine(Auxiliary a,string ip,int port)
        {
            this.MyAuxiliary = a;
            SocketUrl = ip;
            Port = port;
            PacketList = new ArrayList();
            SocketEngine = new TcpClient();
            Connect();
        }

        public bool Connect()
        {
            try
            {
                IsStop = false;
                try
                {
                    SocketEngine.Connect(SocketUrl, Port);
                    EngineStream = SocketEngine.GetStream();
                }
                catch (Exception e)
                {
                    MyAuxiliary.OutPut("Socket连接出错：" + e.Message);
                }
                LastReceived = DateTime.Now.Ticks / 10000;
                new Thread(new ThreadStart(Send)).Start();
                new Thread(new ThreadStart(Receive)).Start();
                return true;
            }
            catch (Exception e)
            {

                return false;
            }
        }
        public void Stop()
        {
            IsStop = true;
            EngineStream.Close();
            SocketEngine.Close();
        }

        public void SendData(byte[] data)
        {
            PacketList.Add(data);
        }
        public void Send()
        {
            while (!IsStop)
            {
                try
                {
                    if (PacketList.Count > 0)
                    {
                        for (int i = 0; i < PacketList.Count; i++)
                        {
                            byte[] data = (byte[])PacketList[0];
                            //MyAuxiliary.OutPut(Inspector.Inspect(data));
                            EngineStream.Write(data, 0, data.Length);
                            EngineStream.Flush();
                            PacketList.RemoveAt(0);
                        }
                    }
                    Refresh();
                    if (DateTime.Now.Ticks / 10000 - LastReceived > 60000)
                    {
                        MyAuxiliary.OutPut("接收数据超时，连接已经断开。");
                        Stop();
                    }
                    Thread.Sleep(100);
                }
                catch (Exception e)
                {
                    MyAuxiliary.OutPut("发送连接已经断开！" + e.Message);
                    Stop();
                }
            }
        }

        public void Receive()
        {
            while (!IsStop)
            {
                try
                {
                    if (ParseStream(EngineStream))
                    {
                        LastReceived = DateTime.Now.Ticks / 10000;
                    }
                    Thread.Sleep(100);
                }
                catch (Exception e) {
                    MyAuxiliary.OutPut("接收连接已经断开！" + e.Message);
                    //Stop();
                }
            }
        }

        public void Refresh()
        {

        }

        public abstract bool ParseStream(NetworkStream ns);
        
    }
}
