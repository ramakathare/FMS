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
    
    public partial class caste
    {
        public caste()
        {
            this.students = new HashSet<student>();
        }
    
        public int id { get; set; }
        public string name { get; set; }
    
        public virtual ICollection<student> students { get; set; }
    }
}
