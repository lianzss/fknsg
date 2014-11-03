using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Auxiliary
{
   public class Auxiliary
    {
        public delegate void OutputDelegate(String str);
        public OutputDelegate OutPut;
        static Random _random = new Random();
        public Task task;
        public Engine engine;
        public LoginType loginstatus = LoginType.LOGOUTED;
        public enum LoginType
        {
            LOGOUTED = 0x00,
            LONOUTING = 0x01,
            LONGINED = 0x02,
            LONGINNING = 0x03,
        }
        public static int Random(int mix, int max)
        {
            return _random.Next(mix, max);
        }

        public Task SetTask(Task task)
        {
            if (this.task != null && this.task.GetType() == task.GetType())
            {
                return task;
            }
            if (this.task != null)
            {
                this.task.Stop();
            }
            task.Init(this);
            this.task = task;
            return task;
        }

        
    }
}
