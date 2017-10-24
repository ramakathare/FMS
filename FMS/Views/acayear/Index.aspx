<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.acayear>>" %>

    <p class="moduleTitle">Academic Year</p>
    <p>
    <%: Html.MyActionLink("Create New", "acayear", "Create", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='acayearCreate'")%> 
        
    </p>
    <table>
        <tr>
            <th>
                year
            </th>
            <th></th>
        </tr>
    
    <% foreach (var item in Model) { %>
        <tr>
            <td>
                <%: Html.DisplayFor(modelItem => item.year) %>
            </td>
            <td>
                <%: Html.MyActionLink("Edit", "acayear", "Edit", new { id = item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='acayearEdit'")%>
    			<%: Html.MyActionLink("Details", "acayear", "Details", new { id = item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='acayearDetails'")%>
    			<%: Html.MyActionLink("Delete", "acayear", "Delete", new { id = item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='acayearDelete'")%>
    			
            </td>
        </tr>
    <% } %>
    
    </table>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>
