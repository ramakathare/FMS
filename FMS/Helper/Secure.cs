using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FMS;using FMS.Data;
using System.Web.Security;
using System.Web.Routing;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace FMS.Helper
{
    public class Secure : AuthorizeAttribute
    {
        /// <summary>
        /// Checks to see if the user is authenticated and has a valid session object
        /// </summary>        
        /// <param name="httpContext"></param>
        /// <returns></returns>
        /// 
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (httpContext == null) throw new ArgumentNullException("httpContext");

            // Make sure the user is authenticated.
            if (httpContext.User.Identity.IsAuthenticated == false) return false;
            if (httpContext.Session == null) return false;
            if (httpContext.Session["userName"] == null) return false;
            
            return true;
        }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext == null)
            {
                throw new ArgumentNullException("filterContext");
            }

            if (!AuthorizeCore(filterContext.HttpContext)){
                filterContext.Result = new ViewResult { ViewName = "notLoggedin" };
            }else
            {
                //FormsIdentity id = (FormsIdentity)HttpContext.Current.User.Identity;
                //FormsAuthenticationTicket ticket = id.Ticket;
                //System.Diagnostics.Debug.WriteLine("ExpirationDate -" + ticket.Expiration + "-" + ticket.Expiration.Second);
                //System.Diagnostics.Debug.WriteLine("Now -" + DateTime.Now + "-" + DateTime.Now.Second);
                //System.Diagnostics.Debug.WriteLine("SessionExpiration -" + HttpContext.Current.Session.Timeout);

                //HttpCachePolicyBase cachePolicy = filterContext.HttpContext.Response.Cache;
                //cachePolicy.SetProxyMaxAge(new TimeSpan(0));
                //cachePolicy.AddValidationCallback(CacheValidateHandler, null /* data */);
                
                var rd = filterContext.HttpContext.Request.RequestContext.RouteData;
                string currentAction = rd.GetRequiredString("action");
                string currentController = rd.GetRequiredString("controller");

                ///////////Commented in Oct 2015
                //if (!Permissions.checkActionPermission1(currentController, currentAction))
                //{
                //    filterContext.Result =  new ViewResult { ViewName = "Error" };
                //}
            }
        }

        
    }

    public class onlyAuthorize : AuthorizeAttribute
    {
        /// <summary>
        /// Checks to see if the user is authenticated and has a valid session object
        /// </summary>        
        /// <param name="httpContext"></param>
        /// <returns></returns>
        /// 
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (httpContext == null) throw new ArgumentNullException("httpContext");

            // Make sure the user is authenticated.
            if (httpContext.User.Identity.IsAuthenticated == false) return false;
            if (httpContext.Session == null) return false;
            if (httpContext.Session["userName"] == null) return false;
            return true;
        }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext == null)
            {
                throw new ArgumentNullException("filterContext");
            }

            if (!AuthorizeCore(filterContext.HttpContext))
            {
                filterContext.Result = new ViewResult { ViewName = "notLoggedin" };
            }
            //else
            //{

            //}
            //else
            //{
            //    //FormsIdentity id = (FormsIdentity)HttpContext.Current.User.Identity;
            //    //FormsAuthenticationTicket ticket = id.Ticket;
            //    //System.Diagnostics.Debug.WriteLine("ExpirationDate -" + ticket.Expiration + "-" + ticket.Expiration.Second);
            //    //System.Diagnostics.Debug.WriteLine("Now -" + DateTime.Now + "-" + DateTime.Now.Second);
            //    //System.Diagnostics.Debug.WriteLine("SessionExpiration -" + HttpContext.Current.Session.Timeout);

            //    //HttpCachePolicyBase cachePolicy = filterContext.HttpContext.Response.Cache;
            //    //cachePolicy.SetProxyMaxAge(new TimeSpan(0));
            //    //cachePolicy.AddValidationCallback(CacheValidateHandler, null /* data */);

            //    var rd = filterContext.HttpContext.Request.RequestContext.RouteData;
            //    string currentAction = rd.GetRequiredString("action");
            //    string currentController = rd.GetRequiredString("controller");
            //    if (!Permissions.checkActionPermission1(currentController, currentAction))
            //    {
            //        filterContext.Result = new ViewResult { ViewName = "Error" };
            //    }
            //}
        }


    }

       
    public static class Permissions{
        public static int getuserid()
        {
            if (!HttpContext.Current.Request.IsAuthenticated) return 0;
            FormsIdentity id = (FormsIdentity)HttpContext.Current.User.Identity;
            FormsAuthenticationTicket ticket = id.Ticket;
            int userid = Convert.ToInt32(ticket.UserData);
            return userid;
        }

        public static MvcHtmlString MyActionLink(this HtmlHelper helper,
                                                    String linkText,
                                                    String moduleName,
                                                    String actionName,
                                                    Object routeValues,
                                                    String functionName,
                                                    String functionParams,
                                                    String htmlAttributes)
        {
            if (checkActionPermission(helper,moduleName, actionName))
            {
                RouteValueDictionary parameters = new RouteValueDictionary(routeValues);
                parameters.Add("controller", moduleName);
                parameters.Add("action", actionName);
                VirtualPathData vpd = RouteTable.Routes.GetVirtualPath(null, parameters);
                string result = "<a href=\"javascript:" + functionName + "('" + functionParams + "','" + vpd.VirtualPath + "')\" " + htmlAttributes + ">" + linkText + "</a>";
                return MvcHtmlString.Create(result);
            }
            return MvcHtmlString.Create("");
        }


        public static Boolean checkActionPermission1(String moduleName, String actionName)
        {
            ///////////Commented in Oct 2015
            //int userid = getuserid();
            //feeEntities db = new feeEntities();
            //int roleid1 = db.users.Find(userid).roleid;
            //int roleid = Convert.ToInt32(roleid1);
            //var rmps = db.rolemodulepermissions.Where(r => r.roleid.Equals(roleid) && r.rolemodule.name.Equals(moduleName)).Select(r => new { r.permission, r.rolemoduleid }).FirstOrDefault();

            //if (rmps != null && rmps.permission)
            //{
            //    return (db.rolemoduleactionpermissions.Where(r => r.roleid.Equals(roleid) && r.rolemoduleaction.rolemoduleid.Equals(rmps.rolemoduleid) && r.rolemoduleaction.name.Equals(actionName)).Select(r => r.permission).FirstOrDefault());
            //}

            //return false;

            return true;
        }



        public static Boolean checkActionPermission(this HtmlHelper helper, String moduleName, String actionName)
        {
            ///////////Commented in Oct 2015
            //int userid = getuserid();
            //feeEntities db = new feeEntities();
            //int roleid1 = db.users.Find(userid).roleid;
            //int roleid = Convert.ToInt32(roleid1);
            //var rmps = db.rolemodulepermissions.Where(r => r.roleid.Equals(roleid) && r.rolemodule.name.Equals(moduleName)).Select(r => new { r.permission, r.rolemoduleid }).FirstOrDefault();

            //if (rmps != null && rmps.permission)
            //{
            //    return (db.rolemoduleactionpermissions.Where(r => r.roleid.Equals(roleid) && r.rolemoduleaction.rolemoduleid.Equals(rmps.rolemoduleid) && r.rolemoduleaction.name.Equals(actionName)).Select(r => r.permission).FirstOrDefault());
            //}
            
            //return false;

            return true;
        }
    }

    public class MinValueAttribute : ValidationAttribute, IClientValidatable
    {
        private readonly double _minValue;

        public MinValueAttribute(double minValue)
        {
            _minValue = minValue;
            ErrorMessage = "Minimum value is " + _minValue;
        }

        public MinValueAttribute(int minValue)
        {
            _minValue = minValue;
            ErrorMessage = "Minimum value is " + _minValue;
        }

        public override bool IsValid(object value)
        {
            return Convert.ToDouble(value) >= _minValue;
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule();
            rule.ErrorMessage = ErrorMessage;
            rule.ValidationParameters.Add("min", _minValue);
            rule.ValidationParameters.Add("max", Double.MaxValue);
            rule.ValidationType = "range";
            yield return rule;
        }

    }

}