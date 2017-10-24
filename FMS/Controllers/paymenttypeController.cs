using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;

namespace FMS.Controllers
{ 
    public class paymenttypeController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /paymenttype/

        [Secure]
        public ViewResult Index()
        {
            return View(db.paymenttypes.ToList());
        }

        //
        // GET: /paymenttype/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            paymenttype paymenttype = db.paymenttypes.Find(id);
            return View(paymenttype);
        }

        //
        // GET: /paymenttype/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /paymenttype/Create

        [Secure]
        [HttpPost]
        public ActionResult Create(paymenttype paymenttype)
        {
            if (ModelState.IsValid)
            {
                db.paymenttypes.Add(paymenttype);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(paymenttype);
        }
        
        //
        // GET: /paymenttype/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            paymenttype paymenttype = db.paymenttypes.Find(id);
            return View(paymenttype);
        }

        //
        // POST: /paymenttype/Edit/5

        [Secure]
        [HttpPost]
        public ActionResult Edit(paymenttype paymenttype)
        {
            if (ModelState.IsValid)
            {
                db.Entry(paymenttype).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(paymenttype);
        }

        //
        // GET: /paymenttype/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            paymenttype paymenttype = db.paymenttypes.Find(id);
            return View(paymenttype);
        }

        //
        // POST: /paymenttype/Delete/5

        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            paymenttype paymenttype = db.paymenttypes.Find(id);
            db.paymenttypes.Remove(paymenttype);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}