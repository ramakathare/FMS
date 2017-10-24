<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.paymenttype>" %>
<p class="moduleTitle">Payment Type</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">paymenttype Details</legend>
    
        <div class="display-label  ui-state-default">type</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.type) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "paymenttype", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='paymenttypeEdit'")%>
    	<%: Html.MyActionLink("Back to List", "paymenttype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='paymenttypeIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>