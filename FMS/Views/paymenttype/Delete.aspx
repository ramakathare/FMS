<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.paymenttype>" %>
<p class="moduleTitle">Payment Type</p>
    
    <fieldset>
    
        <legend class="ui-widget-header ui-corner-top">Delete paymenttype</legend>
    	<h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">type</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.type) %>
        </div>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "masterContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
            <p>
                <input class="ui-button" type="submit" value="Delete" />
                <%: Html.MyActionLink("Back to List", "paymenttype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='paymenttypeIndex'")%> 
            </p>
        <% } %>
    </fieldset>
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>