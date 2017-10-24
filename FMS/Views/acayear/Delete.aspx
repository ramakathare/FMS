<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.acayear>" %>

    <p class="moduleTitle">Academic Year</p>
    <fieldset>
    
        <legend class="ui-widget-header ui-corner-top">Delete acayear</legend>
    	<h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">year</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.year) %>
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
                <%: Html.MyActionLink("Back to List", "acayear", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='acayearIndex'")%> 
            </p>
        <% } %>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
