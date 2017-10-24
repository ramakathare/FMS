using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS.Helper;

namespace FMS.Controllers
{
    public class MasterController : Controller
    {
        //
        // GET: /Master/
        [onlyAuthorize]
        public ActionResult Index()
        {
            return View();
        }

    }
}
