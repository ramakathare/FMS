using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using System.Linq.Dynamic;
using System.Data.Entity.Validation;
using System.Text;
using System.IO;
using FMS.Helper;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Xml;
using System.Web.UI;
using iTextSharp.text.html.simpleparser;
using iTextSharp.tool.xml;
using System.Data.Objects;
using System.Linq.Expressions;

namespace FMS.Controllers
{
    public class payfeeController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /payfee/
        [Secure]
        public ViewResult Index()
        {
            ViewBag.batchid = new SelectList(db.batches, "id", "name");
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name");
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year");
            ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type");//, db.feetypes.Min(s => s.id));
            //var payfees = db.payfees.Include(p => p.feetype).Include(p => p.paymenttype).Include(p => p.student).Include(p => p.acayear);
            return View();
        }

        [Secure]
        public ViewResult bulkPayFee()
        {
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.OrderByDescending(s => s.year).FirstOrDefault().id);
            ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type", db.feetypes.Min(s => s.id));
            ViewBag.quotaid = new SelectList(db.quotas, "id", "name");
            return View();
        }

        [onlyAuthorize]
        [HttpPost]
        public ActionResult ValidateBulkPayFeeGrid(int? acayearid)
        {
            if (!acayearid.HasValue) return Json(new { success = false, message = "Select Academic Year" }, JsonRequestBehavior.AllowGet);
            return Json(new { success = true, message = "valid" }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Export list of Payments to Excel
        /// </summary>
        /// <param name="sidx"></param>
        /// <param name="sord"></param>
        /// <param name="page"></param>
        /// <param name="rows"></param>
        /// <param name="HTNo"></param>
        /// <param name="Name"></param>
        /// <param name="Batchid"></param>
        /// <param name="Quota"></param>
        /// <param name="Dept"></param>
        /// <param name="Sem"></param>
        /// <param name="Time1"></param>
        /// <param name="Time2"></param>
        /// <returns></returns>
        /// 
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
                                        //string Caste,
                                        string Dept,
                                        string Sem,
                                        DateTime? Time1,
                                        DateTime? Time2)
        {
            if (sidx == null) sidx = "Time";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;


            var payfes = db.payfees.Where(s =>
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

                payfes = payfes.Where(where);
            }

            if (feetypeid != null && feetypeid != "null")
            {
                var feetypeids = feetypeid.Split(',');
                for (int i = 0; i < feetypeids.Count(); i++) feetypeids[i] = "feeTypeid==" + feetypeids[i];

                string where = String.Join(" || ", feetypeids);

                payfes = payfes.Where(where);
            }

            if (acayearid != null && acayearid != "null")
            {
                var acayearids = acayearid.Split(',');
                for (int i = 0; i < acayearids.Count(); i++) acayearids[i] = "acaYearid==" + acayearids[i];

                string where = String.Join(" || ", acayearids);

                payfes = payfes.Where(where);
            }

            if (Batchid != null && Batchid != "null")
            {
                var Batchids = Batchid.Split(',');

                for (int i = 0; i < Batchids.Count(); i++) Batchids[i] = "student.batchid==" + Batchids[i];

                string where = String.Join(" || ", Batchids);
                payfes = payfes.Where(where);
            }

            if (Time1.HasValue) payfes = payfes.Where(s => s.time.CompareTo(Time1) >= 0);
            if (Time2.HasValue) payfes = payfes.Where(s => s.time.CompareTo(Time2) <= 0);

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = payfes.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var payfes1 = payfes.OrderBy(orderBy).Skip(pageIndex * pageSize).Take(pageSize).ToList();

            string html = ControllerExtensions.RenderPartialToString2("exportGridToExcel", payfes1, this.ControllerContext);

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
            return File(memStream.ToArray(), "application/ms-excel", "PaymentsReport.xls");
        }

        /// <summary>
        /// List of Payments to Grid
        /// </summary>
        /// <param name="sidx"></param>
        /// <param name="sord"></param>
        /// <param name="page"></param>
        /// <param name="rows"></param>
        /// <param name="HTNo"></param>
        /// <param name="Name"></param>
        /// <param name="Batchid"></param>
        /// <param name="Quota"></param>
        /// <param name="Caste"></param>
        /// <param name="Dept"></param>
        /// <param name="Sem"></param>
        /// <param name="Time1"></param>
        /// <param name="Time2"></param>
        /// <returns></returns>
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
                                        //string Caste,
                                        string Dept,
                                        string Sem,
                                        DateTime? Time1,
                                        DateTime? Time2)
        {
            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            
            var payfes = db.payfees.Where(s =>
                s.student.htno.Contains(HTNo) &&
                s.student.name.Contains(Name) &&
                //s.student.caste.name.Contains(Caste) &&
                s.student.dept.name.Contains(Dept) &&
                s.student.sem.name.Contains(Sem));

            if (Quota != null && Quota != "null")
            {
                var Quotas = Quota.Split(',');
                for (int i = 0; i < Quotas.Count(); i++) Quotas[i] = "student.quotaid==" + Quotas[i];

                string where = String.Join(" || ", Quotas);

                payfes = payfes.Where(where);
            }
            
            if (feetypeid != null && feetypeid != "null")
            {
                var feetypeids = feetypeid.Split(',');
                for (int i = 0; i < feetypeids.Count(); i++) feetypeids[i] = "feeTypeid==" + feetypeids[i];

                string where = String.Join(" || ", feetypeids);

                payfes = payfes.Where(where);
            }

            if (acayearid != null && acayearid != "null")
            {
                var acayearids = acayearid.Split(',');
                for (int i = 0; i < acayearids.Count(); i++) acayearids[i] = "acaYearid==" + acayearids[i];

                string where = String.Join(" || ", acayearids);

                payfes = payfes.Where(where);
            }

            if (Batchid != null && Batchid != "null")
            {
                var Batchids = Batchid.Split(',');

                for (int i = 0; i < Batchids.Count(); i++) Batchids[i] = "student.batchid==" + Batchids[i];

                string where = String.Join(" || ", Batchids);
                payfes = payfes.Where(where);
            }

            if (Time1.HasValue)
            {
                DateTime Time11 = Convert.ToDateTime(Time1);
                payfes = payfes.Where(s => s.time.CompareTo(Time11) >= 0);
            }

            if (Time2.HasValue)
            {
                DateTime Time21 = Convert.ToDateTime(Time2);
                payfes = payfes.Where(s => s.time.CompareTo(Time21) <= 0);
            }

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = payfes.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var payfes1 = payfes.AsQueryable().Select(s => new
                                {
                                    id = s.id,
                                    studentid = s.student.id,
                                    HTNo = s.student.htno,
                                    Name = s.student.name,
                                    Semester = s.student.sem.name,
                                    Batch = s.student.batch.name,
                                    Quota = s.student.quota.name,
                                    //Caste = s.student.caste.name,
                                    AcaYear = s.acayear.year,
                                    FeeType = s.feetype.type,
                                    Amount = s.amount,
                                    Time = s.time,
                                    receiptNo = s.recieptNo
                                })
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = payfes1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [onlyAuthorize]
        public ActionResult bulkPayFeeGrid(string sidx, string sord, int? page, int? rows, string Dept, string Quota, string Sem, int? acayearid, string feetypeid)
        {

            if (!acayearid.HasValue)
            {
                return Json("", JsonRequestBehavior.AllowGet);
            }


            Int32 acayearid1 = Convert.ToInt32(acayearid);

            var setfees1 = db.setfees.Where(s =>
                            s.acaYearid.Equals(acayearid1) &&
                            s.student.dept.name.Contains(Dept) &&
                            s.student.sem.name.Contains(Sem));

            if (Quota != null && Quota != "null")
            {

                var Quotas = Quota.Split(',');
                for (int i = 0; i < Quotas.Count(); i++) Quotas[i] = "student.quotaid==" + Quotas[i];
                string where = String.Join(" || ", Quotas);
                setfees1 = setfees1.Where(where);
            }

            if (feetypeid != null && feetypeid != "null")
            {
                var feetypeids = feetypeid.Split(',');
                for (int i = 0; i < feetypeids.Count(); i++) feetypeids[i] = "feeTypeid==" + feetypeids[i];

                string where = String.Join(" || ", feetypeids);

                setfees1 = setfees1.Where(where);
            }

            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 70;
            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = setfees1.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var setfees = setfees1.AsQueryable().Select(s => new
            {
                HTNo = s.student.htno,
                Name = s.student.name,
                sem = s.student.sem.name,
                quota = s.student.quota.name,
                FeeType = s.feetype.type,
                AcaYear = s.acayear.year,
                FeeSet = s.amount,
                Concessions = (from p in db.concessions
                               where p.studentid == s.studentid
                               where p.acaYearid == s.acaYearid
                               where p.feeTypeid == s.feeTypeid
                               select (long?)p.amount).Sum() ?? 0,// getTotalConcessions(s.studentid, s.acaYearid, s.feeTypeid),
                previousPayments = (from p in db.payfees
                                    where p.studentid == s.studentid
                                    where p.acaYearid == s.acaYearid
                                    where p.feeTypeid == s.feeTypeid
                                    select (long?)p.amount).Sum() ?? 0,
                currentDue = (s.amount -
                                ((from p in db.concessions
                                  where p.studentid == s.studentid
                                  where p.acaYearid == s.acaYearid
                                  where p.feeTypeid == s.feeTypeid
                                  select (long?)p.amount).Sum() ?? 0)) -
                                ((from p in db.payfees
                                  where p.studentid == s.studentid
                                  where p.acaYearid == s.acaYearid
                                  where p.feeTypeid == s.feeTypeid
                                  select (long?)p.amount).Sum() ?? 0),//getOutStandingDue(s.studentid, s.acaYearid, s.feeTypeid), 
                studentid = s.studentid,
                acayearid = s.acaYearid,
                feetypeid = s.feeTypeid,
                Amount = ""
            })
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();

            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = setfees
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        public partial class payFeeRequiredResponse
        {
            public long amount;
            public string message;
            public payFeeRequiredResponse(long a, string m)
            {
                this.amount = a;
                this.message = m;
            }
        }
        [onlyAuthorize]
        public payFeeRequiredResponse payFeeRequired(payfee payfee)
        {
           
            if (payfee.amount < 100) return new payFeeRequiredResponse(0, "Minimum payment is Rs. 100/-");
            var setfees = db.setfees.Where(d => d.studentid.Equals(payfee.studentid)).Where(d => d.feeTypeid.Equals(payfee.feeTypeid)).Where(d => d.acaYearid.Equals(payfee.acaYearid));
            if (setfees.Count() > 0)
            {
                long outstandingdue = getOutStandingDue(payfee.studentid, payfee.acaYearid, payfee.feeTypeid);

                if (outstandingdue <= 0) return new payFeeRequiredResponse(0, "No due exists, payment is not added");

                if (payfee.amount > outstandingdue)
                    return new payFeeRequiredResponse(0, "Amount being paid is greater than Required Amount, payment is not added");
                else
                {
                    if (installmentsLeft(payfee.studentid, payfee.acaYearid, payfee.feeTypeid)==(short)1 && payfee.amount<outstandingdue)
                    {
                        return new payFeeRequiredResponse(0, "Since this is the final installment clear the due, amount less than outstanding due is not allowed");
                    }
                    return new payFeeRequiredResponse(outstandingdue, "Payment is required");
                }

            }
            return new payFeeRequiredResponse(0, "There is no fee set with this parameters, payment is not added");
        }

        [Secure]
        [HttpPost]
        public ActionResult gridAddOrUpdate(payfee payfee)
        {
            payFeeRequiredResponse pffr = payFeeRequired(payfee);
            if (pffr.amount <= 0) return Json(new { success = false, message = pffr.message }, JsonRequestBehavior.AllowGet);

            int lastid = 1;
            if (db.payfees.Count() > 0) lastid = db.payfees.Max(item => item.id) + 1;
            payfee.time = DateTime.Now;

            var college = db.students.Where(s => s.id.Equals(payfee.studentid)).Select(s => s.dept.name).FirstOrDefault().Substring(0, 3);
            payfee.recieptNo = college + lastid.ToString();//dt.Year.ToString().Substring(2, 2) + dt.Month.ToString() + dt.Day.ToString() + 1;

            // payfee.recieptNo = payfee.student.htno.Substring(0, 4) + lastid;
            payfee.paymentTypeid = 1;

            db.payfees.Add(payfee);
            db.SaveChanges();
            return Json(new { success = true, message = "Payment made successfully" }, JsonRequestBehavior.AllowGet);
            //return Json(new { success = false, message = payfee.id + " " + payfee.amount + " " + payfee.studentid + " " + payfee.acaYearid + " " + payfee.feeTypeid }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /payfee/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            payfee payfee = db.payfees.Find(id);
            return View(payfee);
        }

        [onlyAuthorize]
        public ActionResult Print(int id)
        {
            payfee payfee = db.payfees.Find(id);
            return View(payfee);
        }

        [Secure]
        public ActionResult PrintToPdf(int id)
        {
            payfee payfee = db.payfees.Find(id);

            Document doc = new Document(PageSize.A5);

            // Set the document to write to memory.
            MemoryStream memStream = new MemoryStream();
            PdfWriter writer = PdfWriter.GetInstance(doc, memStream);
            writer.CloseStream = false;
            doc.Open();

            // string html = ControllerExtensions.RenderPartialViewToString(this, "Print", payfee);
            string html = ControllerExtensions.RenderPartialToString2("Print", payfee, this.ControllerContext);

            var dir = Server.MapPath("/Content");
            var path = Path.Combine(dir, "banner_" + payfee.student.dept.college.collegeCode + ".gif");

            Image pic = Image.GetInstance(path);
            //  iTextSharp.text.Image pic = iTextSharp.text.Image.GetInstance(path);

            pic.ScalePercent(76f);
            doc.Add(pic);

            StringReader str = new StringReader(html);

            XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, str);

            if (doc.IsOpen()) doc.Close();

            return new FileContentResult(memStream.ToArray(), "application/pdf");
        }


        //
        // GET: /payfee/Create
        [Secure]
        public ActionResult Create()
        {
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type");
            ViewBag.paymentTypeid = new SelectList(db.paymenttypes, "id", "type",db.paymenttypes.Select(s=>s.id).Min());
            ViewBag.studentid = new SelectList(db.students, "id", "htno");
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year");
            return View();
        }

        //
        // POST: /payfee/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(payfee payfee, string printReciept)
        {
            payFeeRequiredResponse pffr = payFeeRequired(payfee);
            if (pffr.amount <= 0) ModelState.AddModelError(string.Empty, pffr.message);
            if (ModelState.IsValid)
            {
                payfee.time = DateTime.Now;

                int lastid = 1;
                int year = DateTime.Now.Year;
                string lastReceiptNo = "U312100";

                if (db.payfees.Count() > 0)
                {
                    lastid = db.payfees.Max(item => item.id);
                    payfee payfee1 = db.payfees.Find(lastid);
                    year = payfee1.time.Year;
                    lastReceiptNo = payfee1.recieptNo;
                }

                int currentYear = payfee.time.Year;

                int lastDigits = 100;
                if (currentYear <= year)
                {
                    try
                    {
                        lastDigits = int.Parse(lastReceiptNo.Substring(4)) + 1;
                    }
                    catch (Exception e)
                    { }
                }

                payfee.recieptNo = db.students.Find(payfee.studentid).htno.Substring(2, 2) + currentYear.ToString().Substring(2) + (lastDigits.ToString());

                // var college = db.students.Where(s => s.id.Equals(payfee.studentid)).Select(s => s.dept.name).FirstOrDefault().Substring(0, 3);
                // payfee.recieptNo = db.students.Find(payfee.studentid).htno.Substring(2,2) + lastid.ToString();//dt.Year.ToString().Substring(2, 2) + dt.Month.ToString() + dt.Day.ToString() + 1;
                db.payfees.Add(payfee);
                db.SaveChanges();
                TempData.Add("lastid", payfee.id);
                if (printReciept != null && printReciept.IndexOf("on") >= 0) 
                    TempData.Add("print","true");
                else
                    TempData.Add("print", "false");
                return RedirectToAction("Index");
            }
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", payfee.feeTypeid);
            ViewBag.paymentTypeid = new SelectList(db.paymenttypes, "id", "type", payfee.paymentTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", payfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", payfee.acaYearid);
            return View(payfee);
        }

        //
        // GET: /payfee/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            payfee payfee = db.payfees.Find(id);
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", payfee.feeTypeid);
            ViewBag.paymentTypeid = new SelectList(db.paymenttypes, "id", "type", payfee.paymentTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", payfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", payfee.acaYearid);
            return View(payfee);
        }

        //
        // POST: /payfee/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult Edit(payfee payfee)
        {
            payFeeRequiredResponse pffr = payFeeRequired(payfee);
            if (pffr.amount <= 0) ModelState.AddModelError(string.Empty, pffr.message);
            if (ModelState.IsValid)
            {
                db.Entry(payfee).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.feeTypeid = new SelectList(db.feetypes, "id", "type", payfee.feeTypeid);
            ViewBag.paymentTypeid = new SelectList(db.paymenttypes, "id", "type", payfee.paymentTypeid);
            ViewBag.studentid = new SelectList(db.students, "id", "htno", payfee.studentid);
            ViewBag.acaYearid = new SelectList(db.acayears, "id", "year", payfee.acaYearid);
            return View(payfee);
        }

        //
        // GET: /payfee/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            payfee payfee = db.payfees.Find(id);
            return View(payfee);
        }

        //
        // POST: /payfee/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            payfee payfee = db.payfees.Find(id);
            db.payfees.Remove(payfee);
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

        public short installmentsLeft(int studentid, int acaYearid, int feeTypeid)
        {
            short allowedInstallments = db.feetypes.Find(feeTypeid).allowedInstallments;
            short consumedInstallments = (short)db.payfees.Where(d => d.studentid.Equals(studentid)).Where(d => d.feeTypeid.Equals(feeTypeid)).Where(d => d.acaYearid.Equals(acaYearid)).Count();
            return (short)(allowedInstallments - consumedInstallments);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}