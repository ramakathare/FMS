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
using System.IO;

namespace FMS.Controllers
{ 
    public class concessionController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /concession/
        [Secure]
        public ViewResult Index()
        {
            ViewBag.batchid = new SelectList(db.batches, "id", "name");
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name");
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year");
            ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type");
            return View();
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx,
                                        string sord,
                                        int? page,
                                        int? rows,
                                        string HTNo,
                                        string Name,
                                        string Batchid,
                                        string feetypeid,
                                        string acayearid,
                                        string Quota,
                                        string Caste,
                                        string Dept,
                                        string Sem,
                                        DateTime? Time1,
                                        DateTime? Time2)
        {

            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var concessions = db.concessions.Where(s =>
                    s.student.htno.Contains(HTNo) &&
                    s.student.name.Contains(Name) &&
                    //s.student.quota.name.Contains(Quota) &&
                    //s.student.caste.name.Contains(Caste) &&
                    s.student.dept.name.Contains(Dept) &&
                    s.student.sem.name.Contains(Sem));

            if (Quota != null && Quota != "null")
            {
                var Quotas = Quota.Split(',');
                for (int i = 0; i < Quotas.Count(); i++) Quotas[i] = "student.quotaid==" + Quotas[i];

                string where = String.Join(" || ", Quotas);

                concessions = concessions.Where(where);
            }

            if (feetypeid != null && feetypeid != "null")
            {
                var feetypeids = feetypeid.Split(',');
                for (int i = 0; i < feetypeids.Count(); i++) feetypeids[i] = "feeTypeid==" + feetypeids[i];

                string where = String.Join(" || ", feetypeids);

                concessions = concessions.Where(where);
            }

            if (acayearid != null && acayearid != "null")
            {
                var acayearids = acayearid.Split(',');
                for (int i = 0; i < acayearids.Count(); i++) acayearids[i] = "acaYearid==" + acayearids[i];

                string where = String.Join(" || ", acayearids);

                concessions = concessions.Where(where);
            }

            if (Batchid != null && Batchid != "null")
            {
                var Batchids = Batchid.Split(',');

                for (int i = 0; i < Batchids.Count(); i++) Batchids[i] = "student.batchid==" + Batchids[i];

                string where = String.Join(" || ", Batchids);
                concessions = concessions.Where(where);
            }
            if (Time1.HasValue)
            {
                DateTime Time11 = Convert.ToDateTime(Time1);
                concessions = concessions.Where(s => s.time.CompareTo(Time11) >= 0);
            }

            if (Time2.HasValue)
            {
                DateTime Time21 = Convert.ToDateTime(Time2);
                concessions = concessions.Where(s => s.time.CompareTo(Time21) <= 0);
            }

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = concessions.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var concessions1 = concessions.AsQueryable().Select(s => new
            {
                id = s.id,
                studentid = s.student.id,
                HTNo = s.student.htno,
                Name = s.student.name,
                Semester = s.student.sem.name,
                Batch = s.student.batch.name,
                Quota = s.student.quota.name,
                Caste = s.student.caste.name,
                AcaYear = s.acayear.year,
                FeeType = s.feetype.type,
                Amount = s.amount,
                Time = s.time,
                Remarks = s.remarks
            })
            .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
            .Skip(pageIndex * pageSize)
            .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = concessions1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }


        [onlyAuthorize]
        public ActionResult exportGridToExcel(string sidx,
                                        string sord,
                                        int? page,
                                        int? rows,
                                        string HTNo,
                                        string Name,
                                        string Batchid,
                                        string feetypeid,
                                        string acayearid,
                                        string Quota,
                                        string Caste,
                                        string Dept,
                                        string Sem,
                                        DateTime? Time1,
                                        DateTime? Time2)
        {
            if (sidx == null) sidx = "Time";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;


            var concessions = db.concessions.Where(s =>
                    s.student.htno.Contains(HTNo) &&
                    s.student.name.Contains(Name) &&
                        //s.student.quota.name.Contains(Quota) &&
                        //s.student.caste.name.Contains(Caste) &&
                    s.student.dept.name.Contains(Dept) &&
                    s.student.sem.name.Contains(Sem));

            if (Quota != null && Quota != "null")
            {
                var Quotas = Quota.Split(',');
                for (int i = 0; i < Quotas.Count(); i++) Quotas[i] = "student.quotaid==" + Quotas[i];

                string where = String.Join(" || ", Quotas);

                concessions = concessions.Where(where);
            }

            if (feetypeid != null && feetypeid != "null")
            {
                var feetypeids = feetypeid.Split(',');
                for (int i = 0; i < feetypeids.Count(); i++) feetypeids[i] = "feeTypeid==" + feetypeids[i];

                string where = String.Join(" || ", feetypeids);

                concessions = concessions.Where(where);
            }

            if (acayearid != null && acayearid != "null")
            {
                var acayearids = acayearid.Split(',');
                for (int i = 0; i < acayearids.Count(); i++) acayearids[i] = "acaYearid==" + acayearids[i];

                string where = String.Join(" || ", acayearids);

                concessions = concessions.Where(where);
            }

            if (Batchid != null && Batchid != "null")
            {
                var Batchids = Batchid.Split(',');

                for (int i = 0; i < Batchids.Count(); i++) Batchids[i] = "student.batchid==" + Batchids[i];

                string where = String.Join(" || ", Batchids);
                concessions = concessions.Where(where);
            }

            if (Time1.HasValue) concessions = concessions.Where(s => s.time.CompareTo(Time1) >= 0);
            if (Time2.HasValue) concessions = concessions.Where(s => s.time.CompareTo(Time2) <= 0);

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = concessions.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            var concessions1 = concessions.AsQueryable().OrderByDescending(p => p.time).Skip(pageIndex * pageSize).Take(pageSize).ToList();

            string html = ControllerExtensions.RenderPartialToString2("exportGridToExcel", concessions1, this.ControllerContext);

            MemoryStream memStream = new MemoryStream();
            TextWriter writer = new StreamWriter(memStream);
            try
            {

                writer.Write(html);
            }
            catch (Exception e)
            {
            }
            finally
            {
                writer.Close();
            }
            return File(memStream.ToArray(), "application/ms-excel", "ConcessionsList.xls");
        }

        //
        // GET: /concession/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            concession concession = db.concessions.Find(id);
            return View(concession);
        }

        //
        // GET: /concession/Create
        [Secure]
        public ActionResult Create()
        {
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type");
            ViewBag.studentid = new SelectList(db.students, "id", "htno");
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year");
            return View();
        }


        public partial class concessionRequiredResponse
        {
            public long amount;
            public string message;
            public concessionRequiredResponse(long a, string m)
            {
                this.amount = a;
                this.message = m;
            }
        }

        [onlyAuthorize]
        public concessionRequiredResponse concessionRequired(concession concession)
        {

            if (concession.amount < 1) return new concessionRequiredResponse(0, "Not a valid amount to allot concession");
            var setfees = db.setfees.Where(d => d.studentid.Equals(concession.studentid)).Where(d => d.feeTypeid.Equals(concession.feeTypeid)).Where(d => d.acaYearid.Equals(concession.acaYearid));
            if (setfees.Count() > 0)
            {
                long outstandingdue = getOutStandingDue(concession.studentid, concession.acaYearid, concession.feeTypeid);
                if (concession.amount > outstandingdue) return new concessionRequiredResponse(0, "Concession is greater than outstandind due: Rs." + outstandingdue);
            }
            else
            {
                return new concessionRequiredResponse(0, "There is no fee set with the given parameters");
            }
            return new concessionRequiredResponse(1, "");
        }

        //
        // POST: /concession/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(concession concession)
        {

            concessionRequiredResponse crr = concessionRequired(concession);
            if (crr.amount <= 0) ModelState.AddModelError(string.Empty, crr.message);
            if (ModelState.IsValid)
            {
                concession.time = DateTime.Now;
                db.concessions.Add(concession);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", concession.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", concession.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", concession.acaYearid);
            return View(concession);
        }
        
        //
        // GET: /concession/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            concession concession = db.concessions.Find(id);
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", concession.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", concession.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", concession.acaYearid);
            return View(concession);
        }

        //
        // POST: /concession/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult Edit(concession concession)
        {
            concessionRequiredResponse crr = concessionRequired(concession);
            if (crr.amount <= 0) ModelState.AddModelError(string.Empty, crr.message);
            if (ModelState.IsValid)
            {
                concession.time = DateTime.Now;
                db.Entry(concession).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", concession.feeTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", concession.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", concession.acaYearid);
            return View(concession);
        }

        //
        // GET: /concession/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            concession concession = db.concessions.Find(id);
            return View(concession);
        }

        //
        // POST: /concession/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            concession concession = db.concessions.Find(id);
            db.concessions.Remove(concession);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public long getTotalPayments(int studentid, int acaYearid, int feeTypeid)
        {
            return db.payfees.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid)).Select(s => s.amount).AsEnumerable().Sum();
        }

        public long getTotalConcessions(int studentid, int acaYearid, int feeTypeid)
        {
            return db.concessions.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid)).Select(s => s.amount).AsEnumerable().Sum();
        }

        public long getOutStandingDue(int studentid, int acaYearid, int feeTypeid)
        {
            return db.setfees.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid)).FirstOrDefault().amount - getTotalConcessions(studentid, acaYearid, feeTypeid) - getTotalPayments(studentid, acaYearid, feeTypeid);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}