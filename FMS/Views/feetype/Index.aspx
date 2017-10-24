<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.feetype>>" %>
<p class="moduleTitle">Fee Type</p>
    <p>
    <%: Html.MyActionLink("Create New", "feetype", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='feetypeCreate'")%> 
        
    </p>
    <table>
        <tr>
            <th>
                type
            </th>
            <th>
                Installments Allowed
            </th>
            <th></th>
        </tr>
    
    <% foreach (var item in Model) { %>
        <tr>
            <td>
                <%: Html.DisplayFor(modelItem => item.type) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.allowedInstallments) %>
            </td>
            <td>
                <%: Html.MyActionLink("Edit", "feetype", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='feetypeEdit'")%>
    			<%: Html.MyActionLink("Details", "feetype", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='feetypeDetails'")%>
    			<%: Html.MyActionLink("Delete", "feetype", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='feetypeDelete'")%>
    			
            </td>
        </tr>
    <% } %>
    
    </table>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>