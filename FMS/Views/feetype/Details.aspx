<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.feetype>" %>
<p class="moduleTitle">Fee Type</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">feetype Details</legend>
    
        <div class="display-label  ui-state-default">type</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.type) %>
        </div>
        <div class="display-label  ui-state-default">Allowed Installments</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.allowedInstallments) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "feetype", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='feetypeEdit'")%>
    	<%: Html.MyActionLink("Back to List", "feetype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='feetypeIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
