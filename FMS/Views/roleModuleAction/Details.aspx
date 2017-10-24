<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.rolemoduleaction>" %>
<p class="moduleTitle">Roles Module Actions</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">rolemoduleaction Details</legend>
    
        <div class="display-label  ui-state-default">rolemodule</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.rolemodule.name) %>
        </div>
    
        <div class="display-label  ui-state-default">name</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.name) %>
        </div>
    
        <div class="display-label  ui-state-default">displayname</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.displayname) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "rolemoduleaction", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleactionEdit'")%>
    	<%: Html.MyActionLink("Back to List", "rolemoduleaction", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleactionIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>