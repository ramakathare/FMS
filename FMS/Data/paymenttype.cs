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
    
    public partial class paymenttype
    {
        public paymenttype()
        {
            this.payfees = new HashSet<payfee>();
        }
    
        public int id { get; set; }
        public string type { get; set; }
    
        public virtual ICollection<payfee> payfees { get; set; }
    }
}
