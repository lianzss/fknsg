using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace Auxiliary
{
    public abstract class Task
    {
        Thread CurrentTask;
        public Auxiliary MyAuxiliary;
        public bool IsStop=true;
        public bool IsPause = false;
        public int CurrentIndex = 0;
        public void Stop()
        {
            IsStop = true;
            CurrentTask = null;
        }
       
        public  void Pause()
        {
            IsPause = true;
        }
        public void Continue()
        {
            IsPause = false;
        }
        public void Init(Auxiliary a)
        {
            MyAuxiliary = a;
        }
        public void Start()
        {
            if (MyAuxiliary.loginstatus != Auxiliary.LoginType.LONGINED)
            {
                MyAuxiliary.OutPut("未登录状态，无法启动任务");
                return;
            }
            IsStop = false;
            IsPause = false;
            CurrentTask = new Thread(new ThreadStart(Run));
            CurrentTask.Start();
        }

        
        public void Run()
        {
            while (!IsStop)
            {
                if (!IsPause)
                {
                    if (!Go())
                    {
                        IsStop = true;
                        return;
                    }
                }else
                {
                    PauseToDo();
                }
                Thread.Sleep(500);
            }
        }

        public void PauseToDo()
        {

        }

        public bool Go()
        {
            return true;
        }
    }
}
