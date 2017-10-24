using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using FMS.Helper;
using FMS.Models;
using System.Data.Entity.Validation;
using System.Diagnostics;

namespace FMS.Controllers
{ 
    public class userController : Controller
    {
        private feeEntities db = new feeEntities();

        //
        // GET: /user/

        public ViewResult Index()
        {
            var users = db.users.Include(u => u.role);
            return View(users.ToList());
        }

        //
        // GET: /user/Details/5

        public ViewResult Details(int id)
        {
            user user = db.users.Find(id);
            return View(user);
        }

        //
        // GET: /user/Create

        public ActionResult Create()
        {
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName");
            return View();
        } 

        //
        // POST: /user/Create

        [HttpPost]
        public ActionResult Create(user user)
        {
            if (user.username != null && user.username.Length > 10) ModelState.AddModelError("username", "Username should be between 4 to 10 characters");
            if (user.password != null && user.password.Length > 10) ModelState.AddModelError("password", "Password should be between 5 to 10 characters"); 

            if (ModelState.IsValid)
            {
                
                user.username = base64Encryption.Encrypt(user.username);
                user.password = base64Encryption.Encrypt(user.password);
                db.users.Add(user);
                db.SaveChanges();
                return RedirectToAction("Index");
                //catch (DbEntityValidationException dbEx)
                //{
                //    foreach (var validationErrors in dbEx.EntityValidationErrors)
                //    {
                //        foreach (var validationError in validationErrors.ValidationErrors)
                //        {
                //            ModelState.AddModelError("",string.Format("Property: {0} Error: {1}", validationError.PropertyName, validationError.ErrorMessage));
                //        }
                //    }
                //}
            }

            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", user.roleid);
            return View(user);
        }
        
        //
        // GET: /user/Edit/5
 
        public ActionResult Edit(int id)
        {
            user user = db.users.Find(id);
            user.username = base64Encryption.Decrypt(user.username);
            user.password = base64Encryption.Decrypt(user.password);
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", user.roleid);
            return View(user);
        }

        //
        // POST: /user/Edit/5

        [HttpPost]
        public ActionResult Edit(user user)
        {
            if (user.username.Length < 4) ModelState.AddModelError("username", "Username should be between 4 to 10 characters");
            if (user.username.Length > 10) ModelState.AddModelError("username", "Username should be between 4 to 10 characters");
            if (user.password.Length < 5) ModelState.AddModelError("password", "Password should be between 5 to 10 characters");
            if (user.password.Length > 10) ModelState.AddModelError("password", "Password should be between 5 to 10 characters");
            if (ModelState.IsValid)
            {
                user.username = base64Encryption.Encrypt(user.username);
                user.password = base64Encryption.Encrypt(user.password);
                db.Entry(user).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.roleid = new SelectList(db.roles, "id", "roleName", user.roleid);
            return View(user);
        }

        //
        // GET: /user/Delete/5
 
        public ActionResult Delete(int id)
        {
            user user = db.users.Find(id);
            user.username = base64Encryption.Decrypt(user.username);
            user.password = base64Encryption.Decrypt(user.password);
            return View(user);
        }

        //
        // POST: /user/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            user user = db.users.Find(id);
            db.users.Remove(user);
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