using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;
using FMS.Data;

namespace FMS.Controllers
{
    
    public class acayearController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /acayear/

        [Secure]
        public ViewResult Index()
        {
            return View(db.acayears.ToList());
        }

        [onlyAuthorize]
        public ActionResult acaYearAutoComplete(string term)
        {
            short item = 0;
            bool result = short.TryParse(term, out item);
            var acaYears = db.acayears.Where(d => d.year.CompareTo(item) >= 0).Take(10).ToList().AsQueryable().Select(d => new { id = d.id, value = d.year.ToString() }).Take(10).ToList();
            return Json(acaYears, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        private Boolean isUniqueAcaYear(short year)
        {
            return (db.acayears.Where(b => b.year.Equals(year)).Count() <= 0);
        }

        //
        // GET: /acayear/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            acayear acayear = db.acayears.Find(id);
            return View(acayear);
        }

        //
        // GET: /acayear/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /acayear/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(acayear acayear)
        {
            if (!isUniqueAcaYear(acayear.year)) ModelState.AddModelError(String.Empty, "Academic Year already exists");
            if (ModelState.IsValid)
            {
                db.acayears.Add(acayear);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(acayear);
        }
        
        //
        // GET: /acayear/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            acayear acayear = db.acayears.Find(id);
            return View(acayear);
        }

        //
        // POST: /acayear/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(acayear acayear)
        {
            if (!isUniqueAcaYear(acayear.year)) ModelState.AddModelError(String.Empty, "Academic Year already exists");
            if (ModelState.IsValid)
            {
                db.Entry(acayear).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(acayear);
        }

        //
        // GET: /acayear/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            acayear acayear = db.acayears.Find(id);
            return View(acayear);
        }

        //
        // POST: /acayear/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            acayear acayear = db.acayears.Find(id);
            db.acayears.Remove(acayear);
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