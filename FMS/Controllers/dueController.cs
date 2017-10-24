using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using FMS.Helper;
using FMS.Data;

namespace FMS.Controllers
{
    public class dueController : Controller
    {

        private feeEntities db = new feeEntities();

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
        //
        // GET: /Dues/

        [Secure]
        public ActionResult Index()
        {
            ViewBag.batchid = new SelectList(db.batches, "id", "name");
            ViewBag.feetypeid = new SelectList(db.feetypes, "id", "type");
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.OrderByDescending(s => s.year).FirstOrDefault().id);
            return View();
        }

        [Secure]
        public ViewResult DuesToExcel()
        {
            ViewBag.acayearid = new SelectList(db.acayears, "id", "year", db.acayears.OrderByDescending(s => s.year).FirstOrDefault().id);
            return View();
        }

        [onlyAuthorize]
        public ActionResult exportToExcelSemWise(
                                        string Quota,
                                        string Caste,
                                        int semid,
                                        int acayearid,
                                        bool? feeExemption)
        {
           
            var setfees = db.setfees.Where(s => s.acaYearid.Equals(acayearid) && s.student.semid.Equals(semid));

            if (feeExemption.HasValue) setfees = setfees.Where(s => s.student.feeExemption.Equals((bool)feeExemption));

            setfees = setfees.Where(s =>
                    s.student.quota.name.Contains(Quota) &&
                    s.student.caste.name.Contains(Caste));

            var setfees1 = setfees.Select(s => new
                                    {
                                        studentid = s.student.id,
                                        acayearid = s.acaYearid,
                                        HTNo = s.student.htno,
                                        Name = s.student.name,
                                        Semester = s.student.sem.name,
                                        Batch = s.student.batch.name,
                                        Quota = s.student.quota.name,
                                        Caste = s.student.caste.name,
                                    }).Distinct().OrderBy(s=>s.HTNo);

            List<feetype> feeTypesList = db.feetypes.ToList();

            List<long> totals = new List<long>();
            foreach (feetype ft in feeTypesList)
            {
                totals.Add((long)0);
                totals.Add((long)0);
            }

            List<Dictionary<string, object>> dues1 = new List<Dictionary<string, object>>();

            feeEntities db1 = new feeEntities();
            long GrandTotalAmount = 0;
            long GrandTotalDue = 0;
            foreach (var item in setfees1)
            {
                Dictionary<string, object> dues = new Dictionary<string, object>();
                dues.Add("HTNo", item.HTNo);
                dues.Add("Name", item.Name);
                dues.Add("Batch", item.Batch);
                dues.Add("Quota", item.Quota);
                dues.Add("Caste", item.Caste);
                long totalAmount = 0;
                long totalDue = 0;
                int i = 0;
                foreach (feetype ft in feeTypesList)
                {
                    long Amount = 0;
                    long concession = 0;
                    long payments = 0;
                    try
                    {
                        Amount = db1.setfees.Where(s => s.studentid.Equals(item.studentid) && s.acaYearid.Equals(item.acayearid) && s.feeTypeid.Equals(ft.id)).FirstOrDefault().amount;
                        concession = (from p in db1.concessions
                                      where p.studentid == item.studentid
                                      where p.acaYearid == item.acayearid
                                      where p.feeTypeid == ft.id
                                      select (long?)p.amount).Sum() ?? 0;
                        Amount = Amount - concession;
                    }
                    catch (Exception e)
                    {
                    }
                    try
                    {
                        payments = (from p in db1.payfees
                                    where p.studentid == item.studentid
                                    where p.acaYearid == item.acayearid
                                    where p.feeTypeid == ft.id
                                    select (long?)p.amount).Sum() ?? 0;
                    }
                    catch (Exception e)
                    {
                    }
                    long thisDue = Amount - payments;
                    Amount = Amount >= 0 ? Amount : 0;
                    thisDue = thisDue >= 0 ? thisDue : 0;
                    totals[i++]+=Amount;
                    totals[i++] += thisDue;
                    dues.Add(ft.type, Amount);
                    dues.Add(ft.type + " Due", thisDue);

                    totalAmount += Amount;
                    totalDue += thisDue;
                }
                dues.Add("Total", totalAmount);
                dues.Add("Total Due", totalDue);
                if (totalDue > 0)
                {
                    GrandTotalAmount += totalAmount;
                    GrandTotalDue += totalDue;
                    dues1.Add(dues);
                }
            
            }

            totals.Add(GrandTotalAmount);
            totals.Add(GrandTotalDue);

            MemoryStream memStream = new MemoryStream();
            TextWriter writer = new StreamWriter(memStream);
            var semester = db.sems.Find(semid).name;
            var acayear = db.acayears.Find(acayearid).year;

            if (dues1.Count() <= 0)
            {
                try
                {

                    writer.Write("No dues exist with the provided parameters");
                }
                catch (Exception e)
                {
                }
                finally
                {
                    writer.Close();
                }
                return File(memStream.ToArray(), "application/ms-excel", "DuesList_" + semester + "_" + acayear + ".xls");
            }

            
            
            int numberOfFields = dues1[0].Count();

            db1.Dispose();

         
            StringBuilder html = new StringBuilder();

            html.Append("<table border=\"1\"><tr><td colspan="+numberOfFields+">");
            html.Append("Dues list of ");
            html.Append("<b>-"+semester+"-</b>");
            html.Append(" for the Academic Year ");
            html.Append("<b>-" + acayear + "-</b>");
            html.Append("</td></tr></table>");
            html.Append("<table border=\"1\"><tr>");

            foreach (KeyValuePair<string, object> kv in dues1.First())
            {
                html.Append("<th>");
                html.Append(kv.Key);
                html.Append("</th>");
            }
            html.Append("</tr>");

            foreach (Dictionary<string, object> dic in dues1)
            {
                html.Append("<tr>");
                foreach (KeyValuePair<string, object> kv in dic)
                {
                    html.Append("<td>").Append(kv.Value).Append("</td>");
                }
                html.Append("</tr>");
            }
            html.Append("<tr>");
            html.Append("<td colspan=\"5\" >Total</td>");
            foreach (long total in totals)
            {
                html.Append("<td>" + total + "</td>");
            }
            html.Append("</tr>");
            html.Append("</table>");
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
            return File(memStream.ToArray(), "application/ms-excel", "DuesList_"+semester+"_"+acayear+".xls");
        }



        [onlyAuthorize]
        public ActionResult exportGridToExcel(string sidx, string sord, int? page, int? rows,
                                       string HTNo,
                                       string Name,
                                       int? Batchid,
                                       string Quota,
                                       string Caste,
                                       string Dept,
                                       string Sem,
                                       int acayearid,
                                       int? feetypeid,
                                       bool? feeExemption)
        {
            if (sidx == null) sidx = "Due";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;


            var setfees = db.setfees.Where(s => s.acaYearid.Equals(acayearid));

            if (feeExemption.HasValue) setfees = setfees.Where(s => s.student.feeExemption.Equals((bool)feeExemption));

            if (Batchid.HasValue)
            {
                Int32 Batchid1 = Convert.ToInt32(Batchid);
                setfees = setfees.Where(s => s.student.batchid.Equals(Batchid1));
            }
            if (feetypeid.HasValue)
            {
                Int32 feetypeid1 = Convert.ToInt32(feetypeid);
                setfees = setfees.Where(s => s.feeTypeid.Equals(feetypeid1));
            }
            setfees = setfees.Where(s =>
                    s.student.htno.Contains(HTNo) &&
                    s.student.name.Contains(Name) &&
                    s.student.quota.name.Contains(Quota) &&
                    s.student.caste.name.Contains(Caste) &&
                    s.student.dept.name.Contains(Dept) &&
                    s.student.sem.name.Contains(Sem));

            var setfees1 = setfees.Select(s => new
            {
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
                Concessions = (from p in db.concessions
                               where p.studentid == s.studentid
                               where p.acaYearid == s.acaYearid
                               where p.feeTypeid == s.feeTypeid
                               select (long?)p.amount).Sum() ?? 0,
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
                                  select (long?)p.amount).Sum() ?? 0)
            });

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            int totalRecords = setfees1.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            var setfees2 = setfees1.OrderBy(orderBy).Skip(pageIndex * pageSize).Take(pageSize);

            List<feetype> feeTypesList = db.feetypes.ToList();

            List<Dictionary<string, object>> dues1 = new List<Dictionary<string, object>>();
            long totalAmount = 0;
            long totalConcession = 0;
            long totalPayments = 0;
            long totalDues = 0;
            foreach (var item in setfees2)
            {
                if (item.Due <= 0) continue;

                Dictionary<string, object> dues = new Dictionary<string, object>();
                dues.Add("HTNo", item.HTNo);
                dues.Add("Name", item.Name);
                dues.Add("Semester", item.Semester);
                dues.Add("Batch", item.Batch);
                dues.Add("Quota", item.Quota);
                dues.Add("Caste", item.Caste);
                dues.Add("FeeType", item.FeeType);
                dues.Add("Amount", item.Amount);
                dues.Add("Concession", item.Concessions);
                dues.Add("Payments", item.Payments);
                dues.Add("Due", item.Due);


                totalAmount += item.Amount;
                totalConcession += item.Concessions;
                totalPayments += item.Payments;
                totalDues += item.Due;
                dues1.Add(dues);
            }

            MemoryStream memStream = new MemoryStream();
            TextWriter writer = new StreamWriter(memStream);
            if (dues1.Count() <= 0)
            {
                try
                {

                    writer.Write("No records to export");
                }
                catch (Exception e)
                {
                }
                finally
                {
                    writer.Close();
                }
                return File(memStream.ToArray(), "application/ms-excel", "DuesListFromGrid.xls");
            }

            StringBuilder html = new StringBuilder();

            html.Append("<table border=\"1\"><tr>");

            foreach (KeyValuePair<string, object> kv in dues1.First())
            {
                html.Append("<th>");
                html.Append(kv.Key);
                html.Append("</th>");
            }
            html.Append("</tr>");

            foreach (Dictionary<string, object> dic in dues1)
            {
                html.Append("<tr>");
                foreach (KeyValuePair<string, object> kv in dic)
                {
                    html.Append("<td>").Append(kv.Value).Append("</td>");
                }
                html.Append("</tr>");
            }
            html.Append("<tr>");
            html.Append("<td colspan=\"7\" >Total</td>");
            html.Append("<td>" + totalAmount + "</td>");
            html.Append("<td>" + totalConcession + "</td>");
            html.Append("<td>" + totalPayments + "</td>");
            html.Append("<td>" + totalDues + "</td>");
            html.Append("</tr>");
            html.Append("</table>");
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
            return File(memStream.ToArray(), "application/ms-excel", "DuesListFromGrid.xls");
        }

        [onlyAuthorize]
        [HttpPost]
        public ActionResult ValidateDuesToExcel(string Quota, string Caste, int? semid, int? acayearid)
        {
            if (!acayearid.HasValue || !semid.HasValue)
            {
                return Json(new { success = false, message = "Either 'Academic Year' or 'Semester' is not selected" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "valid" }, JsonRequestBehavior.AllowGet);
        }


        /// <summary>
        /// toGrid
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
        /// <param name="acayearid"></param>
        /// <returns></returns>


        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows,
                                        string HTNo,
                                        string Name,
                                        int? Batchid,
                                        string Quota,
                                        string Caste,
                                        string Dept,
                                        string Sem,
                                        int acayearid,
                                        int? feetypeid,
                                        bool? feeExemption)
        {
            if (sidx == null) sidx = "HTNo";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;


            var setfees = db.setfees.Where(s => s.acaYearid.Equals(acayearid));

            if (feeExemption.HasValue) setfees = setfees.Where(s => s.student.feeExemption.Equals((bool)feeExemption));

            if (Batchid.HasValue)
            {
                Int32 Batchid1 = Convert.ToInt32(Batchid);
                setfees = setfees.Where(s => s.student.batchid.Equals(Batchid1));
            }
            if (feetypeid.HasValue)
            {
                Int32 feetypeid1 = Convert.ToInt32(feetypeid);
                setfees = setfees.Where(s => s.feeTypeid.Equals(feetypeid1));
            }

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
                AcaYear = s.acayear.year,
                FeeType = s.feetype.type,
                Amount = s.amount,
                FeeExemption = s.student.feeExemption,
                Concessions = (from p in db.concessions
                               where p.studentid == s.studentid
                               where p.acaYearid == s.acaYearid
                               where p.feeTypeid == s.feeTypeid
                               select (long?)p.amount).Sum() ?? 0,
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
                                  select (long?)p.amount).Sum() ?? 0)
            });

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

        //
        // GET: /Dues/Details/5

        [Secure]
        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Dues/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /Dues/Create

        [Secure]
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Dues/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Dues/Edit/5

        [Secure]
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Dues/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Dues/Delete/5

        [Secure]
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
