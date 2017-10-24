<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.quota>" %>
<p class="moduleTitle">Admission Quota</p>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">quota Details</legend>

    <div class="display-label  ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>

    <div class="display-label  ui-state-default">desc</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.desc) %>
    </div>
<p>
	<%: Html.MyActionLink("Edit", "quota", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='quotaEdit'")%>
	<%: Html.MyActionLink("Back to List", "quota", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='quotaIndex'")%> 
            
</p>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
