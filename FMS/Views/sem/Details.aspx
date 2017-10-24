<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.sem>" %>
<p class="moduleTitle">Semester</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">sem Details</legend>
    
        <div class="display-label  ui-state-default">name</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.name) %>
        </div>
    
        <div class="display-label  ui-state-default">dept</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.dept.name) %>
        </div>
    
        <div class="display-label  ui-state-default">desc</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.desc) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "sem", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='semEdit'")%>
    	<%: Html.MyActionLink("Back to List", "sem", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='semIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>