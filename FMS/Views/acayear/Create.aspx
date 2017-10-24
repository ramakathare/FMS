<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.acayear>" %>

    <p class="moduleTitle">Academic Year</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "masterContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend  class="ui-widget-header ui-corner-top">Add acayear</legend>
    <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.year) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.year) %>
                <%: Html.ValidationMessageFor(model => model.year) %>
            </div>
    </div><div class="clearFix"></div>
            <p>
                <input class="ui-button" type="submit" value="Create" />
    			<%: Html.MyActionLink("Back to List", "acayear", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='acayearIndex'")%> 
                
            </p>
        </fieldset>
    <% } %>
    
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
