<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.role>>" %>
<p class="moduleTitle">Roles</p>
<p>
<%: Html.MyActionLink("Create New", "role", "Create",null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='roleCreate'")%> 
    
</p>
<table>
    <tr>
        <th>
            roleName
        </th>
        <th></th>
    </tr>

<% foreach (var item in Model) { %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.roleName) %>
        </td>
        <td>
            <%: Html.MyActionLink("Edit", "role", "Edit",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='roleEdit'")%>
			<%: Html.MyActionLink("Details", "role", "Details",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='roleDetails'")%>
			<%: Html.MyActionLink("Delete", "role", "Delete",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='roleDelete'")%>
			
        </td>
    </tr>
<% } %>

</table>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>
