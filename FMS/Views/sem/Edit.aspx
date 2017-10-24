<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.sem>" %>
<p class="moduleTitle">Semester</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "masterContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend class="ui-widget-header ui-corner-top">Edit sem</legend>
    
            <%: Html.HiddenFor(model => model.id) %>
 <div class="formFieldDiv"> 
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.name) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.name) %>
                <%: Html.ValidationMessageFor(model => model.name) %>
            </div>
   </div>    <div class="formFieldDiv"> 
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.deptid, "dept") %>
            </div>
            <div class="editor-field">
                <%: Html.DropDownList("deptid", String.Empty) %>
                <%: Html.ValidationMessageFor(model => model.deptid) %>
            </div>
    </div>    <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.desc) %>
            </div>
            <div class="editor-field">
                <%: Html.EditorFor(model => model.desc) %>
                <%: Html.ValidationMessageFor(model => model.desc) %>
            </div>
    </div>    <div class="clearFix"></div>
            <p>
                <input class="ui-button" type="submit" value="Save" />
    			<%: Html.MyActionLink("Back to List", "sem", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button' id='semIndex'")%> 
                   
            </p>
        </fieldset>
    <% } %>
    <script type="text/javascript">
            $(function () {
                commonFunctions();
            });
       </script>