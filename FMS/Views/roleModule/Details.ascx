<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.rolemodule>" %>
<p class="moduleTitle">Roles Module</p>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">rolemodule Details</legend>

    <div class="display-label  ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>

    <div class="display-label  ui-state-default">displayname</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.displayname) %>
    </div>
<p>
	<%: Html.MyActionLink("Edit", "rolemodule", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleEdit'")%>
	<%: Html.MyActionLink("Back to List", "rolemodule", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleIndex'")%> 
            
</p>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
