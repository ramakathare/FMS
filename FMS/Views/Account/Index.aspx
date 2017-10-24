<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    BOMMA-FMS
</asp:Content>
<asp:Content ID="welcomeUser" ContentPlaceHolderID="welcomeUser" runat="server">
  <% Html.RenderPartial("LogOnUserControl"); %>
   
</asp:Content>

<asp:Content ID="navigationContent" ContentPlaceHolderID="NavigationContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            $(".loginDiv").addClass('hideDiv');
            $("#dynamicMenu .rootMenu").each(function () {
                $(this).hover(
                        function () {
                            $(this).addClass('ui-state-hover');
                        },
                        function () {
                            $(this).removeClass('ui-state-hover');
                        }
                    )
            });
            s = '<%:TempData["returnUrl"]%>';
            if (s != '') {
                if (s.indexOf("/Account") < 0) {
                    $('#mainContentPlaceHolder').load(s);
                }
            }
        });

        
        

    </script>
    <ul id="dynamicMenu">
        <li><%: Html.MyActionLink("Make Payment", "payfee", "create",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
        <li><%: Html.MyActionLink("Master", "Master", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
	    <li><%: Html.MyActionLink("Students", "student", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
	    <li><%: Html.MyActionLink("Payments", "payfee", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("Set Fees", "setfee", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("Concesions", "concession", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
	    <li><%: Html.MyActionLink("Roles", "role", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("Role Modules(RM)", "roleModule", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("RM Permissions", "roleModulePermission", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("RM Actions", "roleModuleAction", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		<li><%: Html.MyActionLink("RM Action Permissions", "roleModuleActionPermission", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
        <li><%: Html.MyActionLink("Dues", "due", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
        <li><%: Html.MyActionLink("Users", "user", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
        <li><%: Html.MyActionLink("Reimbursement Applications", "reimbursement", "Index",null, "ajaxLoad", "mainContentPlaceHolder", "class='rootMenu'")%> </li>
		
    </ul>
    
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
    </h2>
    <p>
       <%:ViewBag.message%>
    </p>
    
</asp:Content>
