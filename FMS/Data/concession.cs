//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FMS.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class concession
    {
        public int id { get; set; }
        public int amount { get; set; }
        public string remarks { get; set; }
        public System.DateTime time { get; set; }
        public int studentid { get; set; }
        public int acaYearid { get; set; }
        public int feeTypeid { get; set; }
    
        public virtual acayear acayear { get; set; }
        public virtual feetype feetype { get; set; }
        public virtual student student { get; set; }
    }
}
