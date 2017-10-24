using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;

namespace FMS.Controllers
{ 
    public class roleController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /role/
        [Secure]
        public ViewResult Index()
        {
            return View(db.roles.ToList());
        }

        //
        // GET: /role/Details/5
        [Secure]
        public ViewResult Details(int id)
        {
            role role = db.roles.Find(id);
            return View(role);
        }

        //
        // GET: /role/Create
        [Secure]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /role/Create
        [Secure]
        [HttpPost]
        public ActionResult Create(role role)
        {
            if (ModelState.IsValid)
            {
                db.roles.Add(role);
                var rolemodules = db.rolemodules.ToList();
                foreach (rolemodule rm in rolemodules)
                {
                    rolemodulepermission rolemodulepermission = new rolemodulepermission();
                    rolemodulepermission.roleid = role.id;
                    rolemodulepermission.rolemoduleid = rm.id;
                    rolemodulepermission.permission = false;
                    db.rolemodulepermissions.Add(rolemodulepermission);
                }
                var roleModuleActions = db.rolemoduleactions.ToList();
                foreach (rolemoduleaction ra in roleModuleActions)
                {
                    rolemoduleactionpermission rolemoduleactionpermission = new rolemoduleactionpermission();
                    rolemoduleactionpermission.roleid = role.id;
                    rolemoduleactionpermission.rolemoduleactionid = ra.id;
                    rolemoduleactionpermission.permission = false;
                    db.rolemoduleactionpermissions.Add(rolemoduleactionpermission);
                }
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(role);
        }
        
        //
        // GET: /role/Edit/5
        [Secure]
        public ActionResult Edit(int id)
        {
            role role = db.roles.Find(id);
            return View(role);
        }

        //
        // POST: /role/Edit/5
        [Secure]
        [HttpPost]
        public ActionResult Edit(role role)
        {
            if (ModelState.IsValid)
            {
                db.Entry(role).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(role);
        }

        //
        // GET: /role/Delete/5
        [Secure]
        public ActionResult Delete(int id)
        {
            role role = db.roles.Find(id);
            return View(role);
        }

        //
        // POST: /role/Delete/5
        [Secure]
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            role role = db.roles.Find(id);
            db.roles.Remove(role);
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