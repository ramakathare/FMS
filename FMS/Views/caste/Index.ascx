<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.caste>>" %>

<p class="moduleTitle">Caste</p>
<p>
<%: Html.MyActionLink("Create New", "caste", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='casteCreate'")%> 
    
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
            <%: Html.MyActionLink("Edit", "caste", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='casteEdit'")%>
			<%: Html.MyActionLink("Details", "caste", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='casteDetails'")%>
			<%: Html.MyActionLink("Delete", "caste", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='casteDelete'")%>

        </td>
    </tr>
<% } %>

</table>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>
