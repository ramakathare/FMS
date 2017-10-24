<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.cheque>" %>
<p class="moduleTitle">Cheque</p>
    
    <fieldset>
    
        <legend class="ui-widget-header ui-corner-top">Delete cheque</legend>
    	<h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">payfee</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.payfee.id) %>
        </div>
    
        <div class="display-label ui-state-default">bankName</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.bankName) %>
        </div>
    
        <div class="display-label ui-state-default">bankAddress</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.bankAddress) %>
        </div>
    
        <div class="display-label ui-state-default">chequenumber</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.chequenumber) %>
        </div>
    
        <div class="display-label ui-state-default">dated</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.dated) %>
        </div>
    
        <div class="display-label ui-state-default">status</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.status) %>
        </div>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
            <p>
                <input class="ui-button" type="submit" value="Delete" />
                <%: Html.MyActionLink("Back to List", "cheque", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='chequeIndex'")%> 
            </p>
        <% } %>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>