<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.batch>" %>
<p class="moduleTitle">Batch</p>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">batch Details</legend>

    <div class="display-label  ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>
<p>
	<%: Html.MyActionLink("Edit", "batch", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='batchEdit'")%>
	<%: Html.MyActionLink("Back to List", "batch", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='batchIndex'")%> 
            
</p>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
