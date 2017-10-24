using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Web.Mvc;
using System.Web.Security;

namespace FMS.Models
{

    public class bulkSetFee
    {
        [Key]
        public int id { get; set; }
        [Required]
        public int feeTypeid { get; set; }
        [Required]
        public int acaYearid { get; set; }
    }
}
