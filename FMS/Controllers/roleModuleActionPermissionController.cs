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
    public class roleModuleActionPermissionController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /roleModuleActionPermission/
        [Secure]
        public ViewResult Index()
        {
           // var rolemoduleactionpermissions = db.rolemoduleactionpermissions.Include(r => r.role).Include(r => r.rolemoduleaction);
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName");
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name");
            return View();//rolemoduleactionpermissions.ToList());
        }

        //
        // GET: /roleModuleActionPermission/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            rolemoduleactionpermission rolemoduleactionpermission = db.rolemoduleactionpermissions.Find(id);
            return View(rolemoduleactionpermission);
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows, int? roleid, int? rolemoduleid)
        {
            if (sidx == null) sidx = "role";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var rolemoduleactionpermissions = db.rolemoduleactionpermissions.AsQueryable();
            if (roleid.HasValue)
            {
                Int32 roleid1 = Convert.ToInt32(roleid);
                rolemoduleactionpermissions = rolemoduleactionpermissions.Where(r => r.roleid.Equals(roleid1));
            }
            if (rolemoduleid.HasValue)
            {
                Int32 rolemoduleid1 = Convert.ToInt32(rolemoduleid);
                rolemoduleactionpermissions = rolemoduleactionpermissions.Where(r => r.rolemoduleaction.rolemoduleid.Equals(rolemoduleid1));
            }

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = rolemoduleactionpermissions.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var rolemoduleactionpermissions1 = rolemoduleactionpermissions.
                                Select(s => new
                                {
                                    id = s.id,
                                    roleid = s.roleid,
                                    rolemoduleactionid = s.rolemoduleactionid,
                                    role = s.role.roleName,
                                    rolemodule = s.rolemoduleaction.rolemodule.name,
                                    name = s.rolemoduleaction.name,
                                    displayname = s.rolemoduleaction.displayname,
                                    permission = s.permission
                                })
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = rolemoduleactionpermissions1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }


        [Secure]
        public ActionResult gridAddOrUpdate(rolemoduleactionpermission rolemoduleactionpermission)
        {
            try
            {
                if (rolemoduleactionpermission.id.CompareTo(0) > 0) db.Entry(rolemoduleactionpermission).State = EntityState.Modified;
                else db.rolemoduleactionpermissions.Add(rolemoduleactionpermission);
                db.SaveChanges();
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Record not added" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "Record Added" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /roleModuleActionPermission/Create

        [Secure]
        public ActionResult Create()
        {
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName");
            ViewBag.rolemoduleactionid = new SelectList(db.rolemoduleactions, "id", "name");
            return View();
        } 

        //
        // POST: /roleModuleActionPermission/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(rolemoduleactionpermission rolemoduleactionpermission)
        {
            if (ModelState.IsValid)
            {
                db.rolemoduleactionpermissions.Add(rolemoduleactionpermission);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemoduleactionpermission.roleid);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemoduleactionpermission.rolemoduleaction.rolemoduleid);
            ViewBag.rolemoduleactionid = new SelectList(db.rolemoduleactions, "id", "name", rolemoduleactionpermission.rolemoduleactionid);
            return View(rolemoduleactionpermission);
        }
        
        //
        // GET: /roleModuleActionPermission/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            rolemoduleactionpermission rolemoduleactionpermission = db.rolemoduleactionpermissions.Find(id);
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemoduleactionpermission.roleid);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemoduleactionpermission.rolemoduleaction.rolemoduleid);
            ViewBag.rolemoduleactionid = new SelectList(db.rolemoduleactions, "id", "name", rolemoduleactionpermission.rolemoduleactionid);
            return View(rolemoduleactionpermission);
        }

        //
        // POST: /roleModuleActionPermission/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(rolemoduleactionpermission rolemoduleactionpermission)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rolemoduleactionpermission).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemoduleactionpermission.roleid);
            ViewBag.rolemoduleactionid = new SelectList(db.rolemoduleactions, "id", "name", rolemoduleactionpermission.rolemoduleactionid);
            return View(rolemoduleactionpermission);
        }

        [HttpPost]
        [Secure]
        public ActionResult DeleteFromGrid(int id)
        {
            try
            {
                rolemoduleactionpermission rolemoduleactionpermission = db.rolemoduleactionpermissions.Find(id);
                db.rolemoduleactionpermissions.Remove(rolemoduleactionpermission);
                db.SaveChanges();
                return Json(new { success = true, message = "Deleted succesfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Not deleted" }, JsonRequestBehavior.AllowGet);
            }
            
        }

        //
        // GET: /roleModuleActionPermission/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            rolemoduleactionpermission rolemoduleactionpermission = db.rolemoduleactionpermissions.Find(id);
            return View(rolemoduleactionpermission);
        }

        //
        // POST: /roleModuleActionPermission/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            rolemoduleactionpermission rolemoduleactionpermission = db.rolemoduleactionpermissions.Find(id);
            db.rolemoduleactionpermissions.Remove(rolemoduleactionpermission);
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