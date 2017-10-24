<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.setfee>" %>

<p class="moduleTitle">
    Set Fee</p>
<% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };

   using (Ajax.BeginForm(options))
   { %>
<%: Html.ValidationSummary(true) %>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Add setfee</legend>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.studentid, "student") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("studentid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.studentid) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.feeTypeid, "feetype") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("feeTypeid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.feeTypeid) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.acaYearid, "acayear") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("acaYearid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.acaYearid) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.amount) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.amount) %>
            <%: Html.ValidationMessageFor(model => model.amount) %>
        </div>
    </div>
    <div class="clearFix"></div>
        <p>
            <input class="ui-button" type="submit" value="Create" />
            <%: Html.MyActionLink("Back to List", "setfee", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='setfeeIndex'")%>
        </p>
</fieldset>
<% } %>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
</script>
