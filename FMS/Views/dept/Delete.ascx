<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.dept>" %>
<p class="moduleTitle">Department</p>
<fieldset>

    <legend class="ui-widget-header ui-corner-top">Delete dept</legend>
	<h3 class="question">Are you sure you want to delete this?</h3>

    <div class="display-label ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>

    <div class="display-label ui-state-default">College</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.college.collegeName) %>
    </div>

    <div class="display-label ui-state-default">Duration</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.duration) %>
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
            <%: Html.MyActionLink("Back to List", "dept", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='deptIndex'")%> 
        </p>
    <% } %>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
