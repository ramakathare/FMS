<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.cheque>" %>
<p class="moduleTitle">Cheque</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend  class="ui-widget-header ui-corner-top">Add cheque</legend>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.payFeeid, "payfee") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("payFeeid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.payFeeid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.bankName) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.bankName) %>
                <%: Html.ValidationMessageFor(model => model.bankName) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.bankAddress) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.bankAddress) %>
                <%: Html.ValidationMessageFor(model => model.bankAddress) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.chequenumber) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.chequenumber) %>
                <%: Html.ValidationMessageFor(model => model.chequenumber) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.dated) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.dated) %>
                <%: Html.ValidationMessageFor(model => model.dated) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.status) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.status) %>
                <%: Html.ValidationMessageFor(model => model.status) %>
            </div>
    
            <p>
                <input class="ui-button" type="submit" value="Create" />
    			<%: Html.MyActionLink("Back to List", "cheque", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='chequeIndex'")%> 
                
            </p>
        </fieldset>
    <% } %>
    
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
