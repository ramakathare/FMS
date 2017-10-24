<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.user>>" %>
    <p class="moduleTitle">user</p>
    <p>
    <%: Html.MyActionLink("Create New", "user", "Create",null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='userCreate'")%> 
    </p>
    <table>
        <tr>
            <th>
                name
            </th>
            <th>
                username
            </th>
            <th>
                password
            </th>
            <th>
                role
            </th>
            <th></th>
        </tr>
    
    <% foreach (var item in Model) { %>
        <tr>
            <td>
                <%: Html.DisplayFor(modelItem => item.name) %>
            </td>
             <td>
                <%: Html.decryptedDisplayFor(modelItem => item.username) %>
            </td>
            <td>
                <%: Html.decryptedDisplayFor(modelItem => item.password)%>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.role.roleName) %>
            </td>
           
            <td>
                <%: Html.MyActionLink("Edit", "user", "Edit",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='userEdit'")%>
    			<%: Html.MyActionLink("Delete", "user", "Delete",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='userDelete'")%>
    			
            </td>
        </tr>
    <% } %>
    
    </table>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>