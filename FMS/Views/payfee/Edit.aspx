<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.payfee>" %>
<p class="moduleTitle">Fee Payments</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend class="ui-widget-header ui-corner-top">Edit payfee</legend>
    
            <%: Html.HiddenFor(model => model.id) %>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.studentid, "student") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("studentid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.studentid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.feeTypeid, "feetype") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("feeTypeid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.feeTypeid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.acaYearid, "acayear") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("acaYearid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.acaYearid) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.amount) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.amount) %>
                <%: Html.ValidationMessageFor(model => model.amount) %>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.recieptNo) %>
            </div>
            <div class="editor-field">
                <%: Html.DisplayFor(model => model.recieptNo)%>
                <%: Html.HiddenFor(model => model.recieptNo) %>
               <%-- <%: Html.ValidationMessageFor(model => model.recieptNo) %>--%>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.time) %>
            </div>
            <div class="editor-field">
                <%: Html.DisplayFor(model => model.time) %>
                <%: Html.HiddenFor(model => model.time) %>
                <%--<%: Html.ValidationMessageFor(model => model.time) %>--%>
            </div>
    
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.paymentTypeid, "paymenttype") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("paymentTypeid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.paymentTypeid) %>
            </div>
    
            <p>
                <input class="ui-button" type="submit" value="Save" />
    			<%: Html.MyActionLink("Back to List", "payfee", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='payfeeIndex'")%> 
                   
            </p>
        </fieldset>
    <% } %>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>
