<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.caste>" %>
<p class="moduleTitle">Caste</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "masterContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend  class="ui-widget-header ui-corner-top">Add caste</legend>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.name) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.name) %>
            <%: Html.ValidationMessageFor(model => model.name) %>
        </div>
            </div>
    </div><div class="clearFix"></div>
        <p>
            <input class="ui-button" type="submit" value="Create" />
			<%: Html.MyActionLink("Back to List", "caste", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='casteIndex'")%> 
            
        </p>
    </fieldset>
<% } %>

<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>

