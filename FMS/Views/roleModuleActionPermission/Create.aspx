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
            <legend  class="ui-widget-header ui-corner-top">Add rolemoduleactionpermission</legend>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.roleid, "role") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("roleid",null,"Select",new{onchange = "getRoleModules($(this).val())" })%>
                <%: Html.ValidationMessageFor(model => model.roleid) %>
            </div>

            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.rolemoduleaction.rolemoduleid, "rolemodule") %>
            </div>
            <div class="editor-field">
                <select id="rolemoduleid" name="rolemoduleid" onchange="getRoleModuleActions($(this).val())">
                    <option value="0">Select</option>
                </select>
                <%//: Html.DropDownList("rolemoduleid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.rolemoduleaction.rolemoduleid)%>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.rolemoduleactionid, "rolemoduleaction") %>
            </div>
            <div class="editor-field">
               <select id="rolemoduleactionid" name="rolemoduleactionid">
                    <option value="0">Select</option>
                </select>
                <%//: Html.DropDownList("rolemoduleactionid", String.Empty) %>
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
                <input class="ui-button" type="submit" value="Create" />
    			<%: Html.MyActionLink("Back to List", "rolemoduleactionpermission", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleactionpermissionIndex'")%> 
                
            </p>
        </fieldset>
    <% } %>
    
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });

        function getRoleModules(roleid) {
            $.getJSON('/roleModule/GetRoleModules/' + roleid, function (response) {
                $("#rolemoduleid > option").remove();
                $("#rolemoduleid").append($("<option />").val(0).text("Select"));

                $("#rolemoduleactionid > option").remove();
                $("#rolemoduleactionid").append($("<option />").val(0).text("Select"));

                for (i = 0; i < response.length; i++) {
                    $("#rolemoduleid").append($("<option />").val(response[i].id).text(response[i].name));
                }
            });
        }


         //   $('#rolemoduleid').load('/roleModule/GetRoleModules/' + roleid);
       // }
        function getRoleModuleActions(rolemoduleid) {
            $.getJSON('/roleModuleAction/GetRoleModuleActions/' + rolemoduleid, function (response) {
                $("#rolemoduleactionid > option").remove();
                $("#rolemoduleactionid").append($("<option />").val(0).text("Select"));
                for (i = 0; i < response.length; i++) {
                    $("#rolemoduleactionid").append($("<option />").val(response[i].id).text(response[i].name));
                }
            });
           // $('#rolemoduleactionid').load('/roleModuleAction/GetRoleModuleActions/' + rolemoduleid);
        }
       </script>
