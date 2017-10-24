<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<FMS.Data.caste>" %>
<p class="moduleTitle">Caste</p>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">caste Details</legend>

    <div class="display-label  ui-state-default">name</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.name) %>
    </div>
<p>
	<%: Html.MyActionLink("Edit", "caste", "Edit",new { id=Model.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='casteEdit'")%>
	<%: Html.MyActionLink("Back to List", "caste", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='casteIndex'")%> 
            
</p>
</fieldset>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
