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
    public class roleModuleController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /roleModule/

        [Secure]
        public ViewResult Index()
        {
            return View();
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows)
        {
            if (sidx == null) sidx = "name";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var roleModules = db.rolemodules;

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = roleModules.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var roleModules1 = roleModules.Select(s=>new {s.id,s.name,s.displayname})
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
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

        //
        // GET: /roleModule/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            rolemodule rolemodule = db.rolemodules.Find(id);
            return View(rolemodule);
        }

        //
        // GET: /roleModule/Create

        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /roleModule/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(rolemodule rolemodule)
        {
            if (ModelState.IsValid)
            {
                db.rolemodules.Add(rolemodule);
                var roles = db.roles.ToList();
                foreach (role r in roles)
                {
                    rolemodulepermission rolemodulepermission = new rolemodulepermission();
                    rolemodulepermission.roleid = r.id;
                    rolemodulepermission.rolemoduleid = rolemodule.id;
                    if (r.id == 1)  
                        rolemodulepermission.permission = true;
                    else rolemodulepermission.permission = false;
                    db.rolemodulepermissions.Add(rolemodulepermission);
                }
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(rolemodule);
        }

        [Secure]
        public ActionResult gridAddOrUpdate(rolemodule rolemodule)
        {
            try
            {
                db.Entry(rolemodule).State = EntityState.Modified;
                db.SaveChanges();
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Record not updated" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "Record updated" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /roleModule/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            rolemodule rolemodule = db.rolemodules.Find(id);
            return View(rolemodule);
        }

        //
        // POST: /roleModule/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(rolemodule rolemodule)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rolemodule).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rolemodule);
        }

        [HttpPost]
        [Secure]
        public ActionResult DeleteFromGrid(int id)
        {
            try
            {
                rolemodule rolemodule = db.rolemodules.Find(id);
                db.rolemodules.Remove(rolemodule);
                db.SaveChanges();
                return Json(new { success = true, message = "Deleted succesfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Not deleted" }, JsonRequestBehavior.AllowGet);
            }

        }

        //
        // GET: /roleModule/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            rolemodule rolemodule = db.rolemodules.Find(id);
            return View(rolemodule);
        }

        //
        // POST: /roleModule/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            rolemodule rolemodule = db.rolemodules.Find(id);
            db.rolemodules.Remove(rolemodule);
            db.SaveChanges();
            return RedirectToAction("Index");
        }


        [onlyAuthorize]
        public ActionResult GetRoleModules(int? id)
        {
            var rma1 = db.rolemodulepermissions.Where(r => r.roleid == id).Where(r => r.permission).ToList();
            //var rma = from u in db.rolemoduleactions where (u.rolemoduleid == id) select u;
            //String ss = "<option value=\"\"></option>";;
            //foreach (rolemodulepermission item1 in rma1)
            //{
            //    ss += "<option value=\"" + item1.rolemoduleid + "\">" + item1.rolemodule.name + "</option>";
            //}
            //return ss;
            var rm = rma1.AsQueryable().Select(r=>new {r.rolemodule.id, r.rolemodule.name}).ToList();
           
            return Json(rm, JsonRequestBehavior.AllowGet);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}