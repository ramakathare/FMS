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
    public class quotaController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /quota/
        [Secure]
        public ViewResult Index()
        {
            return View(db.quotas.ToList());
        }
        [onlyAuthorize]
        public ActionResult quotaAutoComplete(string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.quotas.Where(d => d.name.Contains(term)).Select(d => d.name).ToList(), JsonRequestBehavior.AllowGet);
        }
        //
        // GET: /quota/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            quota quota = db.quotas.Find(id);
            return View(quota);
        }

        //
        // GET: /quota/Create
        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /quota/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(quota quota)
        {
            if (ModelState.IsValid)
            {
                db.quotas.Add(quota);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(quota);
        }
        
        //
        // GET: /quota/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            quota quota = db.quotas.Find(id);
            return View(quota);
        }

        //
        // POST: /quota/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult Edit(quota quota)
        {
            if (ModelState.IsValid)
            {
                db.Entry(quota).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(quota);
        }

        //
        // GET: /quota/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            quota quota = db.quotas.Find(id);
            return View(quota);
        }

        //
        // POST: /quota/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            quota quota = db.quotas.Find(id);
            db.quotas.Remove(quota);
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