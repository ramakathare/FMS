<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.rolemoduleactionpermission>" %>
<p class="moduleTitle">Roles Module Action Permissions</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend class="ui-widget-header ui-corner-top">Edit rolemoduleactionpermission</legend>
    
            <%: Html.HiddenFor(model => model.id) %>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.roleid, "role") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("roleid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.roleid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.rolemoduleaction.rolemoduleid, "rolemodule") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("rolemoduleid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.rolemoduleaction.rolemoduleid) %>
            </div>
            
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.rolemoduleactionid, "rolemoduleaction") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("rolemoduleactionid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.rolemoduleactionid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.permission) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.permission) %>
                <%: Html.ValidationMessageFor(model => model.permission) %>
            </div>
    
            <p>
                <input class="ui-button" type="submit" value="Save" />
    			<%: Html.MyActionLink("Back to List", "rolemoduleactionpermission", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleactionpermissionIndex'")%> 
                   
            </p>
        </fieldset>
    <% } %>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>
