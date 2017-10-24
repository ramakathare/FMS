<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.role>" %>
<p class="moduleTitle">Roles</p>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">role Details</legend>

    <div class="display-label  ui-state-default">roleName</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.roleName) %>
    </div>
<p>
	<%: Html.MyActionLink("Edit", "role", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='roleEdit'")%>
	<%: Html.MyActionLink("Back to List", "role", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='roleIndex'")%> 
            
</p>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
