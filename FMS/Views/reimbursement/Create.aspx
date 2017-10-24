<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.reimbursement>" %>

    <p class="moduleTitle">reimbursement</p>
    <% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };
    
       using (Ajax.BeginForm(options))
       { %>
        <%: Html.ValidationSummary(true) %>
        <fieldset>
            <legend  class="ui-widget-header ui-corner-top">Add reimbursement</legend>
    
    		
            <div class="formFieldDiv">
                <div class="editor-label ui-state-default">
                    <%: Html.LabelFor(model => model.studentid, "HallTicket No *") %>
                </div>
                <div class="editor-field">
                    <input type="text" id="student_htno" name="HTNo" value="" />
                    <%: Html.HiddenFor(model => model.studentid) %>
                    <%: Html.ValidationMessageFor(model => model.studentid)%>
                </div>
            </div>
    		
            <div class="formFieldDiv">
    		<div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.acaYearid, "acayear") %>
            </div>
    		
            <div class="editor-field">
                <%: Html.DropDownList("acaYearid") %>
                <%: Html.ValidationMessageFor(model => model.acaYearid) %>
            </div>
    		</div>
    		
            <div class="formFieldDiv">
    		<div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.epassid) %>
            </div>
    		
            <div class="editor-field">
                <%: Html.EditorFor(model => model.epassid) %>
                <%: Html.ValidationMessageFor(model => model.epassid) %>
            </div>
    		</div>
    		
            <%--<div class="formFieldDiv">
    		<div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.date) %>
            </div>
    		
            <div class="editor-field">
                <%: Html.EditorFor(model => model.date) %>
                <%: Html.ValidationMessageFor(model => model.date) %>
            </div>
    		</div>--%>
    		
            <div class="formFieldDiv">
    		<div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.remarks) %>
            </div>
    		
            <div class="editor-field">
                <%: Html.EditorFor(model => model.remarks) %>
                <%: Html.ValidationMessageFor(model => model.remarks) %>
            </div>
    		</div>
    		
            <div class="formFieldDiv">
    		<div class="editor-label ui-state-default">
                <%: Html.LabelFor(model => model.approved) %>
            </div>
    		
            <div class="editor-field">
                <%: Html.CheckBoxFor(model => model.approved, new { @checked = "checked" })%>
                <%: Html.ValidationMessageFor(model => model.approved) %>
            </div>
    		</div>
            <div class="clearFix"></div>
    		<p>
                <input class="ui-button" type="submit" value="Create" />
    			<%: Html.MyActionLink("Back to List", "reimbursement", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='reimbursementIndex'")%> 
                
            </p>
        </fieldset>
    <% } %>
    
    <script type="text/javascript">
        $(function () {
            commonFunctions();
            
            if ($("#studentid").val() > 0) {
                $.ajax({
                    url: "/student/getHTNo",
                    dataType: "json",
                    data: {
                        studentid: $("#studentid").val()
                    },
                    success: function (data) {
                        $('#student_htno').val(data.HallTicketNo.toString());
                    }
                });
            }
            
            $('#student_htno').focus(function () {
                $("#student_htno").val("");
                $("#studentid").val("");
            });

            $("#student_htno").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "/student/HTNoAutoCompleteWithId_Nodeptsem",
                        dataType: "json",
                        data: {
                            term: request.term,
                            max: 12
                        },
                        success: function (data) {
                            response(data);
                        }
                    });
                },
                minLength: 3,
                focus: function (event, ui) {
                    $(this).val(ui.item.label);
                },
                select: function (event, ui) {
                    $('#studentid').val(ui.item.id);
                }
            });

        });
       </script>