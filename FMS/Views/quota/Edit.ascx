<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.quota>" %>
<p class="moduleTitle">Admission Quota</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "masterContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">Edit quota</legend>

        <%: Html.HiddenFor(model => model.id) %>
  <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.name) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.name) %>
            <%: Html.ValidationMessageFor(model => model.name) %>
        </div>
</div>    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.desc) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.desc) %>
            <%: Html.ValidationMessageFor(model => model.desc) %>
        </div>
</div>    <div class="clearFix"></div>
        <p>
            <input class="ui-button" type="submit" value="Save" />
			<%: Html.MyActionLink("Back to List", "quota", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='quotaIndex'")%> 
               
        </p>
    </fieldset>
<% } %>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>

