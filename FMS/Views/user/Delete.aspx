<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.user>" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Delete</title>
</head>
<body>
    <p class="moduleTitle">user</p>
    <fieldset>
    
        <legend class="ui-widget-header ui-corner-top">Delete user</legend>
    	<h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">name</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.name) %>
        </div>

        <div class="display-label ui-state-default">username</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.username) %>
        </div>
    
        <div class="display-label ui-state-default">password</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.password)%>
        </div>
    
        <div class="display-label ui-state-default">role</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.role.roleName)%>
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
                <%: Html.MyActionLink("Back to List", "user", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='userIndex'")%> 
            </p>
        <% } %>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
</body>
</html>
