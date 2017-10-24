<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.setfee>" %>
<p class="moduleTitle">Set Fee</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">setfee Details</legend>
    
        <div class="display-label  ui-state-default">student</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.student.htno) %>
        </div>
    
        <div class="display-label  ui-state-default">feetype</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.feetype.type) %>
        </div>
    
        <div class="display-label  ui-state-default">acayear</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.acayear.year) %>
        </div>
    
        <div class="display-label  ui-state-default">amount</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.amount) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "setfee", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='setfeeEdit'")%>
    	<%: Html.MyActionLink("Back to List", "setfee", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='setfeeIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
