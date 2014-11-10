#define DEBUG_MODE

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Auxiliary;
using System.Xml;
using System.IO;
using WPE.AMF.AmfData;
using WPE;
using System.Security.Cryptography;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


namespace Sanguo
{

   public class Game:Auxiliary.Auxiliary
    {
        static void Main()
        {
            Console.WriteLine("hello");
            Game game = new Game();

            game.Register();
            game.Start();
        }

        public Config config;
        public StreamWriter sw;
        public FileStream afile;

        public Game()
        {
            config = new Config();
            this.OutPut = O;
        }

        public void Register()
        {

            afile = new FileStream(config.filePath, FileMode.Append);
            sw = new StreamWriter(afile);

            HttpClient wc = new HttpClient();
            string str ="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";  // length is 63
            Random r = new Random();
            string username = null;
            string password = null;
            string email = null;
            XmlDocument doc = new XmlDocument();
             string errno;


            do
            {
                username = string.Empty;
                password = string.Empty;
                email = string.Empty;
                for (int i = 0; i < 8; i++)
                {
                    string tmp = str.Substring(r.Next(0, 63), 1);
                    username += tmp;
                }


                for (int i = 0; i < 6; i++)
                {
                    string tmp = str.Substring(r.Next(0, 63), 1);
                    password += tmp;
                }

                for (int i = 0; i < 10; i++)
                {
                    string tmp = str.Substring(r.Next(0, 10), 1);   
                    email += tmp;
                }

                email += "qq.com";

                string registerUrl = "http://mapifknsg.zuiyouxi.com/phone/login/?action=register&pl=Mjbaidupinzhuan&gn=sanguo&os=android&other_pl=zyxphone&uuid=1f2bcae7-16a6-306e-a3c7-5036d3bda8f1&username=" + username + "&password=" + password + "&email="+email+"&bind=0000000000";

                string registerResult = System.Text.Encoding.UTF8.GetString(wc.DownloadData(registerUrl));

                doc.Load(new StringReader(registerResult));
                XmlNode mainnode = doc.SelectSingleNode("root");
                    //XmlNodeList childnodes = mainnode.SelectNodes("item");
                XmlNode errnoXML = mainnode.SelectSingleNode("errornu");
                errno = errnoXML.InnerText;

            } while (errno.Equals("1"));
            Console.WriteLine("register done!");
            config.username = username;
            config.pwd = password;

            sw.WriteLine("usernmae:" + username + "          password:" + password);
            sw.Close();
        }



        public void Start()
        {
           // config.username = "lianzs";
           // config.pwd = "4822012";
            //get the serverlist
            HttpClient wc = new HttpClient();
            string getServersUrl = "http://mapifknsg.zuiyouxi.com/phone/serverlistnotice/?&pl=Mjbaidupinzhuan&gn=sanguo&os=android&other_pl=zyxphone";
            String serverlistxml = System.Text.Encoding.UTF8.GetString(wc.DownloadData(getServersUrl));
            parseServers(serverlistxml);


            //get the pid
            string getUserPidUrl = "http://mapifknsg.zuiyouxi.com/phone/login/?&pl=Mjbaidupinzhuan&gn=sanguo&os=android&action=login&username=" + config.username + "&password=" + config.pwd + "&ext=&bind=0000000000&other_pl=zyxphone&uuid=" + config.uuid;
            String pidxml= System.Text.Encoding.UTF8.GetString(wc.DownloadData(getUserPidUrl));
            parsePid(pidxml);
            O("pid:"+config.pid);


            //check the version ,return json data ,the program can ignore it.
            string checkVersionUrl = "http://mapifknsg.zuiyouxi.com/phone/get3dVersion?&packageVersion=3.0.3&scriptVersion=2.6.5&pl=Mjbaidupinzhuan&gn=sanguo&os=android&extend=sysName_TODO,sysVersion_4.3,deviceModel_LT29i";
            string checkVersionresult = System.Text.Encoding.UTF8.GetString(wc.DownloadData(checkVersionUrl));
            O(checkVersionresult);
            Dictionary<string, string> checkVersionjson = JsonConvert.DeserializeObject<Dictionary<string,string>>(checkVersionresult);
           // JObject checkVersionJson = JObject.Parse(cehckVersionresult);
            if (!checkVersionjson["error_id"].ToString().Equals("200"))
            {
                O("Need to update the version!err =" + checkVersionjson["error_id"].ToString());
                Console.Read();
            }

            //
            //enter the game
            //


            //get the notice
            string noticeurl = "http://mapifknsg.zuiyouxi.com/phone/notice?pl=Mjbaidupinzhuan&gn=sanguo&os=android&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey=" + ((string[])config.serverlist[config.serverindex])[4];
            string noticeresult = System.Text.Encoding.UTF8.GetString(wc.DownloadData(noticeurl));
            O(noticeresult);

            //get the hash data
            string getHashUrl = "http://mapifknsg.zuiyouxi.com/phone/getHash/?&group_id=" + ((string[])config.serverlist[config.serverindex])[4] + "&pid=" + config.pid + "&uuid=" + config.uuid;
            String hashstr = System.Text.Encoding.UTF8.GetString(wc.DownloadData(getHashUrl));
           //Dictionary<string,object> hash=  parseHash(hashstr);
            Dictionary<string, string> hash = JsonConvert.DeserializeObject<Dictionary<string, string>>(hashstr);

            //start to communication
            Login(hash);
 
        }



        public void Send(Dictionary<string, object> d)
        {
            engine.SendData(packetData(d));
        }

       //1
        public void Login(Dictionary<string,string> hash)
        {
            Dictionary<string, object> login = new Dictionary<string, object>();
            login["method"] = "user.login";
            login["callback"] = getObject("callbackName", "user.login");
            login["token"] = config.token;
            object[] args = new object[2];
            //hash["forumURL"] = "http://mapifknsg.zuiyouxi.com/";
            // hash["pay_url"] = "http://mapifknsg.zuiyouxi.com/";
            // hash["bbsUrl"] = "http://mapifknsg.zuiyouxi.com/";
            // hash["forumURL"] = "http://mapifknsg.zuiyouxi.com/";
            args[0] = hash;
            args[1] = "publish="+config.publishVersion+", script="+config.scriptVersion+", pl="+config.pl+", fixversion="+config.fixVersion+", sysName="+config.sysName+", sysVersion="+config.sysVersion+", deviceModel="+config.deviceModel;
            login["args"] = args;

            byte[] buf3 = CAmf3Helper.GetBytes(login);
            object readBack3 = CAmf3Helper.GetObject(buf3);
            //O(readBack3.ToString());
            //O(Inspector.Inspect(packetData(login)));
            engine = new SocketEngine(this, ((string[])config.serverlist[config.serverindex])[1], int.Parse(((string[])config.serverlist[config.serverindex])[2]));
            engine.SendData(packetData(login));
        }


       //

       //获取阵型
        public void getFormation()
        {
            Dictionary<string, object> d = getObject("method", "formation.getFormation");
            d["callback"] = getObject("callbackName", "IFormation.getFormation");
            d["token"] = config.token;
            d["args"] = new object[0];
            Send(d);
        }

        public void parseFormation(CNameObjDict co)
        {
            CMixArray cm = (CMixArray)co["ret"];
            Dictionary<string, object> formation = new Dictionary<string, object>();
            for (int i = 0; i < 6; i++)
            {
                formation[i.ToString()] = cm[i];
            }
            config.formation = formation;
        }

        public void startBattle()
        {
            if (config.battleFlag < 4)
            {
                start1stBattle();
            }
            else if (4 <= config.battleFlag && config.battleFlag < 8)
            {
                 start2ndBattle();
            }
            else
            {

            }

        }

        public void enter1stBaseLevel()
        {
            Dictionary<string, object> d = getObject("method", "ncopy.enterBaseLevel");
            d["callback"] = getObject("callbackName", "ncopy.enterBaseLevel");
            d["token"] = config.token;
            //config.battlebaseID = config.battlecopyID * 1000 + config.battlebaseID;
            //config.baseID = config.copyID * 1000 + config.baseID;

            config.baseID = 1001;
            config.copyID = 1;
            config.baseLevel = 0;
            //config.armyID = 1006;
            d["args"] = new object[3] { config.copyID, config.baseID, config.baseLevel };

            Send(d);
        }

        public void enter2ndBaseLevel()
        {
            Dictionary<string, object> d = getObject("method", "ncopy.enterBaseLevel");
            d["callback"] = getObject("callbackName", "ncopy.enterBaseLevel");
            d["token"] = config.token;
            //config.battlebaseID = config.battlecopyID * 1000 + config.battlebaseID;
            //config.baseID = config.copyID * 1000 + config.baseID;

            config.baseID = 1002;
            config.copyID = 1;
            config.baseLevel = 0;

            d["args"] = new object[3] { config.copyID, config.baseID, config.baseLevel };

            Send(d);
        }


       public void start1stBattle()
       {
           switch (config.battleFlag)
           {
               case 0:
                   do1st_1stBattle();
                   config.battleFlag++;
                   break;
               case 1:
                   do1st_2ndBattle();
                   config.battleFlag++;
                   break;
               case 2:
                   do1st_3rdBattle();
                   config.battleFlag++;
                   break;
               case 3:
                   do1st_4thBattle();
                   config.battleFlag++;
                   break;
               default:
                   leaveBaseLevel();                 
                   break;
           }
       }


       public void start2ndBattle()
       {
           switch (config.battleFlag)
           {
               case 4:
                   do2nd_1stBattle();
                   config.battleFlag++;
                   break;
               case 5:
                   do2nd_2ndBattle();
                   config.battleFlag++;
                   break;
               case 6:
                   do2nd_3rdBattle();
                   config.battleFlag++;
                   break;
               case 7:
                   do2nd_4thBattle();
                   config.battleFlag++;
                   break;
               default:
                   //doBattle();
                   break;
           }
       }

        public void doBattle()
        {
            config.baseID = 2;
            config.copyID = 1;
            config.baseLevel = 1;
            config.armyID = 1006;
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            //config.formation["4"] = 3011562;
            //config.formation["0"] = 3011561;
            d["args"] = new object[5] { config.battlecopyID, config.battlebaseID, config.battlebaseLevel, config.battlearmyID, new Dictionary<string, object>() };
           // d["args"] = new object[5] { config.battlecopyID, config.battlebaseID, config.battlebaseLevel, config.battlearmyID, config.formation };
            Send(d);
        }
       //1st base
        public void do1st_1stBattle()
        {

            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490016;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }
        public void do1st_2ndBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490017;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }

        public void do1st_3rdBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490018;
            //config.baseID = config.copyID * 1000 + config.baseID;
            config.formation["4"] = 3011701;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }


        public void do1st_4thBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490020;
            //config.baseID = config.copyID * 1000 + config.baseID;
            config.formation["4"] = 3011562;
            config.formation["0"] = 3011561;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }


       //2nd base
        public void do2nd_1stBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490021;

            config.formation["4"] = 3011721;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }
        public void do2nd_2ndBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490022;

            config.formation["4"] = 3011731;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }
        public void do2nd_3rdBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490023;

            config.formation["4"] = 3011751;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }
        public void do2nd_4thBattle()
        {
            System.Threading.Thread.Sleep(1000);
            Dictionary<string, object> d = getObject("method", "ncopy.doBattle");
            d["callback"] = getObject("callbackName", "ncopy.doBattle");
            d["token"] = config.token;
            config.armyID = 490024;

            config.formation["4"] = 3011572;
            config.formation["0"] = 3011571;
            //config.baseID = config.copyID * 1000 + config.baseID;
            d["args"] = new object[6] { config.copyID, config.baseID, config.baseLevel, config.armyID, new CMixArray(0), config.formation };
            Send(d);
        }


        public void leaveBaseLevel()
        {
            Dictionary<string, object> d = getObject("method", "ncopy.leaveBaseLevel");
            d["callback"] = getObject("callbackName", "ncopy.leaveBaseLevel");
            d["token"] = config.token;
            d["args"] = new object[3] { config.copyID, config.baseID, config.baseLevel};
            Send(d);

        }


       
        //login funs
        public void getUsers()
        {
            Dictionary<string, object> d = getObject("method", "user.getUsers");
            d["callback"] = getObject("callbackName", "user.getUsers");
            d["token"] = config.token;
            d["args"] = new object[0];
            Send(d);
        }

        public string RandomName()
        {
            string str = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";  // length is 63
            string rolename = null;
            Random r = new Random();
            for (int i = 0; i < 8; i++)
            {
                string tmp = str.Substring(r.Next(0, 63), 1);
                rolename += tmp;
            }
            return rolename;
        }

        public void createUser(string rolename)
        {
            Dictionary<string, object> d = getObject("method", "user.createUser");
            d["callback"] = getObject("callbackName", "user.createUser");
            d["token"] = config.token;
            d["args"] = new object[2]{"2",rolename};
            Send(d);
        }

        public void getBagInfo()
        {
            Dictionary<string, object> d = getObject("method", "bag.bagInfo");
            d["callback"] = getObject("callbackName", "bag.bagInfo");
            d["token"] = config.token;
            d["args"] = new object[0];
            Send(d);
        }
        public void getUser()
        {
            Dictionary<string, object> d = getObject("method", "user.getUser");
            d["callback"] = getObject("callbackName", "user.getUser");
            d["token"] = config.token;
            d["args"] = new object[0];
            Send(d);
        }


        public void userLogin()
        {
            Dictionary<string, object> d = getObject("method", "user.userLogin");
            d["callback"] = getObject("callbackName", "user.userLogin");
            d["token"] = config.token;
            d["args"] = new object[1] { config.uid };
            Send(d);
        }

        public void getSwitchInfo()
        {
            Dictionary<string, object> d = getObject("method", "user.getSwitchInfo");
            d["callback"] = getObject("callbackName", "user.getSwitchInfo");
            d["token"] = config.token;
            d["args"] = new object[1] { config.uid };
            Send(d);
        }

        public void getRewardList()
        {
            Dictionary<string, object> d = getObject("method", "reward.getRewardList");
            d["callback"] = getObject("callbackName", "reward.getRewardList");
            d["token"] = config.token;
            d["args"] = new object[2]{ "0","0" };
            Send(d);
        }

        public void bagInfo()
        {
            Dictionary<string, object> d = getObject("method", "bag.bagInfo");
            d["callback"] = getObject("callbackName", "bag.bagInfo");
            d["token"] = config.token;
            d["args"] = new object[0];
            Send(d);
        }

        public void getActivityConf()
        {
            Dictionary<string, object> d = getObject("method", "activity.getActivityConf");
            d["callback"] = getObject("callbackName", "activity.getActivityConf");
            d["token"] = config.token;
            d["args"] = new object[1] { 1415609344 }; // this is get from the config version..
            Send(d);
        }

        public void SetHerorID(Int32 heroID)
        {
            config.heroID = heroID;
        }
       //login funs end



        public byte[] packetData(object o)
        {
            byte[] buf3 = CAmf3Helper.GetBytes(o);
            int len=buf3.Length;
            MemoryStream ms = new MemoryStream();
            ms.WriteByte((byte)(len >> 24 & 0xff));
            ms.WriteByte((byte)(len >> 16 & 0xff));
            ms.WriteByte((byte)(len >> 8 & 0xff));
            ms.WriteByte((byte)(len & 0xff));
            ms.WriteByte(1);
            ms.WriteByte(0);
            ms.WriteByte(1);
            ms.WriteByte(1);
            MD5 md5 = MD5.Create();
            ms.Write(md5.ComputeHash(yihuo(buf3)), 0, 16);
            ms.Write(buf3, 0, len);
           
            return ms.ToArray();
        }

        public static byte[] yihuo(byte[] b)
        {
            byte[] result = new byte[b.Length + 9];
            result[0] = (byte)'B';
            result[1] = (byte)'a';
            result[2] = (byte)'b';
            result[3] = (byte)'e';
            result[4] = (byte)'l';
            result[5] = (byte)'T';
            result[6] = (byte)'i';
            result[7] = (byte)'m';
            result[8] = (byte)'e';
            int i = 0;
            while (i < b.Length)
            {
                byte v8;
                if (i == b.Length - 1)
                    v8 = (byte)((b[i] ^ b.Length) & 0xFF);
                else
                    v8 = (byte)(b[i] ^ b[i + 1]);
                result[i + 9] = v8;
                ++i;
            }
            return result;
        }

        public void O(String o)
        {
            Console.WriteLine(o);
        }

        public static Dictionary<string, object> getObject(string str, object o)
        {
          Dictionary<string, object>  a=  new Dictionary<string, object>();
            a[str]=o;
            return a;
        }

        public String getXMLValue(XmlNode x, string value)
        {
            return x.SelectSingleNode(value).InnerText.Trim();
        }

        public void parseServers(String serverlistxml)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(new StringReader(serverlistxml));
            XmlNode mainnode = doc.SelectSingleNode("root");
            XmlNodeList childnodes = mainnode.SelectNodes("item");
            foreach (XmlNode childnode in childnodes)
            {
                String[] server = new string[5];
                server[0] = getXMLValue(childnode, "name");
                server[1] = getXMLValue(childnode, "host");
                server[2] = getXMLValue(childnode, "port");
                server[3] = getXMLValue(childnode, "server_id");
                server[4] = getXMLValue(childnode, "group");
                config.serverlist.Add(server);
            }
        }
        public Dictionary<string, object> parseHash(string data)
        {
            data = data.Replace("{", "").Replace("}", "");
            string[] d = data.Split(',');
            Dictionary<string, object> dy = new Dictionary<string, object>();
            foreach (string dd in d)
            {
                string[] d2 = dd.Split(new char[]{':'});
                string ddd1 = d2[0].Replace("\"", "");
                if (d2[1].IndexOf("\"") >= 0)
                {
                    dy[ddd1] = d2[1].Replace("\"", "").Replace("\\","");
                }
                else
                {
                        dy[ddd1] = int.Parse(d2[1]);
                        Console.WriteLine(ddd1 + ":" + d2[1]);
                }
            }
            config.hash = dy["hash"].ToString();
            return dy;
        }

        public void parsePid(String xml)
        {
            O(xml);
            XmlDocument doc = new XmlDocument();
            doc.Load(new StringReader(xml));
            config.pid = doc.ChildNodes[1].ChildNodes[1].InnerText;
        }
    }
}
