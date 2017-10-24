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
    public class roleModuleActionController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /roleModuleAction/
        [Secure]
        public ViewResult Index()
        {
            //var rolemoduleactions = db.rolemoduleactions.Include(r => r.rolemodule);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name");
            return View();//rolemoduleactions.ToList());
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows, int? rolemoduleid)
        {
            if (sidx == null) sidx = "rolemodule";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var rolemoduleactions = db.rolemoduleactions.AsQueryable();
           
            if (rolemoduleid.HasValue)
            {
                Int32 rolemoduleid1 = Convert.ToInt32(rolemoduleid);
                rolemoduleactions = rolemoduleactions.Where(r => r.rolemoduleid.Equals(rolemoduleid1));
            }

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = rolemoduleactions.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var rolemoduleactions1 = rolemoduleactions.
                                Select(s => new
                                {
                                    id = s.id,
                                    rolemoduleid = s.rolemoduleid,
                                    rolemodule = s.rolemodule.name,
                                    name = s.name,
                                    displayname = s.displayname
                                })
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = rolemoduleactions1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [Secure]
        public ActionResult gridAddOrUpdate(rolemoduleaction rolemoduleaction)
        {
            try
            {
                if (rolemoduleaction.id.CompareTo(0) > 0) db.Entry(rolemoduleaction).State = EntityState.Modified;
                else db.rolemoduleactions.Add(rolemoduleaction);
                db.SaveChanges();
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Record not added" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "Record Added" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /roleModuleAction/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            rolemoduleaction rolemoduleaction = db.rolemoduleactions.Find(id);
            return View(rolemoduleaction);
        }

        //
        // GET: /roleModuleAction/Create

        [Secure]
        public ActionResult Create()
        {
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name");
            return View();
        } 

        //
        // POST: /roleModuleAction/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(rolemoduleaction rolemoduleaction)
        {
            if (ModelState.IsValid)
            {
                db.rolemoduleactions.Add(rolemoduleaction);
                var roles = db.roles.ToList();
                foreach (role r in roles)
                {
                    rolemoduleactionpermission rolemoduleactionpermission = new rolemoduleactionpermission();
                    rolemoduleactionpermission.roleid = r.id;
                    rolemoduleactionpermission.rolemoduleactionid = rolemoduleaction.id;
                    if (r.id == 1) rolemoduleactionpermission.permission = true; else rolemoduleactionpermission.permission = false;
                    db.rolemoduleactionpermissions.Add(rolemoduleactionpermission);
                }
                db.SaveChanges();
                return RedirectToAction("Create");
              //  return RedirectToAction("Index");
            }

            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemoduleaction.rolemoduleid);
            return View(rolemoduleaction);
        }
        
        //
        // GET: /roleModuleAction/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            rolemoduleaction rolemoduleaction = db.rolemoduleactions.Find(id);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemoduleaction.rolemoduleid);
            return View(rolemoduleaction);
        }

        //
        // POST: /roleModuleAction/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(rolemoduleaction rolemoduleaction)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rolemoduleaction).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemoduleaction.rolemoduleid);
            return View(rolemoduleaction);
        }

        [HttpPost]
        [Secure]
        public ActionResult DeleteFromGrid(int id)
        {
            try
            {
                rolemoduleaction rolemoduleaction = db.rolemoduleactions.Find(id);
                db.rolemoduleactions.Remove(rolemoduleaction);
                db.SaveChanges();
                return Json(new { success = true, message = "Deleted succesfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Not deleted" }, JsonRequestBehavior.AllowGet);
            }

        }

        //
        // GET: /roleModuleAction/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            rolemoduleaction rolemoduleaction = db.rolemoduleactions.Find(id);
            return View(rolemoduleaction);
        }

        //
        // POST: /roleModuleAction/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            rolemoduleaction rolemoduleaction = db.rolemoduleactions.Find(id);
            db.rolemoduleactions.Remove(rolemoduleaction);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [Authorize]
        [Secure]
        public ActionResult GetRoleModuleActions(int id)
        {
            var rma = db.rolemoduleactions.Where(u => u.rolemoduleid == id).ToList();
            var rm = rma.AsQueryable().Select(r => new { r.id, r.name }).ToList();
            return Json(rm, JsonRequestBehavior.AllowGet);
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}