<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.quota>" %>
<p class="moduleTitle">Admission Quota</p>

<fieldset>

    <legend class="ui-widget-header ui-corner-top">Delete quota</legend>
	<h3 class="question">Are you sure you want to delete this?</h3>

    <div class="display-label ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>

    <div class="display-label ui-state-default">desc</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.desc) %>
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
            <%: Html.MyActionLink("Back to List", "quota", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='quotaIndex'")%> 
        </p>
    <% } %>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
