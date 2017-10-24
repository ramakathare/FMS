<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.role>" %>
<p class="moduleTitle">Roles</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "mainContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">Edit role</legend>

        <%: Html.HiddenFor(model => model.id) %>

        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.roleName) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.roleName) %>
            <%: Html.ValidationMessageFor(model => model.roleName) %>
        </div>

        <p>
            <input class="ui-button" type="submit" value="Save" />
			<%: Html.MyActionLink("Back to List", "role", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='roleIndex'")%> 
               
        </p>
    </fieldset>
<% } %>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>

