<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.rolemodulepermission>" %>
<p class="moduleTitle">Roles Module Permissions</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">rolemodulepermission Details</legend>
    
        <div class="display-label  ui-state-default">role</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.role.roleName) %>
        </div>
    
        <div class="display-label  ui-state-default">rolemodule</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.rolemodule.name) %>
        </div>
    
        <div class="display-label  ui-state-default">permission</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.permission) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "rolemodulepermission", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemodulepermissionEdit'")%>
    	<%: Html.MyActionLink("Back to List", "rolemodulepermission", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemodulepermissionIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>