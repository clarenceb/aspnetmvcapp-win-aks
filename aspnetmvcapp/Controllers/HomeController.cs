using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Runtime.InteropServices;
using aspnetmvcapp.Models;

namespace aspnetmvcapp.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            Console.WriteLine("Viewing Index page");

            return View();
        }

        public ActionResult About()
        {
            Console.WriteLine("Viewing About page");
            return View();
        }

        public ActionResult Contact()
        {
            Console.WriteLine("Viewing Contact page");

            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}
