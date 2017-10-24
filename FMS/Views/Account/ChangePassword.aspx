<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Models.ChangePasswordModel>" %>

<p class="moduleTitle">
    Change Password</p>
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "mainContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
<%: Html.ValidationSummary(true) %>
<div>
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">Account Information</legend>
        <div class="formFieldDiv">
            <div class="editor-label">
                <%: Html.LabelFor(m => m.OldPassword) %>
            </div>
            <div class="editor-field">
                <%: Html.PasswordFor(m => m.OldPassword) %>
                <%: Html.ValidationMessageFor(m => m.OldPassword) %>
            </div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label">
                <%: Html.LabelFor(m => m.NewPassword) %>
            </div>
            <div class="editor-field">
                <%: Html.PasswordFor(m => m.NewPassword) %>
                <%: Html.ValidationMessageFor(m => m.NewPassword) %>
            </div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label">
                <%: Html.LabelFor(m => m.ConfirmPassword) %>
            </div>
            <div class="editor-field">
                <%: Html.PasswordFor(m => m.ConfirmPassword) %>
                <%: Html.ValidationMessageFor(m => m.ConfirmPassword) %>
            </div>
        </div>
        <div class="clearFix">
        </div>
        <p>
            <input class="ui-button" type="submit" value="Change Password" />
        </p>
    </fieldset>
</div>
<% } %>
<script type="text/javascript">
    $(function () {
        commonFunctions();
    });
</script>
