<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.caste>" %>

<p class="moduleTitle">Caste</p>
<fieldset>

    <legend  class="ui-widget-header ui-corner-top">Delete caste</legend>
	<h3 class="question">Are you sure you want to delete this?</h3>

    <div class="display-label ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "masterContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
        <p>
            <input class="ui-button" type="submit" value="Delete" />
            <%: Html.MyActionLink("Back to List", "caste", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='casteIndex'")%> 
        </p>
    <% } %>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
