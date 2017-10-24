using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;

namespace FMS.Controllers
{ 
    public class chequeController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /cheque/

        public ViewResult Index()
        {
            var cheques = db.cheques.Include(c => c.payfee);
            return View(cheques.ToList());
        }

        //
        // GET: /cheque/Details/5

        public ViewResult Details(int id)
        {
            cheque cheque = db.cheques.Find(id);
            return View(cheque);
        }

        //
        // GET: /cheque/Create

        public ActionResult Create()
        {
            ViewBag.payFeeid = new SelectList(db.payfees, "id", "id");
            return View();
        } 

        //
        // POST: /cheque/Create

        [HttpPost]
        public ActionResult Create(cheque cheque)
        {
            if (ModelState.IsValid)
            {
                db.cheques.Add(cheque);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.payFeeid = new SelectList(db.payfees, "id", "id", cheque.payFeeid);
            return View(cheque);
        }
        
        //
        // GET: /cheque/Edit/5
 
        public ActionResult Edit(int id)
        {
            cheque cheque = db.cheques.Find(id);
            ViewBag.payFeeid = new SelectList(db.payfees, "id", "id", cheque.payFeeid);
            return View(cheque);
        }

        //
        // POST: /cheque/Edit/5

        [HttpPost]
        public ActionResult Edit(cheque cheque)
        {
            if (ModelState.IsValid)
            {
                db.Entry(cheque).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.payFeeid = new SelectList(db.payfees, "id", "id", cheque.payFeeid);
            return View(cheque);
        }

        //
        // GET: /cheque/Delete/5
 
        public ActionResult Delete(int id)
        {
            cheque cheque = db.cheques.Find(id);
            return View(cheque);
        }

        //
        // POST: /cheque/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            cheque cheque = db.cheques.Find(id);
            db.cheques.Remove(cheque);
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