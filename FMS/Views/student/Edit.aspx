<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.student>" %>
<p class="moduleTitle">Students</p>

<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "mainContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend class="ui-widget-header ui-corner-top">Edit Student</legend>
    
            <%: Html.HiddenFor(model => model.id) %>
    <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.htno) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.htno) %>
                <%: Html.ValidationMessageFor(model => model.htno) %>
            </div>
    </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.name) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.name) %>
                <%: Html.ValidationMessageFor(model => model.name) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.fname) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.fname) %>
                <%: Html.ValidationMessageFor(model => model.fname) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.casteid, "caste") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("casteid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.casteid) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.quotaid, "quota") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("quotaid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.quotaid) %>
            </div>
    </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.batchid, "batch") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("batchid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.batchid) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.deptid, "dept") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("deptid", null,"Select Dept", new { onchange = "semDropDownFromDept($(this).val(),'semid')" })%>
                <%: Html.ValidationMessageFor(model => model.deptid) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.semid, "sem") %>
            </div>
             <div class="editor-field">
               <%-- <select name="semid" id="semid"><option value="">Select Sem</option></select>--%>
                <%: Html.DropDownList("semid", String.Empty)%>
                <%: Html.ValidationMessageFor(model => model.semid) %>
            </div>
   </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.feeExemption) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.feeExemption) %>
                <%: Html.ValidationMessageFor(model => model.feeExemption) %>
            </div>
   </div>
   <div class="clearFix" />
   
            <p>
                <input class="ui-button" type="submit" value="Save" />
                <%: Html.MyActionLink("Back to List", "student", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='studentIndex'")%> 
               
            </p>
        </fieldset>
    <% } %>
   
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>