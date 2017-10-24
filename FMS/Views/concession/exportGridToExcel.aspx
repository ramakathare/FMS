<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.concession>>" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
</head>
<body>
    <table border="1">
        <tr>
            <td colspan="11">
                Concessions list Generated on
                <%:DateTime.Now.ToLongDateString() + " " + DateTime.Now.ToLongTimeString()%>
            </td>
        </tr>
    </table>
    <table border="1">
        <tr>
            <th>
                No
            </th>
            <th>
                HTNo
            </th>
            <th>
                Name
            </th>
            <th>
                Semester
            </th>
            <th>
                Batch
            </th>
            <th>
                Quota
            </th>
            <%--<th>
                Caste
            </th>--%>
            <th>
                Academic Year
            </th>
            <th>
                Fee Type
            </th>
            <th>
                Amount
            </th>
            <th>
                Time
            </th>
            <th>
                Remarks
            </th>
        </tr>
        <%  int i = 0;
            long amount = 0;
            foreach (var item in Model)
           {
               amount += item.amount;
                %>
        <tr>
            <td>
                <%:++i%>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.student.htno) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.student.name) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.student.sem.name) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.student.batch.name) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.student.quota.name) %>
            </td>
           <%-- <td>
                <%: Html.DisplayFor(modelItem => item.student.caste.name) %>
            </td>--%>
            <td>
                <%: Html.DisplayFor(modelItem => item.acayear.year) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.feetype.type) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.amount) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.time) %>
            </td>
            <td>
                <%: Html.DisplayFor(modelItem => item.remarks) %>
            </td>
        </tr>
        <% } %>
        <tr><td colspan="8" align="right">Total</td><td align="right"><%:amount %></td></tr>
    </table>
</body>
</html>
