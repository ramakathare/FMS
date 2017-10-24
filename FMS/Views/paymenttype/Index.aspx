<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.paymenttype>>" %>
<p class="moduleTitle">Payment Type</p>
    <p>
    <%: Html.MyActionLink("Create New", "paymenttype", "Create",null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='paymenttypeCreate'")%> 
        
    </p>
    <table>
        <tr>
            <th>
                type
            </th>
            <th></th>
        </tr>
    
    <% foreach (var item in Model) { %>
        <tr>
            <td>
                <%: Html.DisplayFor(modelItem => item.type) %>
            </td>
            <td>
                <%: Html.MyActionLink("Edit", "paymenttype", "Edit",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='paymenttypeEdit'")%>
    			<%: Html.MyActionLink("Details", "paymenttype", "Details",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='paymenttypeDetails'")%>
    			<%: Html.MyActionLink("Delete", "paymenttype", "Delete",new { id=item.id }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='paymenttypeDelete'")%>
    			
            </td>
        </tr>
    <% } %>
    
    </table>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>
