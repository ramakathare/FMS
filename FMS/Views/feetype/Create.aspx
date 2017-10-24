<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.feetype>" %>
<p class="moduleTitle">Fee Type</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "masterContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend  class="ui-widget-header ui-corner-top">Add feetype</legend>
     <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.type) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.type) %>
                <%: Html.ValidationMessageFor(model => model.type) %>
            </div>
    </div>
    <div class="formFieldDiv"> 
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.allowedInstallments) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.allowedInstallments) %>
                <%: Html.ValidationMessageFor(model => model.allowedInstallments) %>
            </div>
    </div>    <div class="clearFix"></div>
            <p>
                <input class="ui-button" type="submit" value="Create" />
    			<%: Html.MyActionLink("Back to List", "feetype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='feetypeIndex'")%> 
                
            </p>
        </fieldset>
    <% } %>
    
    <script type="text/javascript">
        $(function () {
            commonFunctions();
        });
       </script>
