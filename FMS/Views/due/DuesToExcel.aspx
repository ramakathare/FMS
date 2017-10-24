<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.payfee>" %>

<p class="moduleTitle">
    Fee Payments</p>
    <div class="errorDiv" id="errorContent">
</div>
<form id="formDuesToExcel" action="">
<div class="filterDuesToExcel">
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Export Dues Sem Wise</legend>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Department</div>
        <div class="editor-field">
            <input type="text" id="inputDept" name="Dept" value="" onchange="$('#inputSem').val('');" /></div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Semester *</div>
        <div class="editor-field">
            <input type="text" id="inputSem" name="Sem" value=""/>
            <input type="hidden" id="semid" name="semid" value="" />
        </div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Quota</div>
        <div class="editor-field">
            <input type="text" id="inputQuota" name="Quota" value=""/></div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Caste</div>
        <div class="editor-field">
            <input type="text" id="inputCaste" name="Caste" value=""/></div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Aca Year</div>
        <div class="editor-field">
            <%: Html.DropDownList("acayearid", null, null,null)%></div>
    </div>
    <div class="formFieldDiv">
        <div class="editor-label ui-state-default">
            Fee Exemption</div>
        <div class="editor-field">
            <span>Yes </span><input type="radio" name="feeExemption" value="true" onchange="reloadGrid('due')" />
            <span>No </span><input type="radio" name="feeExemption" value="false" onchange="reloadGrid('due')" />
            <span>All </span><input type="radio" class="defaultRadioButton" name="feeExemption" checked="checked" value="" onchange="reloadGrid('due')" />
        </div>
    </div>
    <div class="clearFix">
    </div>
    <p>
        
        <input class="ui-button" type="button" onclick="resetForm('formDuesToExcel')" value="Reset" />
        <input class="ui-button" type="button" onclick="validate()" value="Export Dues" />
        <%: Html.MyActionLink("Back to Dues List", "due", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='dueIndex'")%>
    </p>
</fieldset>
</div>
</form>

<script type="text/javascript">
    var contextName = "DuesToExcel";

    function validate() {
        $.ajax({
            url: "/due/ValidateDuesToExcel",
            type: "post",
            dataType: 'json',
            data: $('#form' + contextName).serialize(),
            success: function (json) {
                if (!json.success) {
                    $('#errorContent').html(json.message);
                }
                else {
                    $('#errorContent').html("");
                    $(function () {
                        var myUrl = "/due/exportToExcelSemWise";
                        myUrl += "?Caste=" + encodeURIComponent($("#inputCaste").val());
                        myUrl += "&Quota=" + encodeURIComponent($("#inputQuota").val());
                        myUrl += "&acayearid=" + encodeURIComponent($("#acayearid").val());
                        myUrl += "&semid=" + encodeURIComponent($("#semid").val());
                        myUrl += "&feeExemption=" + encodeURIComponent($('[name=feeExemption]:checked').val());
                        window.open(myUrl);
                    });
                }
            },
            error: function (xhr, textStatus, errorThrown) {
                $('#errorContent').html("Error: Check parameters");
            }
        });
    }


    $(function () {
        commonFunctions();
        
        $('.formFieldDiv input, .formFieldDiv select').focus(function () { $(this).siblings('.field-validation-error').hide(); });


        $('#inputSem').focus(function () {
            $("#inputSem").val("");
            $("#semid").val("");
        });

        $("#inputDept").autocomplete({
            source: "/dept/deptAutoComplete",
            focus: function (event, ui) { $(this).val(ui.item.label); },
            select: function (event, ui) { $('#inputSem').val(''); }
        });
        $("#inputCaste").autocomplete({
            source: "/caste/casteAutoComplete",
            focus: function (event, ui) { $(this).val(ui.item.label); }
        });
        $("#inputQuota").autocomplete({
            source: "/quota/quotaAutoComplete",
            focus: function (event, ui) { $(this).val(ui.item.label); }
        });

        $("#inputSem").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "/sem/semAutoCompleteWithId",
                    dataType: "json",
                    data: {
                        term: request.term,
                        max: 12,
                        Dept: $("#inputDept").val()
                    },
                    success: function (data) {
                        response(data);
                    }
                });
            },
            focus: function (event, ui) {
                $(this).val(ui.item.label);
            },
            select: function (event, ui) {
                $('#semid').val(ui.item.id);
                $('#inputDept').val("");
            }
        });
    });
</script>