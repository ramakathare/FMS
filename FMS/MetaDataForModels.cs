using System.ComponentModel.DataAnnotations;
using System.Web;
using System.Web.Mvc;
using FMS.Helper;
using System.ComponentModel;

namespace FMS.Data
{
    //############################### acayear ###########################################
    [MetadataType(typeof(acayearMD))]
    public partial class acayear
    { }
    public class acayearMD
    {
        [Key]
        public int id { get; set; }
        [Display(Name = "Academic Year"), MinValue(2000)]
        public short year { get; set; }
    }
    //############################### Batch ###########################################
    [MetadataType(typeof(batchMD))]
    public partial class batch
    {}
    public class batchMD
    {
        [Key]
        public int id { get; set; }

        [Display(Name="Batch"), MinValue(2000)]
        public short name { get; set; }
    }

    //############################### Caste ###########################################
    [MetadataType(typeof(casteMD))]
    public partial class caste
    {
    }
    public partial class casteMD{
        [Key]
        public int id { get; set; }

        [Required(ErrorMessage = "Caste Name is required"),Display(Name = "Caste"),MinLength(2),MaxLength(20)]
        public string name { get; set; }
    }

     //############################### Sem ###########################################
    [MetadataType(typeof(semMD))]
    public partial class sem
    {
    }
    public partial class semMD{
        [Key]
        public int id { get; set; }

        [Required(ErrorMessage = "Sem Name is required"),Display(Name = "Semester"),MinLength(3),MaxLength(30)]
        public string name { get; set; }

        [Display(Name = "Description"),MaxLength(50)]
        public string desc { get; set; }

        [ForeignKey("dept")]
        [Required(ErrorMessage = "Department is required")]
        public int deptid { get; set; }
    }

    //############################### Quota ###########################################
    [MetadataType(typeof(quotaMD))]
    public partial class quota
    {
    }
    public partial class quotaMD{
        [Key]
        public int id { get; set; }

        [Required(ErrorMessage = "Quota Name is required"),Display(Name = "Quota"),MinLength(2),MaxLength(20)]
        public string name { get; set; }

        [Display(Name = "Quota Description"),MaxLength(50)]
        public string desc { get; set; }

       
    }

    //############################### Dept ###########################################
    [MetadataType(typeof(deptMD))]
    public partial class dept
    {
    }
    public partial class deptMD{
        [Key]
        public int id { get; set; }

        [Required(ErrorMessage = "Department Name is required"), Display(Name = "Department"),MinLength(3),MaxLength(20)]
        public string name { get; set; }

        [Required(ErrorMessage = "Duration Name is required"), Display(Name = "Duration"),MinValue(2)]
        public short duration { get; set; }

        [ForeignKey("college"), Display(Name = "College")]
        public int collegeid { get; set; }

        [Display(Name = "Description"),MaxLength(45)]
        public string desc { get; set; }
    }

    //############################### Student ###########################################
    [MetadataType(typeof(studentMD))]
    public partial class student
    {
    }
    public partial class studentMD{
        [Key]
        public int id { get; set; }

        [Required(ErrorMessage = "HTNo is required"), Display(Name = "HTNo"), MinLength(10), MaxLength(10)]
        public string htno { get; set; }

        [Required(ErrorMessage = "Name is required"), Display(Name = "Full Name"), MinLength(3), MaxLength(50)]
        public string name { get; set; }

        [Display(Name = "Father Name"), MinLength(3), MaxLength(50)]
        public string fname { get; set; }

        [ForeignKey("caste")]
        public int casteid { get; set; }

        [ForeignKey("quota")]
        public int quotaid { get; set; }

        [ForeignKey("batch")]
        public int batchid { get; set; }

        [ForeignKey("dept")]
        public int deptid { get; set; }

        [ForeignKey("sem")]
        public int semid { get; set; }

        [Required(ErrorMessage = "Fee Exemption Status is required"), Display(Name = "Fee Exemption")]
        public bool feeExemption { get; set; }
    }

    //############################### SetFee ###########################################
    [MetadataType(typeof(setfeeMD))]
    public partial class setfee
    {
    }
    public partial class setfeeMD
    {
        [Key]
        public int id { get; set; }
        [ForeignKey("student")]
        public int studentid { get; set; }
        [ForeignKey("feetype")]
        public int feeTypeid { get; set; }
        [ForeignKey("acayear")]
        public int acaYearid { get; set; }
        [Required(ErrorMessage = "amount is required"), Display(Name = "Amount"), MinValue(100)]
        public long amount { get; set; }

    }



    [MetadataType(typeof(collegeMD))]
    public partial class college
    {
    }
    public partial class collegeMD
    {

        [Key]
        public int collegeid { get; set; }

        [Required(ErrorMessage = "CollegeCode is required"), Display(Name = "College Code"), MinLength(1), MaxLength(2)]
        public string collegeCode { get; set; }

        [Required(ErrorMessage = "College Name is required"), Display(Name = "College Name"), MinLength(3), MaxLength(50)]
        public string collegeName { get; set; }

    }

    [MetadataType(typeof(feetypeMD))]
    public partial class feetype
    {
    }
    public partial class feetypeMD
    {
        [Key]
        public int id { get; set; }
        [Required(ErrorMessage = "Feetype is required"), Display(Name = "FeeType"),MinLength(3)]
        public string type { get; set; }
        [Required(ErrorMessage = "Installments is required"), Display(Name = "Allowed Installments"), MinValue(-1)]
        public short allowedInstallments { get; set; }
    }

    [MetadataType(typeof(paymenttypeMD))]
    public partial class paymenttype
    {
    }
    public partial class paymenttypeMD
    {
        [Key]
        public int id { get; set; }
        [Required(ErrorMessage = "Payment Type is required"), Display(Name = "Payment Type"), MinLength(3)]
        public string type { get; set; }
    }

    [MetadataType(typeof(payfeeMD))]
    public partial class payfee
    {
    }
    public partial class payfeeMD
    {
        [Key]
        public int id { get; set; }
        [ForeignKey("student")]
        public int studentid { get; set; }
        [ForeignKey("feetype")]
        public int feeTypeid { get; set; }
        [ForeignKey("acayear")]
        public int acaYearid { get; set; }
        [Required(ErrorMessage = "amount is required"), Display(Name = "Amount"), MinValue(100)]
        public long amount { get; set; }
        [ForeignKey("paymenttype")]
        public int paymentTypeid { get; set; }
    }


    [MetadataType(typeof(concessionMD))]
    public partial class concession
    {
    }
    public partial class concessionMD
    {
        [Key]
        public int id { get; set; }
        [Required(ErrorMessage = "amount is required"), Display(Name = "Amount"), MinValue(1)]
        public int amount { get; set; }
        [Required(ErrorMessage = "Remarks are required"), Display(Name = "Remarks"), MinLength(5), MaxLength(250)]
        public string remarks { get; set; }
        public System.DateTime time { get; set; }
        [ForeignKey("student")]
        public int studentid { get; set; }
        [ForeignKey("acayear")]
        public int acaYearid { get; set; }
        [ForeignKey("feetype")]
        public int feeTypeid { get; set; }

    }

    [MetadataType(typeof(userMD))]
    public partial class user
    {
    }

    public partial class userMD
    {   [Key]
        public int id { get; set; }

        [Required]
        [Display(Name = "Name"), MinLength(5)]
        public string name { get; set; }

        [Required]
        [Display(Name = "User name"), MinLength(4)]
        public string username { get; set; }

        [Required]
        [DataType(DataType.Password), MinLength(5)]
        [Display(Name = "Password")]
        public string password { get; set; }

        [ForeignKey("role")]
        public int roleid { get; set; }
    }

    [MetadataType(typeof(reimbursementMD))]
    public partial class reimbursement
    {
        
    }

    public partial class reimbursementMD
    {
        [Key]
        public int id { get; set; }
        [ForeignKey("student")]
        public int studentid { get; set; }
        [ForeignKey("acayear")]
        public int acaYearid { get; set; }
        [Required]
        [Display(Name = "ePassid"), MinLength(12), MaxLength(12)]
        public string epassid { get; set; }
        [Required]
        public System.DateTime date { get; set; }
        [Required]
        public bool approved { get; set; }
        [Display(Name = "Remarks"), MinLength(5), MaxLength(250)]
        public string remarks { get; set; }
    }

    
   
}

