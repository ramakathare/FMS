<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.dept>" %>
<p class="moduleTitle">Department</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "masterContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">Edit dept</legend>

        <%: Html.HiddenFor(model => model.id) %>
   <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.name) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.name) %>
            <%: Html.ValidationMessageFor(model => model.name) %>
        </div>
</div>    
<div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.collegeid) %>
        </div>
        <div class="editor-field">
           <%: Html.DropDownList("collegeid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.collegeid) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.desc) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.desc) %>
            <%: Html.ValidationMessageFor(model => model.desc) %>
        </div>
</div>    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.duration) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.duration) %>
            <%: Html.ValidationMessageFor(model => model.duration) %>
        </div>
</div>    <div class="clearFix"></div>

        <p>
            <input class="ui-button" type="submit" value="Save" />
			<%: Html.MyActionLink("Back to List", "dept", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='deptIndex'")%> 
               
        </p>
    </fieldset>
<% } %>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>

