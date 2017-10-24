<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.rolemodule>" %>
<p class="moduleTitle">Roles Module</p>

<fieldset>

    <legend class="ui-widget-header ui-corner-top">Delete rolemodule</legend>
	<h3 class="question">Are you sure you want to delete this?</h3>

    <div class="display-label ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>

    <div class="display-label ui-state-default">displayname</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.displayname) %>
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
            <%: Html.MyActionLink("Back to List", "rolemodule", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleIndex'")%> 
        </p>
    <% } %>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
