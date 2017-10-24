<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.reimbursement>" %>

    <p class="moduleTitle">reimbursement</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">reimbursement Details</legend>
    
        <div class="display-label  ui-state-default">student</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.student.htno) %>
        </div>
    
        <div class="display-label  ui-state-default">acayear</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.acayear.year) %>
        </div>
    
        <div class="display-label  ui-state-default">epassid</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.epassid) %>
        </div>
    
        <div class="display-label  ui-state-default">date</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.date) %>
        </div>
    
        <div class="display-label  ui-state-default">remarks</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.remarks) %>
        </div>
    
        <div class="display-label  ui-state-default">approved</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.approved) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "reimbursement", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='reimbursementEdit'")%>
    	<%: Html.MyActionLink("Back to List", "reimbursement", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='reimbursementIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>