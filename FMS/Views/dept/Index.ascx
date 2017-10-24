<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.dept>>" %>
<p class="moduleTitle">Department</p>
<p>
<%: Html.MyActionLink("Create New", "dept", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='deptCreate'")%> 
    
</p>
<table>
    <tr>
        <th>
            Department Name
        </th>
        <th>
            College
        </th>
        <th>
            Duration
        </th>
        <th>
            Desc
        </th>
        <th></th>
    </tr>

<% foreach (var item in Model) { %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.name) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.college.collegeName) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.duration) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.desc) %>
        </td>
        
        <td>
            <%: Html.MyActionLink("Edit", "dept", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='deptEdit'")%>
			<%: Html.MyActionLink("Details", "dept", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='deptDetails'")%>
			<%: Html.MyActionLink("Delete", "dept", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='deptDelete'")%>
			
        </td>
    </tr>
<% } %>

</table>
<script type="text/javascript">
        $(function () {
            commonFunctions();
        });
   </script>
