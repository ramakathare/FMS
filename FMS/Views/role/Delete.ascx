<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.role>" %>
<p class="moduleTitle">Roles</p>

<fieldset>

    <legend class="ui-widget-header ui-corner-top">Delete role</legend>
	<h3 class="question">Are you sure you want to delete this?</h3>

    <div class="display-label ui-state-default">roleName</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.roleName) %>
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
            <%: Html.MyActionLink("Back to List", "role", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='roleIndex'")%> 
        </p>
    <% } %>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
