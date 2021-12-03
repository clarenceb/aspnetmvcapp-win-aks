using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;

namespace aspnetmvcapp.Models
{
    public class SystemInfo
    {
        private PerformanceCounter ramCounter;

        public SystemInfo()
        {
            InitializeRAMCounter();
        }

        public string MemoryAvailable
        {
            get
            {
                return Convert.ToInt32(ramCounter.NextValue()).ToString() + " MB";
            }
        }

        private void InitializeRAMCounter()
        {
            ramCounter = new PerformanceCounter("Memory", "Available MBytes", true);

        }
    }
}