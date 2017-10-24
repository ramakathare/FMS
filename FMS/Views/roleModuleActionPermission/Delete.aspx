<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.rolemoduleactionpermission>" %>
<p class="moduleTitle">Roles Module Action Permissions</p>
    
    <fieldset>
    
        <legend class="ui-widget-header ui-corner-top">Delete rolemoduleactionpermission</legend>
    	<h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">role</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.role.roleName) %>
        </div>

        <div class="display-label ui-state-default">role</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.rolemoduleaction.rolemodule.name) %>
        </div>
    
        <div class="display-label ui-state-default">rolemoduleaction</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.rolemoduleaction.name) %>
        </div>
    
        <div class="display-label ui-state-default">permission</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.permission) %>
        </div>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
            <p>
                <input class="ui-button" type="submit" value="Delete" />
                <%: Html.MyActionLink("Back to List", "rolemoduleactionpermission", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleactionpermissionIndex'")%> 
            </p>
        <% } %>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
