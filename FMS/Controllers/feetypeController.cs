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
    public class feetypeController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /feeType/
        [Secure]
        public ViewResult Index()
        {
            return View(db.feetypes.ToList());
        }


        [onlyAuthorize]
        public ActionResult feeTypeAutoComplete(string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.feetypes.Where(d => d.type.Contains(term)).Select(d => new { id = d.id, value = d.type }).ToList(), JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /feeType/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            feetype feetype = db.feetypes.Find(id);
            return View(feetype);
        }

        //
        // GET: /feeType/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /feeType/Create

        [Secure]
        [HttpPost]
        public ActionResult Create(feetype feetype)
        {
            if (feetype.allowedInstallments == 0) ModelState.AddModelError("", "0 is not valid for Allowed Installments");
            if (ModelState.IsValid)
            {
                db.feetypes.Add(feetype);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(feetype);
        }
        
        //
        // GET: /feeType/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            feetype feetype = db.feetypes.Find(id);
            return View(feetype);
        }

        //
        // POST: /feeType/Edit/5

        [HttpPost]
        public ActionResult Edit(feetype feetype)
        {
            if (feetype.allowedInstallments == 0) ModelState.AddModelError("", "0 is not valid for Allowed Installments");
            if (ModelState.IsValid)
            {
                db.Entry(feetype).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(feetype);
        }

        //
        // GET: /feeType/Delete/5
 
        public ActionResult Delete(int id)
        {
            feetype feetype = db.feetypes.Find(id);
            return View(feetype);
        }

        //
        // POST: /feeType/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            feetype feetype = db.feetypes.Find(id);
            db.feetypes.Remove(feetype);
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