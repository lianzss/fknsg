﻿

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.IO;

namespace Sanguo
{
   public  class Config
    {
        public string username = "jason2133";  //username
        public string pwd = "112233";    //password
        public string servername = "";
        public string pid = "";
        public string uuid = "1f2bcae7-16a6-306e-a3c7-5036d3bda8f1";  //phone device id
        public int serverindex = 117;     //selected server,start from 0
        public ArrayList serverlist = new ArrayList();
        public string hash = "";
        public string token = "0";
        public string time;
        public string uid;



        public string publishVersion = "3.0.3";
        public string scriptVersion = "2.6.2";
        public string pl = "Android_zyx";
        public string fixVersion = "2";
        public string sysName = "TODO";
        public string sysVersion = "4.3";
        public string deviceModel = "LT29i";


        public Int32 copyID = 1;
        public Int32 baseID = 1001;
        public Int32 baseLevel = 0;
        public Int32 armyID = 1006;


        public Int32 battlecopyID = 1;
        public Int32 battlebaseID = 1001;
        public Int32 battlebaseLevel = 1;
        public Int32 battlearmyID = 1003;


        public Int32 heroID = 0;

        public Int32 battleFlag = 4;   //if set the battle Flag to 4 ,it means the role is finish the 1st battle.

        public string filePath = "file.txt";
        public Dictionary<string, object> formation;

        public Int32 count = 4;


    }
}
