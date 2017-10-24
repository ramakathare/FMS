<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.concession>" %>

<p class="moduleTitle">
   Concessions</p>
<% AjaxOptions options = new AjaxOptions
       {
           HttpMethod = "Post",
           UpdateTargetId = "mainContentPlaceHolder"
       };

   using (Ajax.BeginForm(options))
   { %>
<%: Html.ValidationSummary(true) %>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Allot Concession</legend>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Department</div>
        <div class="editor-field">
            <input type="text" id="inputDept" name="Dept" value="" onchange="$('#inputSem').val('');" /></div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Semester</div>
        <div class="editor-field">
            <input type="text" id="inputSem" name="Sem" value="" onchange="$('#student_htno').val('');"/></div>
    </div>
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
            <%: Html.DropDownList("acaYearid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.acaYearid) %>
        </div>
    </div>
     <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.feeTypeid, "feetype") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("feeTypeid", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.feeTypeid) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.amount) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.amount) %>
            <%: Html.ValidationMessageFor(model => model.amount) %>
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            <%: Html.LabelFor(model => model.remarks) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.remarks) %>
            <%: Html.ValidationMessageFor(model => model.remarks) %>
        </div>
    </div>
    
    <div class="clearFix">
    </div>
    <p>
        <input class="ui-button" type="submit" value="Create" />
        <%: Html.MyActionLink("Back to List", "concession", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='concessionIndex'")%>
        
    </p>
</fieldset>
<% } %>

<div id="detailsconcessioncreate" class="clearFix">

    <div class="ui-jqgrid-titlebar ui-widget-header ui-corner-top ui-helper-clearfix myGridTitle">
        <span id="myGridTitleContent" class="ui-jqgrid-title">Fee Details</span>
    </div>
    <table id="concessionsubgrid" class="myGridTable width100" cellpadding="2" cellspacing="0">
    <thead class="ui-state-default ui-jqgrid-hdiv">
        <th class="ui-state-default ui-th-column ui-th-ltr">Academic Year</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Fee type</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Amount Set</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Concession</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Fee Paid</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Due</th>
        <th class="ui-state-default ui-th-column ui-th-ltr">Installments Left</th>
    </thead>
    <tbody id="concessionssubgridBody"></tbody>
    </table>
</div>


<script type="text/javascript">
    $(function () {
        commonFunctions();
        $('#student_htno').change(function () {
            loadFeeDetailsSubGrid();
        });

        if ($("#studentid").val() > 0) {
            $.ajax({
                url: "/student/getHTNo",
                dataType: "json",
                data: {
                    studentid: $("#studentid").val()
                },
                success: function (data) {
                    $('#student_htno').val(data.HallTicketNo.toString());
                    loadFeeDetailsSubGrid();
                }
            });
        }

        $('#student_htno').focus(function () {
            $("#student_htno").val("");
            $("#studentid").val("");
            $("#concessionssubgridBody").html("");
        });

        $("#inputDept").autocomplete({
            source: "/dept/deptAutoComplete",
            focus: function (event, ui) { $(this).val(ui.item.label); }
        });
        $("#inputSem").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "/sem/semAutoComplete",
                    dataType: "json",
                    data: {
                        term: request.term,
                        Dept: $("#inputDept").val()
                    },
                    success: function (data) {
                        response(data);
                    }
                });
            },
            focus: function (event, ui) { $(this).val(ui.item.label); }
        });

        $("#student_htno").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "/student/HTNoAutoCompleteWithId",
                    dataType: "json",
                    data: {
                        term: request.term,
                        max: 12,
                        Dept: $("#inputDept").val(),
                        Sem: $("#inputSem").val()
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

    function loadFeeDetailsSubGrid() {
        $.ajax({
            url: "/setfee/subgrid",
            dataType: "json",
            data: {
                studentid: $("#studentid").val()
            },
            success: function (data) {
                //                    $('#detailsconcessioncreate').text("hello " + data.rows); 
                var tbl_body = "";
                $.each(data.rows, function () {
                    var tbl_row = "";
                    i = 0;
                    class1 = "";
                    $.each(this, function (k, v) {
                        if (i > 1) style = "style='text-align:right'"; else style = "";
                        if (k.toString().indexOf("Due") >= 0 && v <= 0) { class1 = "ui-state-highlight"; v = "Cleared (" + v + ")" };
                        tbl_row += "<td " + style + ">" + v + "</td>";
                        i++;
                    })
                    tbl_body += "<tr class='ui-widget-content jqgrow ui-row-ltr " + class1 + "'>" + tbl_row + "</tr>";
                })
                $("#concessionssubgridBody").html(tbl_body);
                $('#myGridTitleContent').text("Fee Details");
                $('#concessionsubgrid .ui-widget-content').hover(
                        function () {
                            $(this).addClass('ui-state-hover');
                        },
                        function () {
                            $(this).removeClass('ui-state-hover');
                        });

                $('#myGridTitleContent').text("Fee Details for : " + data.studentName);
            }
        });
    }

    

</script>