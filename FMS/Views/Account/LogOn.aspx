<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<FMS.Models.LogOnModel>" %>
<asp:Content ID="loginContent" ContentPlaceHolderID="loginContent" runat="server">
   
    <p>
      <!--  Please enter your user name and password. <%: Html.ActionLink("Register", "Register") %> if you don't have an account. -->
    </p>

    

    <% using (Html.BeginForm()) { %>
        <%: Html.ValidationSummary(true, "Login was unsuccessful. Please correct the errors and try again.") %>
        <div>
            <fieldset>
                <legend>Pleas Login</legend>

                <div class="Login-editor-label editor-label">
                    <%: Html.LabelFor(m => m.UserName) %>
                </div>
                <div class="editor-field">
                    <%: Html.TextBoxFor(m => m.UserName) %>
                    <%: Html.ValidationMessageFor(m => m.UserName) %>
                </div>
                
                <div class="Login-editor-label editor-label">
                    <%: Html.LabelFor(m => m.Password) %>
                </div>
                <div class="editor-field">
                    <%: Html.PasswordFor(m => m.Password) %>
                    <%: Html.ValidationMessageFor(m => m.Password) %>
                </div>
               
                <br />
                <p>
                    <input type="submit" class="ui-button" value="Log On" />
                </p>
            </fieldset>
        </div>
    <% } %>
    <script>
        $(document).ready(function () {
            $("#bd").html("");
            $("#bd").addClass('hideDiv');
        });
</script>
</asp:Content>


