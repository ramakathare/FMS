﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.rolemodule>" %>
<p class="moduleTitle">Roles Module</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "mainContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend  class="ui-widget-header ui-corner-top">Add rolemodule</legend>

        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.name) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.name) %>
            <%: Html.ValidationMessageFor(model => model.name) %>
        </div>

        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.displayname) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.displayname) %>
            <%: Html.ValidationMessageFor(model => model.displayname) %>
        </div>

        <p>
            <input class="ui-button" type="submit" value="Create" />
			<%: Html.MyActionLink("Back to List", "rolemodule", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='rolemoduleIndex'")%> 
            
        </p>
    </fieldset>
<% } %>

<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>

