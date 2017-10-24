<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.quota>>" %>
<p class="moduleTitle">Admission Quota</p>
<p>
<%: Html.MyActionLink("Create New", "quota", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='quotaCreate'")%> 
    
</p>
<table>
    <tr>
        <th>
            name
        </th>
        <th>
            desc
        </th>
        <th></th>
    </tr>

<% foreach (var item in Model) { %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.name) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.desc) %>
        </td>
        <td>
            <%: Html.MyActionLink("Edit", "quota", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='quotaEdit'")%>
			<%: Html.MyActionLink("Details", "quota", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='quotaDetails'")%>
			<%: Html.MyActionLink("Delete", "quota", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='quotaDelete'")%>
			
        </td>
    </tr>
<% } %>

</table>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>
