using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Linq.Dynamic;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;

namespace FMS.Controllers
{

    public class studentController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /student/

        [Secure]
        public ViewResult Index()
        {
            ViewBag.batchid = new SelectList(db.batches,"id", "name");
            // var students = db.students.Include(s => s.batch).Include(s => s.caste).Include(s => s.dept).Include(s => s.quota).Include(s => s.sem);
            return View();//students.ToList());
        }

        [onlyAuthorize]
        public ActionResult getHTNo(int? studentid)
        {

            if (studentid.HasValue)
            {
                Int32 id = Convert.ToInt32(studentid);
                return Json(new {HallTicketNo=db.students.Find(id).htno.ToString()},JsonRequestBehavior.AllowGet);
            }
            else return Json(new { HallTicketNo = ""}, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult HTNoAutoComplete(string Dept, string Sem, string term, int max)
        {
            return Json(db.students.Where(d => d.dept.name.Contains(Dept) && d.sem.name.Contains(Sem) && d.htno.Contains(term)).Select(d=>d.htno).Take(max).ToList(), JsonRequestBehavior.AllowGet);
        }

       
        [onlyAuthorize]
        public ActionResult HTNoAutoCompleteWithId_Nodeptsem(string term, int max)
        {
            return Json(db.students.Where(d => d.htno.Contains(term)).Select(d => new { id = d.id, label = d.htno }).Take(max).ToList(), JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult HTNoAutoCompleteWithId(string term, int max,string Dept, string Sem)
        {
            return Json(db.students.Where(d => d.dept.name.Contains(Dept) && d.sem.name.Contains(Sem) && d.htno.Contains(term)).Select(d => new { id = d.id, label = d.htno }).Take(max).ToList(), JsonRequestBehavior.AllowGet);
        }
        //
        [onlyAuthorize]
        public ActionResult toGrid( string sidx, 
                                    string sord, 
                                    int? page, int? rows, 
                                    string HTNo, 
                                    string Name, 
                                    int? Batchid, 
                                    string Quota, 
                                    string Caste, 
                                    string Dept, 
                                    string Sem,
                                    bool? feeExemption)
        {
            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var students = db.students.AsQueryable();

            if(feeExemption.HasValue) students = students.Where(s => s.feeExemption.Equals((bool)feeExemption));
            
            if (Batchid.HasValue)
            {
                Int32 batchid1 = Convert.ToInt32(Batchid);
                students = students.Where(s => s.batch.id.Equals(batchid1));
            }

            var names = Name.Split(' ');
            foreach (var item in names)
            {
                students = students.Where("name.Contains(@0)",item);
            }

            students = students.Where(s => 
                    s.htno.Contains(HTNo) &&
                    s.quota.name.Contains(Quota) &&
                    s.caste.name.Contains(Caste) &&
                    s.dept.name.Contains(Dept) &&
                    s.sem.name.Contains(Sem));
            
            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = students.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var students1 = students.Select(s => new { 
                                id = s.id, 
                                HTNo = s.htno, 
                                Name = s.name, 
                                Semester = s.sem.name, 
                                Batch = s.batch.name, 
                                Quota = s.quota.name, 
                                Caste = s.caste.name,
                                FeeExemption = s.feeExemption})
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = students1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }



        //
        // GET: /student/Details/5

        [Secure]
        public ViewResult Details(int id)
        {

            student student = db.students.Find(id);
            return View(student);
        }

        //
        // GET: /student/Create

        [Secure]
        public ActionResult Create()
        {
            ViewBag.viewName = "Create Student";
            ViewBag.batchid = new SelectList(db.batches, "id", "name");
            ViewBag.casteid = new SelectList(db.castes, "id", "name");
            ViewBag.deptid = new SelectList(db.depts, "id", "name");
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name");
            ViewBag.semid = new SelectList(db.sems, "id", "name");
            return View();
        }

        //
        // POST: /student/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(student student)
        {
            if (ModelState.IsValid)
            {
                db.students.Add(student);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.batchid = new SelectList(db.batches, "id", "name", student.batchid);
            ViewBag.casteid = new SelectList(db.castes, "id", "name", student.casteid);
            ViewBag.deptid = new SelectList(db.depts, "id", "name", student.deptid);
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name", student.quotaid);
            ViewBag.semid = new SelectList(db.sems, "id", "name", student.semid);
            return View(student);
        }

        //
        // GET: /student/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {

            student student = db.students.Find(id);
            ViewBag.batchid = new SelectList(db.batches, "id", "name", student.batchid);
            ViewBag.casteid = new SelectList(db.castes, "id", "name", student.casteid);
            ViewBag.deptid = new SelectList(db.depts, "id", "name", student.deptid);
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name", student.quotaid);
            ViewBag.semid = new SelectList(db.sems, "id", "name", student.semid);
            return View(student);
        }

        //
        // POST: /student/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(student student)
        {
            if (ModelState.IsValid)
            {
                if (!db.sems.Find(student.semid).deptid.Equals(student.deptid)) 
                    ModelState.AddModelError("", "Semester selected does not exist in the Department selected");
            }
            
            
            
            if (ModelState.IsValid)
            {
                db.Entry(student).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.batchid = new SelectList(db.batches, "id", "name", student.batchid);
            ViewBag.casteid = new SelectList(db.castes, "id", "name", student.casteid);
            ViewBag.deptid = new SelectList(db.depts, "id", "name", student.deptid);
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name", student.quotaid);
            ViewBag.semid = new SelectList(db.sems, "id", "name", student.semid);
            return View(student);
        }

        //
        // GET: /student/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {

            student student = db.students.Find(id);
            return View(student);
        }

        //
        // POST: /student/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {
            student student = db.students.Find(id);
            db.students.Remove(student);
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
