<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.batch>>" %>

<p class="moduleTitle">Batch</p>

<p>
<%: Html.MyActionLink("Create New", "batch", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='batchCreate'")%> 
    
</p>
<table>
    <tr>
        <th>
            name
        </th>
        <th></th>
    </tr>

<% foreach (var item in Model) { %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.name) %>
        </td>
        <td>
            <%: Html.MyActionLink("Edit", "batch", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='batchEdit'")%>
			<%: Html.MyActionLink("Details", "batch", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='batchDetails'")%>
			<%: Html.MyActionLink("Delete", "batch", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='batchDelete'")%>
			
        </td>
    </tr>
<% } %>

</table>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>
