<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    BOMMA-FMS
</asp:Content>
<asp:Content ID="welcomeUser" ContentPlaceHolderID="welcomeUser" runat="server">
   <h2 style="color:White"> Welcome <%: ViewData["Message"]%> </h2>  <% //Html.RenderPartial("LogOnUserControl"); %>
</asp:Content>
<asp:Content ID="navigationContent" ContentPlaceHolderID="NavigationContent" runat="server">
    <script>
        $(document).ready(function () {
            $(".loginDiv").addClass('hideDiv');
           
        });

    </script>
    <ul class="menu">
        
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/Account/index')">Home</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/sem/index')">Semesters</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/acaYear/index')">Aca Year</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/role/index')">Role</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/roleModule/index')">Role Module</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/roleModuleAction/index')">Role Module Action</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/roleModulePermission/index')">Role Module Permission</li>
        <li class="topMenuItem" onclick="$('#mainContentPlaceHolder').load('/roleModuleActionPermission/index')">Role Module Action Permission</li>
        <li class="topMenuItem">Quota</li>
        <li class="topMenuItem">Caste</li>
        <li class="topMenuItem">Batch</li>
        <li class="topMenuItem">Dept</li>
        <li class="topMenuItem">Student</li>
    </ul>
</asp:Content>
<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
    </h2>
    <p>
        You are in index
    </p>
    
</asp:Content>
