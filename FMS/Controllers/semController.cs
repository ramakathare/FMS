using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq.Dynamic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;

namespace FMS.Controllers
{ 
    public class semController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /sem/
        [Secure]
        public ViewResult Index()
        {
           // var sems = db.sems.Include(s => s.dept);
            return View();//(sems.ToList());
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows)
        {
            if (sidx == null) sidx = "name";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var sems = db.sems;

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = sems.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var roleModules1 = sems.AsQueryable().Select(s => new { 
                                 id=s.id,
                                 deptid=s.deptid,
                                 dept=s.dept.name,
                                 name=s.name, 
                                 desc=s.desc,
                                 students=s.students.Count() 
                                 }).OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = roleModules1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult semDropDownFromDept(long deptid)
        {
            return Json(db.sems.Where("deptid="+deptid).Select(s=>new {s.id,s.name}).ToList(), JsonRequestBehavior.AllowGet);
        }

        [Secure]
        public ActionResult gridAddOrUpdate(sem sem)
        {
            try
            {
                db.Entry(sem).State = EntityState.Modified;
                db.SaveChanges();
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Record not updated" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "Record updated" }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [Secure]
        public ActionResult DeleteFromGrid(int id)
        {
            try
            {
                sem sem = db.sems.Find(id);
                db.sems.Remove(sem);
                db.SaveChanges();
                return Json(new { success = true, message = "Deleted succesfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Not deleted" }, JsonRequestBehavior.AllowGet);
            }

        }

        [onlyAuthorize]
        public ActionResult semAutoComplete(string Dept, string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.sems.Where(d => d.dept.name.Contains(Dept) && d.name.Contains(term)).Select(d => d.name).ToList(), JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult semAutoCompleteWithId(string Dept, string term)
        {
            if (term.Trim().Equals("")) term = "";
            return Json(db.sems.Where(d => d.dept.name.Contains(Dept) && d.name.Contains(term)).Select(d => new { id = d.id, label = d.name }).ToList(), JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ViewResult searchDept(int? id)
        {

            ViewBag.deptid = new SelectList(db.depts, "id", "name");
            if (id.HasValue)
            {
                int ss = Convert.ToInt32(id);
                var sems = db.sems.Include(s => s.dept).Where(s => s.dept.id.Equals(ss));
                ViewData["selectedListItemid"] = id;
                return View("index", sems.ToList());
            }
            else
                return View("index", db.sems.Include(s => s.dept).ToList());
        }

        //
        // GET: /sem/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            sem sem = db.sems.Find(id);
            return View(sem);
        }

        //
        // GET: /sem/Create

        [Secure]
        public ActionResult Create()
        {
            ViewBag.deptid = new SelectList(db.depts, "id", "name");
            return View();
        } 

        //
        // POST: /sem/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(sem sem)
        {
            if (ModelState.IsValid)
            {
                db.sems.Add(sem);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.deptid = new SelectList(db.depts, "id", "name", sem.deptid);
            return View(sem);
        }
        
        //
        // GET: /sem/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            sem sem = db.sems.Find(id);
            ViewBag.deptid = new SelectList(db.depts, "id", "name", sem.deptid);
            return View(sem);
        }

        //
        // POST: /sem/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(sem sem)
        {
            if (ModelState.IsValid)
            {
                db.Entry(sem).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.deptid = new SelectList(db.depts, "id", "name", sem.deptid);
            return View(sem);
        }

        //
        // GET: /sem/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            sem sem = db.sems.Find(id);
            return View(sem);
        }

        //
        // POST: /sem/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            sem sem = db.sems.Find(id);
            db.sems.Remove(sem);
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