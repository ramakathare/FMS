<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.payfee>" %>
<p class="moduleTitle">Fee Payments</p>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">payfee Details</legend>
    
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
            <%: Html.DisplayFor(model => model.acayear.id) %>
        </div>
    
        <div class="display-label  ui-state-default">amount</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.amount) %>
        </div>
    
        <div class="display-label  ui-state-default">recieptNo</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.recieptNo) %>
        </div>
    
        <div class="display-label  ui-state-default">time</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.time) %>
        </div>
    
        <div class="display-label  ui-state-default">paymenttype</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.paymenttype.type) %>
        </div>
    <p>
    	<%: Html.MyActionLink("Edit", "payfee", "Edit",new { id=Model.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='payfeeEdit'")%>
    	<%: Html.MyActionLink("Back to List", "payfee", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='payfeeIndex'")%> 
                
    </p>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
