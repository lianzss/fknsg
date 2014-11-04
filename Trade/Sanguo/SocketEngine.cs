using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Auxiliary;
using System.Net.Sockets;
using WPE;
using WPE.AMF.AmfData;

namespace Sanguo
{
   public class SocketEngine:Engine
    {
       Game g;
       public SocketEngine(Auxiliary.Auxiliary a, string ip, int port)
           : base(a, ip, port)
       {
           g = (Game)a;
       }

        public override  bool ParseStream(NetworkStream ns)
        {
            if (!ns.DataAvailable)
                return false;
            int len =( ns.ReadByte() << 24) + (ns.ReadByte() << 16) +( ns.ReadByte() << 8 )+ ns.ReadByte();
            byte[] data = new byte[len];
            byte[] head = new byte[4];
            ns.Read(head, 0, 4);
            ns.Read(data, 0, len);
            MyAuxiliary.OutPut(Inspector.Inspect(data));
            CNameObjDict co = ((CNameObjDict)CAmf3Helper.GetObject(data));
            MyAuxiliary.OutPut(co.ToString());
            ParseData(co);
            return true;
        }

        public void ParseData(CNameObjDict data)
        {
            try
            {
              
                CNameObjDict co=data;
                if (data.ContainsKey("err"))
                {
                    co = (CNameObjDict)data["callback"];
                    if (co["callbackName"].ToString().Equals("re.chat.getMsg"))
                    {
                        return;
                    }

                }

                ((Game)MyAuxiliary).config.token=data["token"].ToString();
                 ((Game)MyAuxiliary).config.time=data["time"].ToString();
                 if (data.ContainsKey("ret"))
                 {
                     co = (CNameObjDict)((CMixArray)data["ret"])[0];
                 }
                 string callback = ((CNameObjDict)co["callback"])["callbackName"].ToString();
                 switch (callback)
                 {
                     case "user.login":
                         g.getUsers();
                         break;

                     case "user.getUsers":
                         if (CheckUser(co))
                         {
                             ParseUsers(co);
                             g.userLogin();
                         }
                         else
                         {
                             g.createUser(g.RandomName());
                         }
                         break;
                     case "user.userLogin":
                         g.getUser();
                         break;

                     case "user.getUser":
                         ParseUser(co);
                         g.getSwitchInfo();
                         break;

                     case "user.createUser":
                         g.getUsers();
                         break;

                     case "re.chat.getMsg":
                         break;

                     case "user.getSwitchInfo":
                         g.getRewardList();
                         break;

                     case "reward.getRewardList":
                         g.bagInfo();
                         break;

                     case "bag.bagInfo":
                         g.getActivityConf();
                         break;
                         /*
                          there are many activies here ,but if the client can keep online ,it's ok.
                          */
                     case "activity.getActivityConf":
                         //let's do battle
                         g.getFormation();
                         break;
                     case "IFormation.getFormation":
                         g.parseFormation(co);
                         g.enterBaseLevel();                         
                         //g.SetHerorID(GetHeroID(co));
                         break;
                     case "ncopy.enterBaseLevel":

                         //g.doBattle();
                        // System.Threading.Thread.Sleep(5000);
                         g.startBattle();

                         break;
                     case "ncopy.doBattle":
                         if (g.config.battleFlag < 4)
                         {
                             g.startBattle();
                         }
                         else
                         {
                             g.leaveBaseLevel();
                         }                         
                         break;
                     case "ncopy.leaveBaseLevel":
                         //g.config = new Config();
                         //g.enterBaseLevel();
                         break;
                     default://user.getSwitchInfo
                         break;
                 }
            }
            catch(Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }


        public bool CheckUser(CNameObjDict co )
        {
            CMixArray c = (CMixArray)co["ret"];
            if (c.FixedLength > 0)
                return true;    // the server has role
            else
                return false;    //don't have role
        }


        public void ParseUser(CNameObjDict co)
        {
            g.OutPut(co.ToString());
        }

        public void ParseUsers(CNameObjDict co)
        {
            CNameObjDict c = (CNameObjDict)((CMixArray)co["ret"])[0];
            string uid = c["uid"].ToString();
            string utid = c["utid"].ToString();
            string uname = c["uname"].ToString();
            g.config.uid = uid;
        }

        public int GetHeroID(CNameObjDict co)
        {
            CMixArray c = (CMixArray)co["ret"];
            return c.Int(1);
        }

        public  void Refresh()
        {

        }

    }
}
