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
    public class deptController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /dept/
        [Secure]
        public ViewResult Index()
        {
            return View(db.depts.ToList());
        }

        [onlyAuthorize]
        public ActionResult deptAutoComplete(string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.depts.Where(d => d.name.Contains(term)).Select(d => d.name).ToList(), JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /dept/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            dept dept = db.depts.Find(id);
            return View(dept);
        }

        //
        // GET: /dept/Create
        [Secure]
        public ActionResult Create()
        {
            ViewBag.collegeid = new SelectList(db.colleges,"collegeid","collegeName");
            return View();
        }


        [onlyAuthorize]
        public bool deptExits(dept dept)
        {
            var depts = db.depts.Where(d => d.name.Equals(dept.name));
            if (dept.id.CompareTo(0) > 0)
            {
                return (depts.Where(d => !d.id.Equals(dept.id)).Count() > 0);
            }
            return (depts.Count() > 0);
        }

        //
        // POST: /dept/Create

        [Secure]
        [HttpPost]
        public ActionResult Create(dept dept)
        {
            if (deptExits(dept)) ModelState.AddModelError("", "Department Already Exists");
            if (ModelState.IsValid)
            {
                db.depts.Add(dept);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }
            ViewBag.collegeid = new SelectList(db.colleges, "collegeid", "collegeName", dept.collegeid);
            return View(dept);
        }
        
        //
        // GET: /dept/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            dept dept = db.depts.Find(id);
            ViewBag.collegeid = new SelectList(db.colleges, "collegeid", "collegeName", dept.collegeid);
            return View(dept);
        }

        //
        // POST: /dept/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(dept dept)
        {
            if (deptExits(dept)) ModelState.AddModelError("", "Department Already Exists");
            if (ModelState.IsValid)
            {
                db.Entry(dept).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.collegeid = new SelectList(db.colleges, "collegeid", "collegeName", dept.collegeid);
            return View(dept);
        }

        //
        // GET: /dept/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            dept dept = db.depts.Find(id);
            return View(dept);
        }

        //
        // POST: /dept/Delete/5

        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            dept dept = db.depts.Find(id);
            db.depts.Remove(dept);
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