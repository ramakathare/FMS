<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.student>" %>
<p class="moduleTitle">Students</p>
    
    <fieldset>
        <legend class="ui-widget-header ui-corner-top">Delete Student</legend>

        <h3 class="question">Are you sure you want to delete this?</h3>
    
        <div class="display-label ui-state-default">htno</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.htno) %>
        </div>
    
        <div class="display-label ui-state-default">name</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.name) %>
        </div>
    
        <div class="display-label ui-state-default">fname</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.fname) %>
        </div>
    
        <div class="display-label ui-state-default">caste</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.caste.name) %>
        </div>
    
        <div class="display-label ui-state-default">quota</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.quota.name) %>
        </div>
    
        <div class="display-label ui-state-default">batch</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.batch.name) %>
        </div>
    
        <div class="display-label ui-state-default">dept</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.dept.name) %>
        </div>
    
        <div class="display-label ui-state-default">sem</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.sem.name) %>
        </div>
    
        <div class="display-label ui-state-default">Fee Exemption</div>
        <div class="display-field">
            <%: Html.DisplayFor(model => model.feeExemption) %>
        </div>
    
       
    
<% AjaxOptions options = new AjaxOptions
   {
       HttpMethod = "Post",
       UpdateTargetId = "mainContentPlaceHolder"
   };

   using (Ajax.BeginForm(options))
   { %>
        <p>
            <input class="ui-button" type="submit" value="Delete" />
            <%: Html.MyActionLink("Back to List", "student", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='studentIndex'")%> 
        </p>
    <% } %>
</fieldset>   
    <script type="text/javascript">
    $(function () {
        commonFunctions();
    });
   </script>
