using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using FMS.Models;
using System.Web.Script.Serialization;
using FMS.Helper;
using System.Configuration;
using System.Web.Configuration;
using System.Data;
using FMS.Data;


namespace FMS.Controllers
{
    public class AccountController : Controller
    {
        private feeEntities db = new feeEntities();
        //
        // GET: /Account/LogOn
        [onlyAuthorize]
        public ActionResult Index()
        {
           // ViewBag.Message = "Welcome to " + Session["userName"];
            if (!Request.IsAuthenticated)
            {
                return RedirectToAction("LogOn");
            }
            ViewBag.message = "Welcome to Fee Management System";
            return View();
            
        }

        [onlyAuthorize]
        public ActionResult generateMenu()
        {
            var serializer = new JavaScriptSerializer();
            FormsIdentity id = (FormsIdentity)User.Identity;
            FormsAuthenticationTicket ticket = id.Ticket;
            int s = Convert.ToInt32(ticket.UserData);
            var rolemodulepermissions = db.rolemodulepermissions.Where(r => r.roleid.Equals(s)).Where(r=>r.permission.Equals(1)).Select(r => new {r.rolemoduleid,name=r.rolemodule.name,r.rolemodule.displayname, r.permission}).ToList();
            string htmlList = "";
            foreach ( var rm in rolemodulepermissions)
            {
                if (db.rolemoduleactionpermissions.Where(r=>r.roleid.Equals(s) && r.rolemoduleaction.rolemoduleid.Equals(rm.rolemoduleid) && r.rolemoduleaction.name.Equals("Index")).Select(r => r.permission).FirstOrDefault().Equals(1))
                {
                    htmlList += "<div class='rootMenu' onClick=\"ajaxLoad('mainContentPlaceHolder','/" + rm.name + "/Index')\">" + rm.displayname + "</div>";
                }
                //htmlList += "<li><div class='rootMenu'>" + rm.displayname+"-"+rm.permission +"</div><ul class='hideDiv'>";
               //var rolemoduleactionpermissions = db.rolemoduleactionpermissions.Where(r => r.roleid.Equals(s) && r.rolemoduleaction.rolemoduleid.Equals(rm.rolemoduleid)).Where(r=>r.permission.Equals(1)).Select(r => new {r.rolemoduleaction.displayname, r.permission}).ToList();
               //foreach (var rma in rolemoduleactionpermissions)
               //{
               //    htmlList += "<li>" + rma.displayname+"-"+rma.permission + "</li>";
               //}
               //htmlList += "</ul></li>";
            }

            return Content(htmlList);
        }

        public ActionResult LogOn()
        {
            return View();
        }

        //
        // POST: /Account/LogOn

        [HttpPost]
        public ActionResult LogOn(LogOnModel model, string returnUrl)
        {

            if (ModelState.IsValid)
            {
                string encryptedUsername = model.UserName; //base64Encryption.Encrypt(model.UserName);
                string encryptedPassword = model.Password; //base64Encryption.Encrypt(model.Password);
                var result = db.users.Where(u => u.username.Equals(encryptedUsername) && u.password.Equals(encryptedPassword));

                //ModelState.AddModelError("",model.UserName+":"+base64Encryption.Encrypt(model.UserName));
                //ModelState.AddModelError("", model.Password + ":" + base64Encryption.Encrypt(model.Password));

                //return View();

                if (result.Count()!=0)
                {
                    var dbuser = result.FirstOrDefault();

                    AuthenticationSection authSection = (AuthenticationSection)ConfigurationManager.GetSection("system.web/authentication");
                    int timeOut = authSection.Forms.Timeout.Minutes;

                    Session["userName"] = dbuser.name;

                    var serializer = new JavaScriptSerializer();
                    
                    var serializedUser = serializer.Serialize(dbuser.id);
                    var ticket = new FormsAuthenticationTicket(1,dbuser.name, DateTime.Now, DateTime.Now.AddMinutes(timeOut), false, serializedUser);
                    var hash = FormsAuthentication.Encrypt(ticket);
                    var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash) { Expires = ticket.Expiration};

                    Response.Cookies.Add(authCookie);


                    if (Url.IsLocalUrl(returnUrl) && returnUrl.Length > 1 && returnUrl.StartsWith("/")
                        && !returnUrl.StartsWith("//") && !returnUrl.StartsWith("/\\"))
                    {
                        // return Redirect(returnUrl);
                        this.TempData["returnUrl"] = returnUrl;
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        return RedirectToAction("Index");
                    }
                    
                }
                else
                {
                    ModelState.AddModelError("", "The user name or password provided is incorrect.");
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/LogOff
        public ActionResult LogOff()
        {
            System.Web.HttpContext.Current.Cache.Remove(User.Identity.Name);
            FormsAuthentication.SignOut();
            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();
            return RedirectToAction("LogOn");
        }

        //
        // GET: /Account/Register

        //public ActionResult Register()
        //{
        //    return View();
        //}

        //
        // POST: /Account/Register

        //[HttpPost]
        //public ActionResult Register(RegisterModel model)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        // Attempt to register the user
        //        MembershipCreateStatus createStatus;
        //        Membership.CreateUser(model.UserName, model.Password, model.Email, null, null, true, null, out createStatus);

        //        if (createStatus == MembershipCreateStatus.Success)
        //        {
        //            FormsAuthentication.SetAuthCookie(model.UserName, false /* createPersistentCookie */);
        //            return RedirectToAction("Index", "Home");
        //        }
        //        else
        //        {
        //            ModelState.AddModelError("", ErrorCodeToString(createStatus));
        //        }
        //    }

        //    // If we got this far, something failed, redisplay form
        //    return View(model);
        //}

        //
        // GET: /Account/ChangePassword

         [Secure]
         public ActionResult ChangePassword()
         {
             return View();
         }

        
       //  POST: /Account/ChangePassword

        [Secure]
        [HttpPost]
        public ActionResult ChangePassword(ChangePasswordModel model)
        {
            if (model.ConfirmPassword != null && model.ConfirmPassword.Length > 10) ModelState.AddModelError("", "ConfirmPassword Password should be between 5 to 10 characters");
            if (model.NewPassword != null && model.NewPassword.Length > 10) ModelState.AddModelError("", "NewPassword Password should be between 5 to 10 characters");
            if (model.OldPassword != null && model.OldPassword.Length > 10) ModelState.AddModelError("", "OldPassword Password should be between 5 to 10 characters");
            if (model.ConfirmPassword != null && model.ConfirmPassword != null)
            {
                if (!model.NewPassword.Equals(model.ConfirmPassword)) ModelState.AddModelError("", "Confirmation of New Password failed");
            }
            if (ModelState.IsValid)
            {

                try
                {
                    int userid = Permissions.getuserid();
                    user user = db.users.Find(userid);
                    string originalEncryptedOldPassword = user.password;
                    string providedEncryptedOldPassword = base64Encryption.Encrypt(model.OldPassword);
                    if(originalEncryptedOldPassword.Equals(providedEncryptedOldPassword))
                    {
                            user.password = base64Encryption.Encrypt(model.NewPassword);
                            db.Entry(user).State = EntityState.Modified;
                            db.SaveChanges();
                            return View("ChangePasswordSuccess");
                    }
                    ModelState.AddModelError("OldPassword", "Password provided is wrong");
                    return View(model);
                }
                catch (Exception)
                {
                    ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
                    return View(model);
                }
            }
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ChangePasswordSuccess

        //public ActionResult ChangePasswordSuccess()
        //{
        //    return View();
        //}

        //#region Status Codes
        //private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        //{
        //    // See http://go.microsoft.com/fwlink/?LinkID=177550 for
        //    // a full list of status codes.
        //    switch (createStatus)
        //    {
        //        case MembershipCreateStatus.DuplicateUserName:
        //            return "User name already exists. Please enter a different user name.";

        //        case MembershipCreateStatus.DuplicateEmail:
        //            return "A user name for that e-mail address already exists. Please enter a different e-mail address.";

        //        case MembershipCreateStatus.InvalidPassword:
        //            return "The password provided is invalid. Please enter a valid password value.";

        //        case MembershipCreateStatus.InvalidEmail:
        //            return "The e-mail address provided is invalid. Please check the value and try again.";

        //        case MembershipCreateStatus.InvalidAnswer:
        //            return "The password retrieval answer provided is invalid. Please check the value and try again.";

        //        case MembershipCreateStatus.InvalidQuestion:
        //            return "The password retrieval question provided is invalid. Please check the value and try again.";

        //        case MembershipCreateStatus.InvalidUserName:
        //            return "The user name provided is invalid. Please check the value and try again.";

        //        case MembershipCreateStatus.ProviderError:
        //            return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

        //        case MembershipCreateStatus.UserRejected:
        //            return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

        //        default:
        //            return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
        //    }
        //}
        //#endregion
    }
}
