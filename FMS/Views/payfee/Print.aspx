<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.payfee>" %>

<html>
<head>
    <title>Hello</title>
    <style type="text/css">
        body
        {
             color:#2c2c2c;
        }
        .mainPara
        {
            text-indent: 20px;
            line-height: 35px;
        }
        b
        {
            font-style: italic;
            color:Black;
            font-family: Arial,Helvetica,sans-serif;
        }
        
        .receipt
        {
           
            font-weight: bold;
            text-decoration: underline;
            font-family: Trebuchet MS;
            text-align: center;
            font-size:1.4em;
        }
        table
        {
            width: 100%;
        }
        .printTaken
        {
            font-size:0.7em;
        }
        .insidePara
        {
            font-size:1em;
        }
    </style>
</head>
<body>
    <table class="receipt">
        <tr height="30px">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                RECEIPT
            </td>
        </tr>
    </table>
    <table class="dateReceipt">
        <tr height="40px">
            <td colspan="3">
            </td>
        </tr>
        <tr>
            <td align="left">
                Date :
                <b><%:Model.time.ToLongDateString()%></b>
            </td>
            <td></td>
            <td align="right">
                Receipt No : <b>
                <%: Html.DisplayFor(model => model.recieptNo)%></b>
            </td>
        </tr>
    </table>
    <table>
        <tr height="40px">
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <p class="mainPara">
                    Receieved with thanks from <b class="insidePara">
                        <%: Html.DisplayFor(model => model.student.name) %></b> bearing Hall-Ticket
                    Number <b class="insidePara">
                        <%: Html.DisplayFor(model => model.student.htno) %></b> of <b class="insidePara">
                            <%: Html.DisplayFor(model => model.student.sem.desc) %></b>, sum of Rs.
                    <b class="insidePara">
                        <%: Html.DisplayFor(model => model.amount) %>
                        /-</b> towards <b class="insidePara">
                            <%: Html.DisplayFor(model => model.feetype.type) %></b> for the Academic
                    Year <b class="insidePara">
                        <%: Html.DisplayFor(model => model.acayear.year) %></b> vide <b class="insidePara">
                            <%: Html.DisplayFor(model => model.paymenttype.type) %></b>
                </p>
            </td>
        </tr>
    </table>
    <table>
        <tr height="50px">
            <td>
            </td>
        </tr>
        <tr>
            <td align="right">
                Authorised Signature
            </td>
        </tr>
    </table>

     <table>
        <tr>
            <td align="left" class="printTaken">
               (<%:changeNumberToString(Model.amount)%>)
            </td>
        </tr>
    </table>

    <table>
        <tr>
            <td align="left" class="printTaken">
                Receipt generated on 
                <%:DateTime.Now.ToLongDateString() +" "+DateTime.Now.ToLongTimeString()%>
            </td>
        </tr>
    </table>
   
</body>
<script runat="server">
    public string changeNumberToString(long d)
    {
        NumberToEnglish n2e = new NumberToEnglish();
        return n2e.changeCurrencyToWords((double)d);
    }
</script>
</html>
