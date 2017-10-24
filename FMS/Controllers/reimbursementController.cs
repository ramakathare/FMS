using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Linq.Dynamic;
using FMS;using FMS.Data;
using FMS.Helper;

namespace FMS.Controllers
{ 
    public class reimbursementController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /reimbursement/
        [Secure]
        public ViewResult Index()
        {
            //var reimbursements = db.reimbursements.Include(r => r.acayear).Include(r => r.student);
            ViewBag.batchid = new SelectList(db.batches, "id", "name");
            ViewBag.casteid = new SelectList(db.castes, "id", "name");
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.Max(s => s.year));
            return View();
        }

        [Secure]
        public ViewResult bulkreimbursement()
        {
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.Max(s => s.year));
            return View();
        }

        [onlyAuthorize]
        public ActionResult epassidAutoComplete(string term, int max)
        {
            return Json(db.reimbursements.Where(d => d.epassid.Contains(term)).Select(d => d.epassid).Take(max).ToList(), JsonRequestBehavior.AllowGet);
        }


        [onlyAuthorize]
        public ActionResult toGrid(     string sidx,
                                        string sord,
                                        int? page,
                                        int? rows,
                                        string HTNo,
                                        string Name,
                                        string Batchid,
                                        string acayearid,
                                        string Caste,
                                        string Dept,
                                        string Sem,
                                        string epassid,
                                        bool? Approved)
        {
            if (sidx == null) sidx = "epassid";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            

            var reimbursements = db.reimbursements.Where(s =>
                s.student.dept.name.Contains(Dept) &&
                s.student.sem.name.Contains(Sem) &&
                s.student.htno.Contains(HTNo) &&
                s.epassid.Contains(epassid) &&
                s.student.name.Contains(Name));

            if (Approved.HasValue) reimbursements = reimbursements.Where(s => s.approved.Equals((bool)Approved));
            

            if (acayearid != null && acayearid != "null")
            {
                var acayearids = acayearid.Split(',');
                for (int i = 0; i < acayearids.Count(); i++) acayearids[i] = "acaYearid==" + acayearids[i];

                string where = String.Join(" || ", acayearids);

                reimbursements = reimbursements.Where(where);
            }

            if (Batchid != null && Batchid != "null")
            {
                var Batchids = Batchid.Split(',');

                for (int i = 0; i < Batchids.Count(); i++) Batchids[i] = "student.batchid==" + Batchids[i];

                string where = String.Join(" || ", Batchids);
                reimbursements = reimbursements.Where(where);
            }

            if (Caste != null && Caste != "null")
            {
                var Castes = Caste.Split(',');

                for (int i = 0; i < Castes.Count(); i++) Castes[i] = "student.casteid==" + Castes[i];

                string where = String.Join(" || ", Castes);
                reimbursements = reimbursements.Where(where);
            }

            
            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = reimbursements.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var reimbursements1 = reimbursements.AsQueryable().Select(s => new
            {
                id = s.id,
                HTNo = s.student.htno,
                Name = s.student.name,
                Semester = s.student.sem.name,
                Batch = s.student.batch.name,
                Caste = s.student.caste.name,
                AcaYear = s.acayear.year,
                epassid = s.epassid,
                remarks = s.remarks,
                approved = s.approved,
                date = s.date
            })
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = reimbursements1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult bulkReimbursementToGrid(string sidx,
                                        string sord,
                                        int? page,
                                        int? rows,
                                        string HTNos,
                                        int acayearid,
                                        bool Approved)
        {
            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            string where="true";

            List<string> notFound =new List<string>();
            List<string> NoFeeExemption = new List<string>();
            List<string> finalHTs = new List<string>();
            Dictionary<string, string> htids = new Dictionary<string, string>();

            if (HTNos != null && HTNos != "null" && HTNos!="")
            {
                HTNos = HTNos.TrimEnd().TrimStart();
                var HTNoss = HTNos.Split('\n');
                int i=0;
                foreach (var item in HTNoss)
                {
                    i++;
                    String term = item.TrimEnd().TrimStart().ToString();
                    if (term.Length != 23 || term.IndexOf(',') <= 0)
                    {
                        return Json(new
                                    {
                                        total = 1,
                                        page = 1,
                                        records = 0,
                                        HallTicketNotFound = "",
                                        NoFeeExemption = "",
                                        error = "Error at line "+i,
                                        rows = ""
                                    }, JsonRequestBehavior.AllowGet);
                    }
                    string currentHTNo = term.Split(',')[0];
                    string currentid = term.Split(',')[1];

                    if (db.students.Any(x => x.htno == currentHTNo))
                    {
                        if (db.students.Any(s => s.htno == currentHTNo && !s.feeExemption))
                            NoFeeExemption.Add(currentHTNo);
                        else
                        {
                            finalHTs.Add("htno==\"" + currentHTNo + "\"");
                            htids.Add(currentHTNo, currentid);
                        }
                            
                    }
                    else notFound.Add(currentHTNo);
                }
                if(finalHTs.Count()>0)
                where = String.Join(" || ", finalHTs);
            }
            else
            {
                return Json(new
                {
                    total = 1,
                    page = 1,
                    records = 0,
                    HallTicketNotFound = "",
                    NoFeeExemption = "",
                    error= "No Data given",
                    rows = ""
                }, JsonRequestBehavior.AllowGet);
            }

            var students = db.students.Where(where);
            
            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = students.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            short acayearidYear = db.acayears.Find(acayearid).year;

            var students1 = students.ToList().AsQueryable().Select(s => new
            {
                studentid = s.id,
                acayearid = acayearid,
                exists = s.reimbursements.Any(y => y.studentid.Equals(s.id) && y.acaYearid.Equals(acayearid)),
                existingid = s.reimbursements.Where(z => z.studentid.Equals(s.id) && z.acaYearid.Equals(acayearid)).Select(z => z.id).FirstOrDefault(),
                HTNo = s.htno,
                Name = s.name,
                Semester = s.sem.name,
                Batch = s.batch.name,
                Caste = s.caste.name,
                AcaYear = acayearidYear,
                epassid = (db.reimbursements.Any(r => r.studentid.Equals(s.id) && r.acaYearid.Equals(acayearid)) ?
                                        (from p in db.reimbursements
                                         where p.studentid == s.id
                                         where p.acaYearid == acayearid
                                         select p.epassid).FirstOrDefault() : htids[s.htno]),
                remarks = (from p in db.reimbursements
                                               where p.studentid == s.id
                                               where p.acaYearid == acayearid
                                               select p.remarks),
                approved = (db.reimbursements.Any(r => r.studentid.Equals(s.id) && r.acaYearid.Equals(acayearid)) ?
                                        (from p in db.reimbursements
                                         where p.studentid == s.id
                                         where p.acaYearid == acayearid
                                         select p.approved).FirstOrDefault() : Approved)
            })
                                // Uses System.Linq.Dynamic library for sorting
                                .OrderBy(orderBy)
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                HallTicketNotFound = notFound.ToArray(),
                NoFeeExemption = NoFeeExemption.ToArray(),
                error="",
                rows = students1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [Secure]
        [HttpPost]
        public ActionResult gridAddOrUpdate(reimbursement rb)
        {
     
            if (db.reimbursements.Any(s => s.acaYearid == rb.acaYearid && s.studentid == rb.studentid))
            {
                if (db.reimbursements.Where(s => s.acaYearid == rb.acaYearid && s.studentid == rb.studentid).Select(s=>s.id).ToList().AsQueryable().FirstOrDefault() != rb.id)
                {
                    return Json(new { success = false, message = "Record Already Exists" }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    db.Entry(rb).State = EntityState.Modified;
                }
            }
            else
            {
                rb.date = DateTime.Now;
                db.reimbursements.Add(rb);
            }
            db.SaveChanges();
            return Json(new { success = true, message = "Record saved successfully" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /reimbursement/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            reimbursement reimbursement = db.reimbursements.Find(id);
            return View(reimbursement);
        }

        //
        // GET: /reimbursement/Create
        [Secure]
        public ActionResult Create()
        {
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year",db.acayears.Max(s=>s.year));
            ViewBag.studentid = new SelectList(db.students, "id", "htno");
            return View();
        } 

        //
        // POST: /reimbursement/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(reimbursement reimbursement)
        {
            if (db.reimbursements.Any(s => s.studentid.Equals(reimbursement.studentid) && s.acaYearid.Equals(reimbursement.acaYearid)))
                ModelState.AddModelError("", "Record exists with the given paramerts");
            if (ModelState.IsValid)
            {
                reimbursement.date = DateTime.Now;
                db.reimbursements.Add(reimbursement);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", reimbursement.acaYearid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", reimbursement.studentid);
            return View(reimbursement);
        }
        
        //
        // GET: /reimbursement/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            reimbursement reimbursement = db.reimbursements.Find(id);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", reimbursement.acaYearid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", reimbursement.studentid);
            return View(reimbursement);
        }

        //
        // POST: /reimbursement/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult Edit(reimbursement reimbursement)
        {
            if (db.reimbursements.Any(s => s.studentid.Equals(reimbursement.studentid) && s.acaYearid.Equals(reimbursement.acaYearid)) && reimbursement.id!=db.reimbursements.Where(s => s.studentid.Equals(reimbursement.studentid) && s.acaYearid.Equals(reimbursement.acaYearid)).FirstOrDefault().id)
                ModelState.AddModelError("", "Record exists with the given paramerts");
            
            if (ModelState.IsValid)
            {
                db.Entry(reimbursement).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", reimbursement.acaYearid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", reimbursement.studentid);
            return View(reimbursement);
        }

        //
        // GET: /reimbursement/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            reimbursement reimbursement = db.reimbursements.Find(id);
            return View(reimbursement);
        }

        //
        // POST: /reimbursement/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            reimbursement reimbursement = db.reimbursements.Find(id);
            db.reimbursements.Remove(reimbursement);
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