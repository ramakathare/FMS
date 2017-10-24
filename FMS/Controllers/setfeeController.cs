using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Linq.Dynamic;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using System.Data.Objects.DataClasses;
using System.Data.Objects;
using System.Data.Entity.Infrastructure;
using FMS.Models;
using FMS.Helper;
namespace FMS.Controllers
{ 
    public class setfeeController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /setfee/
        [Secure]
        public ViewResult Index()
        {
            ViewBag.batchid = new SelectList(db.batches, "id", "name", db.batches.OrderBy("name desc").FirstOrDefault().id);
            //ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.OrderByDescending(s => s.year).FirstOrDefault().id);
            //ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type", db.feetypes.Min(s => s.id));
            //var setfees = db.setfees.Include(s => s.feetype).Include(s => s.student).Include(s => s.acayear);
            return View();//View(setfees.ToList());
        }
        [Secure]
        public ViewResult bulkSetFee()
        {
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.OrderByDescending(s=>s.year).FirstOrDefault().id);
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name");
            ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type", db.feetypes.Min(s=>s.id));
            return View();
        }

        [onlyAuthorize]
        public ActionResult subGrid(int studentid)
        {
            Int32 studentid1 = Convert.ToInt32(studentid);

            var setfees1 = db.setfees.Where(d => d.studentid.Equals(studentid1));
            var setfess = setfees1.Select(s => new
                             {
                                 AcaYear = s.acayear.year,
                                 FeeType = s.feetype.type,
                                 Amount = s.amount,
                                 Concessions = (from p in db.concessions
                                                where p.studentid == s.studentid
                                                where p.acaYearid == s.acaYearid
                                                where p.feeTypeid == s.feeTypeid
                                                select (long?)p.amount).Sum() ?? 0,// getTotalConcessions(s.studentid, s.acaYearid, s.feeTypeid),
                                 Payments = (from p in db.payfees
                                                     where p.studentid == s.studentid
                                                     where p.acaYearid == s.acaYearid
                                                     where p.feeTypeid == s.feeTypeid
                                                     select (long?)p.amount).Sum() ?? 0,
                                 Due = (s.amount -
                                                 ((from p in db.concessions
                                                   where p.studentid == s.studentid
                                                   where p.acaYearid == s.acaYearid
                                                   where p.feeTypeid == s.feeTypeid
                                                   select (long?)p.amount).Sum() ?? 0)) -
                                                 ((from p in db.payfees
                                                   where p.studentid == s.studentid
                                                   where p.acaYearid == s.acaYearid
                                                   where p.feeTypeid == s.feeTypeid
                                                   select (long?)p.amount).Sum() ?? 0),
                                 InstallmentsLeft = ((from p in db.feetypes
                                                         where p.id == s.feeTypeid
                                                         select p.allowedInstallments).FirstOrDefault() -
                                                         (short)(from p in db.payfees
                                                     where p.studentid == s.studentid
                                                     where p.acaYearid == s.acaYearid
                                                     where p.feeTypeid == s.feeTypeid select p.id).Count())
                             }).OrderByDescending(p => p.AcaYear).ThenByDescending(p => p.FeeType).ToList();

            var jsonSubGridData = new{
                studentName = db.students.Find(studentid).name,
                rows = setfess
            };
            return Json(jsonSubGridData, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult toGrid( string sidx, 
                                    string sord, 
                                    int? page, 
                                    int? rows, 
                                    string HTNo, 
                                    string Name, 
                                    int? Batchid, 
                                    string Quota, 
                                    string Caste, string Dept, string Sem,
                                    bool? feeExemption)
        {

            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var setfees = db.setfees.AsQueryable();

            if (Batchid.HasValue)
            {
                Int32 Batchid1 = Convert.ToInt32(Batchid);
                setfees = setfees.Where(s => s.student.batchid.Equals(Batchid1));
            }

            if (feeExemption.HasValue) setfees = setfees.Where(s => s.student.feeExemption.Equals((bool)feeExemption));

            setfees = setfees.Where(s =>
                    s.student.htno.Contains(HTNo) &&
                    s.student.name.Contains(Name) &&
                    s.student.quota.name.Contains(Quota) &&
                    s.student.caste.name.Contains(Caste) &&
                    s.student.dept.name.Contains(Dept) &&
                    s.student.sem.name.Contains(Sem));
            

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var setfees1 = setfees.Select(s => new
                                    {
                                        studentid = s.student.id,
                                        HTNo = s.student.htno,
                                        Name = s.student.name,
                                        Semester = s.student.sem.name,
                                        Batch = s.student.batch.name,
                                        Quota = s.student.quota.name,
                                        Caste = s.student.caste.name,
                                        FeeExemption = s.student.feeExemption
                                    }).Distinct();

            int totalRecords = setfees1.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = setfees1.OrderBy(orderBy).Skip(pageIndex * pageSize).Take(pageSize).ToList(),
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }



        

        [onlyAuthorize]
        [HttpPost]
        public ActionResult ValidateBulkSetFeeGrid(int? acayearid, int? feetypeid)
        {
            if (!acayearid.HasValue || !feetypeid.HasValue) return Json(new{success = false,message = "Either 'Academic Year' or 'Fee Type' is not selected"}, JsonRequestBehavior.AllowGet);
            return Json(new { success = true, message = "valid" }, JsonRequestBehavior.AllowGet);
        }

        //[HttpPost]
        [onlyAuthorize]
        public ActionResult bulkSetFeeGrid(string sidx, string sord, int? page, int? rows, string Dept, string Quota, string Sem, int? acayearid, int? feetypeid, bool? feeExemption)
        {

            if (!acayearid.HasValue || !feetypeid.HasValue)
            {
                return Json("", JsonRequestBehavior.AllowGet);
            }
            
            short acaYearShort = db.acayears.Find(acayearid).year;
            string AcaYear = acaYearShort.ToString();
            string FeeType = db.feetypes.Find(feetypeid).type;
            var students1 = db.students.
                                Where(s => s.dept.name.Contains(Dept) && 
                                s.sem.name.Contains(Sem) && 
                                s.batch.name.CompareTo(acaYearShort) <= 0);

            if (feeExemption.HasValue) students1 = students1.Where(s => s.feeExemption.Equals((bool)feeExemption));

            if (Quota != null && Quota != "null")
            {
                
                var Quotas = Quota.Split(',');
                for (int i = 0; i < Quotas.Count(); i++) Quotas[i] = "quotaid==" + Quotas[i];
                string where = String.Join(" || ", Quotas);
                students1 = students1.Where(where);
            }
            
            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 70;
            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = students1.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            Int32 acayearid1 = Convert.ToInt32(acayearid);
            Int32 feetypeid1 = Convert.ToInt32(feetypeid);

            var students = students1.Select(s => new {
                                sem = s.sem.name, 
                                quota = s.quota.name, 
                                setfeeid=s.setfees.Where(sf=>sf.studentid.Equals(s.id) && sf.feeTypeid.Equals(feetypeid1) && sf.acaYearid.Equals(acayearid1)).Select(sf=>sf.id), 
                                studentid = s.id, 
                                HTNo = s.htno, 
                                Name = s.name,
                                acayearid = acayearid1, 
                                AcaYear = AcaYear,
                                feetypeid = feetypeid1, 
                                FeeType = FeeType,
                                FeeExemption = s.feeExemption,
                                Amount = s.setfees.Where(sf=>sf.studentid.Equals(s.id) && sf.feeTypeid.Equals(feetypeid1) && sf.acaYearid.Equals(acayearid1)).Select(sf=>sf.amount)})
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();

            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = students
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /setfee/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            setfee setfee = db.setfees.Find(id);
            return View(setfee);
        }

        //
        // GET: /setfee/Create
        [Secure]
        public ActionResult Create()
        {
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type");
            ViewBag.studentid = new SelectList(db.students, "id", "htno");
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year");
            return View();
        } 

        //
        // POST: /setfee/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(setfee setfee)
        {

            if (setFeeExists(setfee)) ModelState.AddModelError(string.Empty, "Record already exists");

            short thisAcaYear = db.acayears.Find(setfee.acaYearid).year;
            short batch = db.students.Find(setfee.studentid).batch.name;

            if (thisAcaYear < batch) ModelState.AddModelError(string.Empty, "Fee can't be set to student where acayear < batch");
            if (ModelState.IsValid)
            {
                db.setfees.Add(setfee);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", setfee.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", setfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", setfee.acaYearid);
            return View(setfee);
        }

        [onlyAuthorize]
        public bool setFeeExists(setfee setfee)
        {
            var setfees = db.setfees.Where(d => d.studentid.Equals(setfee.studentid)).Where(d => d.feeTypeid.Equals(setfee.feeTypeid)).Where(d => d.acaYearid.Equals(setfee.acaYearid));
            if (setfee.id.CompareTo(0) > 0)
            {
                return (setfees.Where(d => !d.id.Equals(setfee.id)).Count() > 0); 
            }
            return (setfees.Count() > 0);
        }


        //
        // GET: /setfee/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            setfee setfee = db.setfees.Find(id);
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", setfee.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", setfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", setfee.acaYearid);
            return View(setfee);
        }

        //
        // POST: /setfee/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult gridAddOrUpdate(setfee setfee)
        {
           
            if (setFeeExists(setfee)) return Json(new { success = false, message = "Record Already Exists" }, JsonRequestBehavior.AllowGet);
            if (setfee.id.CompareTo(0) > 0)
            {
                feeEntities db1 = new feeEntities();
                if (setfee.amount<0)
                {
                    setfee setfee1 = db.setfees.Find(setfee.id);
                    db.setfees.Remove(setfee1);
                }
                else
                {
                    long previousAmount = db1.setfees.Find(setfee.id).amount;
                    db1.Dispose();
                    //long previousAmount = setfees.AsQueryable().FirstOrDefault().amount;
                    if (setfee.amount < previousAmount) return Json(new { success = false, message = "You cannot decrease amount, try adding concession instead" }, JsonRequestBehavior.AllowGet);
                    db.Entry(setfee).State = EntityState.Modified;
                    //return Json(new { success = true, message = setfee.id.CompareTo(0)>0 }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                db.setfees.Add(setfee);
                //return Json(new { success = true, message = setfee.id.CompareTo(0) > 0 }, JsonRequestBehavior.AllowGet);
            }
                db.SaveChanges();
                return Json(new { success = true, message = "Record saved successfully" }, JsonRequestBehavior.AllowGet);
        }

        [Secure]
        [HttpPost]
        public ActionResult Edit(setfee setfee)
        {
            if (setFeeExists(setfee)) ModelState.AddModelError(string.Empty, "Record already exists");
            if (ModelState.IsValid)
            {
                db.Entry(setfee).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", setfee.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", setfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", setfee.acaYearid);
            return View(setfee);
        }

        //
        // GET: /setfee/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            setfee setfee = db.setfees.Find(id);
            return View(setfee);
        }

        //
        // POST: /setfee/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            setfee setfee = db.setfees.Find(id);
            db.setfees.Remove(setfee);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public long getTotalPayments(int studentid, int acaYearid, int feeTypeid)
        {
            feeEntities db = new feeEntities();
            var payfees = db.payfees.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid));
            long totalPayments = 0;
            foreach (payfee payfee1 in payfees)
            {
                totalPayments += payfee1.amount;
            }
            return totalPayments;
        }

        public long getTotalConcessions(int studentid, int acaYearid, int feeTypeid)
        {
            feeEntities db = new feeEntities();
            var concessions = db.concessions.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid));
            long totalConcessions = 0;
            foreach (concession concession in concessions)
            {
                totalConcessions += concession.amount;
            }
            return totalConcessions;
        }

        public long getOutStandingDue(int studentid, int acaYearid, int feeTypeid)
        {
            feeEntities db = new feeEntities();
            long assignedAmount = db.setfees.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid)).FirstOrDefault().amount;
           
            long totalConcessions = getTotalConcessions(studentid, acaYearid, feeTypeid);
            long requiredAmoutAfterConcession = assignedAmount - totalConcessions;

            long totalPayments = getTotalPayments(studentid, acaYearid, feeTypeid);

            long outStandingDue = requiredAmoutAfterConcession - totalPayments;
            return outStandingDue;
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}