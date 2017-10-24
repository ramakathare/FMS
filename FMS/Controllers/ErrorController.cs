using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FMS.Controllers
{
    public class ErrorController : Controller
    {
        //
        // GET: /Error/
       
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult ErrorOccured(String Message)
        {
            ViewBag.Message = Message;
            return View();
        }
        public ViewResult redirectToLogin()
        {
            return new ViewResult { ViewName = "notLoggedin" };
        }

    }
}
