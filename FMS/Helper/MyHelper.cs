using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Linq.Expressions;
using System.ComponentModel;

namespace FMS.Helper
{
    public abstract class BaseViewModel
    {
        protected BaseViewModel()
        {
            // apply any DefaultValueAttribute settings to their properties
            var propertyInfos = this.GetType().GetProperties();
            foreach (var propertyInfo in propertyInfos)
            {
                var attributes = propertyInfo.GetCustomAttributes(typeof(DefaultValueAttribute), true);
                if (attributes.Any())
                {
                    var attribute = (DefaultValueAttribute)attributes[0];
                    propertyInfo.SetValue(this, attribute.Value, null);
                }
            }
        }
    }

    public static partial class ControllerExtensions
    {
        public static string RenderPartialViewToString(this ControllerBase controller, string partialPath, object model)
        {
            if (string.IsNullOrEmpty(partialPath))
                partialPath = controller.ControllerContext.RouteData.GetRequiredString("action");

            controller.ViewData.Model = model;

            using (StringWriter sw = new StringWriter())
            {
                ViewEngineResult viewResult = ViewEngines.Engines.FindPartialView(controller.ControllerContext, partialPath);
                ViewContext viewContext = new ViewContext(controller.ControllerContext, viewResult.View, controller.ViewData, controller.TempData, sw);
                // copy model state items to the html helper 
                foreach (var item in viewContext.Controller.ViewData.ModelState)
                    if (!viewContext.ViewData.ModelState.Keys.Contains(item.Key))
                    {
                        viewContext.ViewData.ModelState.Add(item);
                    }


                viewResult.View.Render(viewContext, sw);

                return sw.GetStringBuilder().ToString();
            }
        }

        public static string RenderPartialToString2(string viewName, object model, ControllerContext ControllerContext)
        {
            if (string.IsNullOrEmpty(viewName))
                viewName = ControllerContext.RouteData.GetRequiredString("action");
            ViewDataDictionary ViewData = new ViewDataDictionary();
            TempDataDictionary TempData = new TempDataDictionary();
            ViewData.Model = model;

            using (StringWriter sw = new StringWriter())
            {
                ViewEngineResult viewResult = ViewEngines.Engines.FindPartialView(ControllerContext,viewName);
                ViewContext viewContext = new ViewContext(ControllerContext, viewResult.View, ViewData, TempData, sw);
                viewResult.View.Render(viewContext, sw);
                return sw.GetStringBuilder().ToString();
            }

        }

        public static string RenderViewToString1(
          ControllerContext controllerContext,
          string viewPath,
          string masterPath,
          ViewDataDictionary viewData,
          TempDataDictionary tempData)
        {
            Stream filter = null;
            ViewPage viewPage = new ViewPage();


            var writer = new StringWriter();

            //Right, create our view
            viewPage.ViewContext = new ViewContext(controllerContext, new WebFormView(controllerContext, viewPath, masterPath), viewData, tempData, writer);

            //Get the response context, flush it and get the response filter.
            var response = viewPage.ViewContext.HttpContext.Response;
            response.Flush();
            var oldFilter = response.Filter;

            try
            {
                //Put a new filter into the response
                filter = new MemoryStream();
                response.Filter = filter;

                //Now render the view into the memorystream and flush the response
                viewPage.ViewContext.View.Render(viewPage.ViewContext, viewPage.ViewContext.HttpContext.Response.Output);
                response.Flush();

                //Now read the rendered view.
                filter.Position = 0;
                var reader = new StreamReader(filter, response.ContentEncoding);
                return reader.ReadToEnd();
            }
            finally
            {
                //Clean up.
                if (filter != null)
                {
                    filter.Dispose();
                }

                //Now replace the response filter
                response.Filter = oldFilter;
            }
        }
    }

    public static partial class base64Encryption
    {
        public static String Encrypt(string source)
        {
            DESCryptoServiceProvider des = new DESCryptoServiceProvider();
            byte[] Key = { 12, 13, 16, 14, 16, 18, 18, 19 };
            byte[] IV = { 12, 13, 18, 15, 16, 17, 14, 19 };

            ICryptoTransform encryptor = des.CreateEncryptor(Key, IV);

            try
            {
                byte[] IDToBytes = ASCIIEncoding.ASCII.GetBytes(source);
                byte[] encryptedID = encryptor.TransformFinalBlock(IDToBytes, 0, IDToBytes.Length);
                return Convert.ToBase64String(encryptedID);
            }
            catch (FormatException)
            {
                return null;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static MvcHtmlString decryptedDisplayFor<TModel, TValue>(this HtmlHelper<TModel> html, Expression<Func<TModel, TValue>> expression)
        {
            object o = expression.Compile().Invoke(html.ViewData.Model);
            return new MvcHtmlString(base64Encryption.Decrypt(o.ToString()));
        }

        public static string Decrypt(string encrypted)
        {
            byte[] Key = { 12, 13, 16, 14, 16, 18, 18, 19 };
            byte[] IV = { 12, 13, 18, 15, 16, 17, 14, 19 };

            DESCryptoServiceProvider des = new DESCryptoServiceProvider();
            ICryptoTransform decryptor = des.CreateDecryptor(Key, IV);

            try
            {
                byte[] encryptedIDToBytes = Convert.FromBase64String(encrypted);
                byte[] IDToBytes = decryptor.TransformFinalBlock(encryptedIDToBytes, 0, encryptedIDToBytes.Length);
                return ASCIIEncoding.ASCII.GetString(IDToBytes);
            }
            catch (FormatException)
            {
                return null;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    public partial class NumberToEnglish
    {

        public String changeNumericToWords(double numb)
        {

            String num = numb.ToString();

            return changeToWords(num, false);

        }

        public String changeCurrencyToWords(String numb)
        {

            return changeToWords(numb, true);

        }

        public String changeNumericToWords(String numb)
        {

            return changeToWords(numb, false);

        }

        public String changeCurrencyToWords(double numb)
        {

            return changeToWords(numb.ToString(), true);

        }

        private String changeToWords(String numb, bool isCurrency)
        {

            String val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";

            String endStr = (isCurrency) ? ("Only") : ("");

            try
            {

                int decimalPlace = numb.IndexOf(".");

                if (decimalPlace > 0)
                {

                    wholeNo = numb.Substring(0, decimalPlace);

                    points = numb.Substring(decimalPlace + 1);

                    if (Convert.ToInt32(points) > 0)
                    {

                        andStr = (isCurrency) ? ("and") : ("point");// just to separate whole numbers from points/cents

                        endStr = (isCurrency) ? ("Cents " + endStr) : ("");

                        pointStr = translateCents(points);

                    }

                }

                val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);

            }

            catch { ;}

            return val;

        }

        private String translateWholeNumber(String number)
        {

            string word = "";

            try
            {

                bool beginsZero = false;//tests for 0XX

                bool isDone = false;//test if already translated

                double dblAmt = (Convert.ToDouble(number));

                //if ((dblAmt > 0) && number.StartsWith("0"))

                if (dblAmt > 0)
                {//test for zero or digit zero in a nuemric

                    beginsZero = number.StartsWith("0");

                    int numDigits = number.Length;

                    int pos = 0;//store digit grouping

                    String place = "";//digit grouping name:hundres,thousand,etc...

                    switch (numDigits)
                    {

                        case 1://ones' range

                            word = ones(number);

                            isDone = true;

                            break;

                        case 2://tens' range

                            word = tens(number);

                            isDone = true;

                            break;

                        case 3://hundreds' range

                            pos = (numDigits % 3) + 1;

                            place = " Hundred ";

                            break;

                        case 4://thousands' range

                        case 5:

                        case 6:

                            pos = (numDigits % 4) + 1;

                            place = " Thousand ";

                            break;

                        case 7://millions' range

                        case 8:

                        case 9:

                            pos = (numDigits % 7) + 1;

                            place = " Million ";

                            break;

                        case 10://Billions's range

                            pos = (numDigits % 10) + 1;

                            place = " Billion ";

                            break;

                        //add extra case options for anything above Billion...

                        default:

                            isDone = true;

                            break;

                    }

                    if (!isDone)
                    {//if transalation is not done, continue...(Recursion comes in now!!)

                        word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));

                        //check for trailing zeros

                        if (beginsZero) word = " and " + word.Trim();

                    }

                    //ignore digit grouping names

                    if (word.Trim().Equals(place.Trim())) word = "";

                }

            }

            catch { ;}

            return word.Trim();

        }

        private String tens(String digit)
        {

            int digt = Convert.ToInt32(digit);

            String name = null;

            switch (digt)
            {

                case 10:

                    name = "Ten";

                    break;

                case 11:

                    name = "Eleven";

                    break;

                case 12:

                    name = "Twelve";

                    break;

                case 13:

                    name = "Thirteen";

                    break;

                case 14:

                    name = "Fourteen";

                    break;

                case 15:

                    name = "Fifteen";

                    break;

                case 16:

                    name = "Sixteen";

                    break;

                case 17:

                    name = "Seventeen";

                    break;

                case 18:

                    name = "Eighteen";

                    break;

                case 19:

                    name = "Nineteen";

                    break;

                case 20:

                    name = "Twenty";

                    break;

                case 30:

                    name = "Thirty";

                    break;

                case 40:

                    name = "Fourty";

                    break;

                case 50:

                    name = "Fifty";

                    break;

                case 60:

                    name = "Sixty";

                    break;

                case 70:

                    name = "Seventy";

                    break;

                case 80:

                    name = "Eighty";

                    break;

                case 90:

                    name = "Ninety";

                    break;

                default:

                    if (digt > 0)
                    {

                        name = tens(digit.Substring(0, 1) + "0") + " " + ones(digit.Substring(1));

                    }

                    break;

            }

            return name;

        }

        private String ones(String digit)
        {

            int digt = Convert.ToInt32(digit);

            String name = "";

            switch (digt)
            {

                case 1:

                    name = "One";

                    break;

                case 2:

                    name = "Two";

                    break;

                case 3:

                    name = "Three";

                    break;

                case 4:

                    name = "Four";

                    break;

                case 5:

                    name = "Five";

                    break;

                case 6:

                    name = "Six";

                    break;

                case 7:

                    name = "Seven";

                    break;

                case 8:

                    name = "Eight";

                    break;

                case 9:

                    name = "Nine";

                    break;

            }

            return name;

        }

        private String translateCents(String cents)
        {

            String cts = "", digit = "", engOne = "";

            for (int i = 0; i < cents.Length; i++)
            {

                digit = cents[i].ToString();

                if (digit.Equals("0"))
                {

                    engOne = "Zero";

                }

                else
                {

                    engOne = ones(digit);

                }

                cts += " " + engOne;

            }

            return cts;

        }

    }
}