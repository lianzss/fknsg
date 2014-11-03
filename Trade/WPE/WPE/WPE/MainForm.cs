using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using System.Net.NetworkInformation;
using System.Net;
using System.Diagnostics;
using System.Text.RegularExpressions;
using SharpPcap;
using System.Threading;
using System.IO;

namespace WPE
{
    public partial class MainForm : Form
    {
        CaptureDeviceList _devices;
        public MainForm()
        {
            InitializeComponent();
            Monitor.OutPut = append;
            _devices = Monitor.GetDevice();
        }

     

        public void go()
        {
            byte[] data = File.ReadAllBytes("bot.abc");
            //append(Inspector.Inspect(data));
            long data_size = data.Length;
            String name = "bot.abc";
            long name_size = name.Length;
            int[] primes = { 0x2717, 0x2719, 0x2735, 0x2737, 0x274d, 0x2753 };
            byte[] result = new byte[data_size];
            int prime = 0;
            foreach (int i in primes)
            {
                if (data_size % i!=0)
                {
                    prime = i;
                    break;
                }
            }
            long index = 0L;
            long index1 = 0;
            long index2 = 0;

            while (index1 < data_size)
            {
                result[index % data_size] =(byte)( data[index1] ^ name[(int)index2]);

                index1 += 1;
                index2 = (index2 + 1) % name_size;
                index += prime;
            }
            append(Inspector.Inspect(result));
            File.WriteAllBytes("1.zip", result);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (Monitor.CurrentDevice!=null&&Monitor.CurrentDevice.Started)
            {
                Monitor.StopCapture();
                button1.Text = "Start";
            }
            else
            {
                Monitor.CurrentDevice = _devices[int.Parse(textBox4.Text)];
                Monitor.Open();
                //WorldCapture wc = new WorldCapture(append);
                //Monitor.ParseData = wc.Parse;
                SanGuoCapture sg = new SanGuoCapture(append);
                sg.ShowHex = checkBox4.Checked;
                sg.ShowChar=checkBox5.Checked;
                Monitor.ParseData = sg.Parse;
                Monitor.Filter = textBox2.Text.Trim();
                Monitor.StartCapture();
                button1.Text = "Pause";
            }

            //Monitor.listen();
        }
        private void button2_Click(object sender, EventArgs e)
        {
            Monitor.Close();
        }
        /// <summary>
        /// 获取操作系统已用的端口号
        /// </summary>
        /// <returns></returns>
        public IList PortIsUsed()
        {
            //获取本地计算机的网络连接和通信统计数据的信息
            IPGlobalProperties ipGlobalProperties = IPGlobalProperties.GetIPGlobalProperties();
            //返回本地计算机上的所有Tcp监听程序
            IPEndPoint[] ipsTCP = ipGlobalProperties.GetActiveTcpListeners();
            //返回本地计算机上的所有UDP监听程序
            IPEndPoint[] ipsUDP = ipGlobalProperties.GetActiveUdpListeners();
            //返回本地计算机上的Internet协议版本4(IPV4 传输控制协议(TCP)连接的信息。
            TcpConnectionInformation[] tcpConnInfoArray = ipGlobalProperties.GetActiveTcpConnections();
            IList allPorts = new ArrayList();
            foreach (IPEndPoint ep in ipsTCP)
            {
                allPorts.Add(ep.Port);

            }
            foreach (IPEndPoint ep in ipsUDP) allPorts.Add(ep.Port);
            foreach (TcpConnectionInformation conn in tcpConnInfoArray)
            {
                allPorts.Add(conn.LocalEndPoint.Port);
            }
            return allPorts;
        }

        public void append(string str)
        {
            Async.UI(delegate
            {
                textBox1.AppendText(str + "\r\n");
            }, textBox1, false);

        }

        public int[] getProcessPort(int pid)
        {
            //存放进程使用的端口号链表 
            List<int> ports = new List<int>();
            Process pro = new Process();
            pro.StartInfo.FileName = "cmd.exe";
            pro.StartInfo.UseShellExecute = false;
            pro.StartInfo.RedirectStandardInput = true;
            pro.StartInfo.RedirectStandardOutput = true;
            pro.StartInfo.RedirectStandardError = true;
            pro.StartInfo.CreateNoWindow = true;
            pro.Start();
            pro.StandardInput.WriteLine("netstat -ano");
            pro.StandardInput.WriteLine("exit");
            Regex reg = new Regex("\\s+", RegexOptions.Compiled);
            string line = null;
            ports.Clear();
            while ((line = pro.StandardOutput.ReadLine()) != null)
            {
                line = line.Trim();
                if (line.StartsWith("TCP", StringComparison.OrdinalIgnoreCase))
                {
                    line = reg.Replace(line, ",");
                    string[] arr = line.Split(',');
                    if (arr[4] == pid.ToString())
                    {
                        string soc = arr[1];
                        int pos = soc.LastIndexOf(':');
                        int pot = int.Parse(soc.Substring(pos + 1));
                        ports.Add(pot);
                    }
                }
                else if (line.StartsWith("UDP", StringComparison.OrdinalIgnoreCase))
                {
                    line = reg.Replace(line, ",");
                    string[] arr = line.Split(',');
                    if (arr[3] == pid.ToString())
                    {
                        string soc = arr[1];
                        int pos = soc.LastIndexOf(':');
                        int pot = int.Parse(soc.Substring(pos + 1));
                        ports.Add(pot);
                    }
                }
            }
            pro.Close();
            return ports.ToArray();
        }

        public int[] getProcessPort(string name)
        {
            System.Diagnostics.Process[] proc = System.Diagnostics.Process.GetProcessesByName(name);
            if (proc.Length == 0)
            {
                return null;
            }

            return getProcessPort(proc[0].Id);

        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            Monitor.IsPrintIPInfo = checkBox1.Checked;
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            Monitor.IsPrintDataInfo = checkBox2.Checked;
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
            Monitor.IsFilterEmpty = checkBox3.Checked;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            textBox1.Clear();
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {
            textBox1.Font = new Font("宋体", (float)numericUpDown1.Value);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            append(textBox3.Text);
        }




    }
}
