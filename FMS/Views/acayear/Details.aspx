<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.acayear>" %>

    <p class="moduleTitle">Academic Year</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">acayear Details</legend>
    
        <div class="display-label  ui-state-default">year</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.year) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "acayear", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='acayearEdit'")%>
    	<%: Html.MyActionLink("Back to List", "acayear", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='acayearIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>