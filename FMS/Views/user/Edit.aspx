<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.user>" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Edit</title>
</head>
<body>
    <p class="moduleTitle">user</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend class="ui-widget-header ui-corner-top">Edit user</legend>
    
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
                <%: Html.LabelFor(model => model.username) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.username)%>
                <%: Html.ValidationMessageFor(model => model.username)%>
            </div>
     </div>
     <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.password) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.password) %>
                <%: Html.ValidationMessageFor(model => model.password) %>
            </div>
     </div><div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.roleid, "role") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("roleid",String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.roleid) %>
            </div>
     </div>
       <div class="clearFix"></div>      <p>
                <input class="ui-button" type="submit" value="Save" />
    			<%: Html.MyActionLink("Back to List", "user", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='userIndex'")%> 
                   
            </p>
        </fieldset>
    <% } %>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>
    
</body>
</html>
