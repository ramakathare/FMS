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
    public class roleModulePermissionController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /roleModulePermission/

        [Secure]
        public ViewResult Index()
        {
            //var rolemodulepermissions = db.rolemodulepermissions.Include(r => r.role).Include(r => r.rolemodule);
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName");
           // ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name");
            return View();//rolemodulepermissions.ToList());
        }

        [onlyAuthorize]
        public ActionResult toGrid(string sidx, string sord, int? page, int? rows,int? roleid, int? rolemoduleid)
        {
            if (sidx == null) sidx = "role";
            if (sord == null) sord = "asc";
            if (!page.HasValue) page = 1;
            if (!rows.HasValue) rows = 10;

            var roleModulePermissions = db.rolemodulepermissions.AsQueryable();
            if (roleid.HasValue)
            {
                Int32 roleid1 = Convert.ToInt32(roleid);
                roleModulePermissions = roleModulePermissions.Where(r => r.roleid.Equals(roleid1));
            }
            if (rolemoduleid.HasValue)
            {
                Int32 rolemoduleid1 = Convert.ToInt32(rolemoduleid);
                roleModulePermissions = roleModulePermissions.Where(r => r.rolemoduleid.Equals(rolemoduleid1));
            }

            int pageIndex = Convert.ToInt32(page) - 1;
            int pageSize = Convert.ToInt32(rows);
            int totalRecords = roleModulePermissions.Count();//articleList.Count();
            int totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageSize);

            string orderBy = string.Format("{0} {1}", sidx, sord);

            var roleModulesPermissions1 = roleModulePermissions.
                                Select(s => new 
                                        {   id = s.id, 
                                            roleid=s.roleid, 
                                            rolemoduleid = s.rolemoduleid, 
                                            role = s.role.roleName, 
                                            rolemodule =s.rolemodule.name, 
                                            displayname = s.rolemodule.displayname, 
                                            permission = s.permission})
                                .OrderBy(orderBy) // Uses System.Linq.Dynamic library for sorting
                                .Skip(pageIndex * pageSize)
                                .Take(pageSize).ToList();
            var jsonData = new
            {
                total = totalPages,
                page = page,
                records = totalRecords,
                rows = roleModulesPermissions1
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [Secure]
        public ActionResult gridAddOrUpdate(rolemodulepermission rolemodulepermission)
        {
            try
            {
                if (rolemodulepermission.id.CompareTo(0) > 0) db.Entry(rolemodulepermission).State = EntityState.Modified;
                else db.rolemodulepermissions.Add(rolemodulepermission);
                db.SaveChanges();
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Record not added" }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { success = true, message = "Record Added" }, JsonRequestBehavior.AllowGet);
        }

        //
        // GET: /roleModulePermission/Details/5

        [Secure]
        public ViewResult Details(int id)
        {
            rolemodulepermission rolemodulepermission = db.rolemodulepermissions.Find(id);
            return View(rolemodulepermission);
        }


        //
        // GET: /roleModulePermission/Create

        [Secure]
        public ActionResult Create()
        {
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName");
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name");
            return View();
        } 

        //
        // POST: /roleModulePermission/Create

        [HttpPost]
        [Secure]
        public ActionResult Create(rolemodulepermission rolemodulepermission)
        {
            if (ModelState.IsValid)
            {
                db.rolemodulepermissions.Add(rolemodulepermission);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemodulepermission.roleid);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemodulepermission.rolemoduleid);
            return View(rolemodulepermission);
        }
        
        //
        // GET: /roleModulePermission/Edit/5

        [Secure]
        public ActionResult Edit(int id)
        {
            rolemodulepermission rolemodulepermission = db.rolemodulepermissions.Find(id);
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemodulepermission.roleid);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemodulepermission.rolemoduleid);
            return View(rolemodulepermission);
        }

        //
        // POST: /roleModulePermission/Edit/5

        [HttpPost]
        [Secure]
        public ActionResult Edit(rolemodulepermission rolemodulepermission)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rolemodulepermission).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", rolemodulepermission.roleid);
            ViewBag.rolemoduleid = new SelectList(db.rolemodules, "id", "name", rolemodulepermission.rolemoduleid);
            return View(rolemodulepermission);
        }


        [HttpPost]
        [Secure]
        public ActionResult DeleteFromGrid(int id)
        {
            try
            {
                rolemodulepermission rolemodulepermission = db.rolemodulepermissions.Find(id);
                db.rolemodulepermissions.Remove(rolemodulepermission);
                db.SaveChanges();
                return Json(new { success = true, message = "Deleted succesfully" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                return Json(new { success = false, message = "Not deleted" }, JsonRequestBehavior.AllowGet);
            }

        }

        //
        // GET: /roleModulePermission/Delete/5

        [Secure]
        public ActionResult Delete(int id)
        {
            rolemodulepermission rolemodulepermission = db.rolemodulepermissions.Find(id);
            return View(rolemodulepermission);
        }

        //
        // POST: /roleModulePermission/Delete/5

        [HttpPost, ActionName("Delete")]
        [Secure]
        public ActionResult DeleteConfirmed(int id)
        {            
            rolemodulepermission rolemodulepermission = db.rolemodulepermissions.Find(id);
            db.rolemodulepermissions.Remove(rolemodulepermission);
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