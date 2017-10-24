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
    public class batchController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /batch/

        [Secure]
        public ViewResult Index()
        {
            return View(db.batches.ToList());
        }

        [onlyAuthorize]
        public ActionResult batchAutoComplete(string term)
        {
            short item = 0;
            bool result = short.TryParse(term, out item);
            var batchess = db.batches.Where(s => s.name.CompareTo(item) >= 0).Take(10).ToList().AsQueryable().Select(d => new { id = d.id, value = d.name.ToString() }).ToList();
            return Json(batchess, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /batch/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            batch batch = db.batches.Find(id);
            return View(batch);
        }

        //
        // GET: /batch/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /batch/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(batch batch)
        {
            if (!isUniqueBatchName(batch.name)) ModelState.AddModelError(String.Empty,"Batch already exists");
            if (ModelState.IsValid)
            {
                db.batches.Add(batch);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }
            return View(batch);
        }

        [onlyAuthorize]
        private Boolean isUniqueBatchName(short name)
        {
            return (db.batches.Where(b=>b.name.Equals(name)).Count()<=0);
        }
        
        //
        // GET: /batch/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            batch batch = db.batches.Find(id);
            return View(batch);
        }

        //
        // POST: /batch/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(batch batch)
        {
            if (!isUniqueBatchName(batch.name)) ModelState.AddModelError(String.Empty, "Batch already exists");
            if (ModelState.IsValid)
            {
                
                db.Entry(batch).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(batch);
        }

        //
        // GET: /batch/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            batch batch = db.batches.Find(id);
            return View(batch);
        }

        //
        // POST: /batch/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            batch batch = db.batches.Find(id);
            db.batches.Remove(batch);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [HttpPost]
        public JsonResult isUnique(short name)
        {
            return Json(false,JsonRequestBehavior.AllowGet);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}