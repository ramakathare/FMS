<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.cheque>>" %>
<p class="moduleTitle">Cheque</p>
    <p>
    <%: Html.MyActionLink("Create New", "cheque", "Create",null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='chequeCreate'")%> 
        
    </p>
    <table>
        <tr>
            <th>
                payfee
            </th>
            <th>
                bankName
            </th>
            <th>
                bankAddress
            </th>
            <th>
                chequenumber
            </th>
            <th>
                dated
            </th>
            <th>
                status
            </th>
            <th></th>
        </tr>
    
    <% foreach (var item in Model) { %>
        <tr>
            <td>
                <%: Html.DisplayFor(modelItem => item.payfee.id) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.bankName) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.bankAddress) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.chequenumber) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.dated) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.status) %>
            </td>
            <td>
                <%: Html.MyActionLink("Edit", "cheque", "Edit",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='chequeEdit'")%>
    			<%: Html.MyActionLink("Details", "cheque", "Details",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='chequeDetails'")%>
    			<%: Html.MyActionLink("Delete", "cheque", "Delete",new { id=item.id }, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='chequeDelete'")%>
    			
            </td>
        </tr>
    <% } %>
    
    </table>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>