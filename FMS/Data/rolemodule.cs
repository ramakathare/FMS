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
    
    public partial class rolemodule
    {
        public rolemodule()
        {
            this.rolemoduleactions = new HashSet<rolemoduleaction>();
            this.rolemodulepermissions = new HashSet<rolemodulepermission>();
        }
    
        public int id { get; set; }
        public string name { get; set; }
        public string displayname { get; set; }
    
        public virtual ICollection<rolemoduleaction> rolemoduleactions { get; set; }
        public virtual ICollection<rolemodulepermission> rolemodulepermissions { get; set; }
    }
}
