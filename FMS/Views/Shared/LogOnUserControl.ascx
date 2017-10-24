<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%
    
    if (Request.IsAuthenticated) {
%>
        <span class="floatLeft">Welcome <strong><%:Page.User.Identity.Name %></strong>!</span>
        <%: Html.ActionLink("Home", "Index", "Account",new {@class="floatLeft ui-icon ui-icon-home"}) %>
        <%: Html.ActionLink("Log Off", "LogOff", "Account",new {@class="floatLeft ui-icon ui-icon-power"}) %>
        <%: Html.MyActionLink("Change Password", "Account", "ChangePassword", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-wrench floatLeft' id='accountChangePassword'")%> 
<%
    }
    else {
%> 
        [ <%: Html.ActionLink("Log On", "LogOn", "Account") %> ]
<%
    }
%>

