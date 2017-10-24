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
    public class casteController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /caste/
        [Secure]
        public ViewResult Index()
        {
            
            return View(db.castes.ToList());
        }

        [onlyAuthorize]
        private Boolean isUniqueCasteName(string name)
        {
            return (db.castes.Where(b => b.name.Equals(name)).Count() <= 0);
        }

        [onlyAuthorize]
        public ActionResult casteAutoComplete(string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.castes.Where(d => d.name.Contains(term)).Select(d => d.name).ToList(), JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /caste/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            caste caste = db.castes.Find(id);
            return View(caste);
        }

        //
        // GET: /caste/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /caste/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(caste caste)
        {
            if (!isUniqueCasteName(caste.name)) ModelState.AddModelError(String.Empty, "Caste already exists");
            if (ModelState.IsValid)
            {
                db.castes.Add(caste);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(caste);
        }
        
        //
        // GET: /caste/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            caste caste = db.castes.Find(id);
            return View(caste);
        }

        //
        // POST: /caste/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(caste caste)
        {
            if (!isUniqueCasteName(caste.name)) ModelState.AddModelError(String.Empty, "Caste already exists");
            if (ModelState.IsValid)
            {
                db.Entry(caste).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(caste);
        }

        //
        // GET: /caste/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            caste caste = db.castes.Find(id);
            return View(caste);
        }

        //
        // POST: /caste/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            caste caste = db.castes.Find(id);
            db.castes.Remove(caste);
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