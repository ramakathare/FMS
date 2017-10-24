<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FMS.Data.setfee>" %>
<script src="<%: Url.Content("~/Content/chosen/chosen.jquery.min.js") %>" type="text/javascript"></script>
<link href="../../Content/chosen/chosen.css" rel="stylesheet" type="text/css" />
<p class="moduleTitle">
    Bulk Set Fee</p>
<div class="errorDiv" id="errorContent">
</div>
</div>
<form id="formbulksetfee" action="">
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Search students to Set the Fee</legend>
    <div id="filterbulksetfee" class="padding1px">
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Department</div>
            <div class="editor-field">
                <input type="text" id="inputDept" name="Dept" value="" onchange="submitFilterbulksetfee()" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Semester</div>
            <div class="editor-field">
                <input type="text" id="inputSem" name="Sem" value="" onchange="submitFilterbulksetfee()" /></div>
        </div>
       
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Academic Year</div>
            <div class="editor-field">
                <%: Html.DropDownList("acayearid", null, "Select Aca Year", new { onchange = "submitFilterbulksetfee()" })%>
            </div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Fee Type</div>
            <div class="editor-field">
                <%: Html.DropDownList("feetypeid",null, "Select Aca Year", new { onchange = "submitFilterbulksetfee()" })%>
            </div>
        </div>
         <div class="formFieldDiv">
            <div class="editor-label ui-state-default">Quota</div>
            <%--<div class="editor-field"><input type="text" id="inputQuota" name="Quota" value="" onchange="reloadGrid('payfee')"/></div>--%>
            <div class="editor-field"><%: Html.DropDownList("quotaid", null, new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "submitFilterbulksetfee()" })%></div>
        </div> 
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Fee Exemption</div>
            <div class="editor-field">
                <span>Yes </span>
                <input type="radio" name="feeExemption" value="true" onchange="submitFilterbulksetfee()" />
                <span>No </span>
                <input type="radio" name="feeExemption" value="false" onchange="submitFilterbulksetfee()" />
                <span>All </span>
                <input type="radio" name="feeExemption" checked="checked" value="" onchange="submitFilterbulksetfee()" />
            </div>
        </div>
    </div>
    <div class="clearFix" />
    <input type="button" class="ui-button" onclick=" $('#errorContent').html(''); resetForm('filterbulksetfee');submitFilterbulksetfee();"
        value="Reset" />
    <%: Html.MyActionLink("Go to List", "setfee", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='bulksetfeeIndex'")%>
    <input type="button" class="ui-button" onclick="submitFilterbulksetfee();" value="Reload" />
    <%--<span id="loadingSpan" class="smallLoadingSpan hideDiv"></span>--%>
</fieldset>
</form>
<table id="bulksetfee" class="scroll" cellpadding="0" cellspacing="0">
</table>
<div id="pagebulksetfee" class="scroll" style="text-align: center;">
</div>
<script type="text/javascript">
    var contextName = 'bulksetfee';
    function submitFilterbulksetfee() {
      //  if($("#loadingSpan").hasClass('hideDiv')) $('#loadingSpan').removeClass('hideDiv');
        $.ajax({
            url: "/setfee/ValidateBulkSetFeeGrid",
            type: "post",
            dataType: 'json',
            data: $('#form' + contextName).serialize(),
            success: function (json) {
                if (!json.success) {
                    $('#errorContent').html(json.message);
                    // $("#loadingSpan").addClass('hideDiv');
                }
                else {
                    reloadGrid(contextName);
                    $('#errorContent').html("");
                }

            },
            error: function (xhr, textStatus, errorThrown) {
                $('#errorContent').html("Error: Check parameters");
                //$("#loadingSpan").addClass('hideDiv');
            }
        });

    }

    $(function () {
        commonFunctions();
        commonFunctionForChosen();

        $("#inputDept").autocomplete({
            source: "/dept/deptAutoComplete",
            focus:function(event,ui){$(this).val(ui.item.label);}
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
            focus:function(event,ui){$(this).val(ui.item.label);}
            //select: function (event, ui) {$(this).blur(); $(this).trigger("onchange"); }
        });
    });

    var lastSel = 0;
    var nextSel = 0;

    jQuery("#" + contextName).jqGrid({
        url: "/setfee/bulkSetFeeGrid",
        postData: //$('#form' + contextName).serialize(),
                {
                acayearid: function () { return $("#acayearid").val(); },
                feetypeid: function () { return $("#feetypeid").val(); },
                Quota: function () { return $("#quotaid").val(); },
                Dept: function () { return $("#inputDept").val(); },
                Sem: function () { return $("#inputSem").val(); },
                feeExemption : function(){ return $('[name=feeExemption]:checked').val();}
            },
        datatype: "json",
        mtype: 'Get',
        jsonReader: {
            root: "rows",
            page: "page",
            total: "total",
            records: "records",
            repeatitems: false,
            cell: "",
            userdata: "userdata"
        },
        colNames: [ 'setfeeid', 
                    'Student Id', 
                    'Aca year id', 
                    'Fee type id', 
                    'HTNo', 
                    'Name', 
                    'Academic Year', 
                    'Fee Type', 
                    'Amount', 
                    'Semester', 
                    'Quota','Fee Exemption'],
        colModel: [
                            { name: 'setfeeid', index: 'setfeeid', hidden: true },
                            { name: 'studentid', index: 'studentid', hidden: true },
                            { name: 'acayearid', index: 'acayearid', hidden: true },
                            { name: 'feetypeid', index: 'feetypeid', hidden: true },
                            { name: 'HTNo', index: 'HTNo', width: 50 },
                            { name: 'Name', index: 'Name', width: 125 },
                            { name: 'AcaYear', index: 'AcaYear', width: 50 },
                            { name: 'FeeType', index: 'FeeType', width: 50 },
                            { name: 'Amount', index: 'Amount', width: 75, align:'right',editable: true, sortable:false},//, formatter:'currency', formatoptions: {prefix:'', suffix:'', thousandsSeparator:',', decimalPlaces:0, defaultValue:' '}},
                            { name: 'sem', index: 'sem' },
                            { name: 'quota', index: 'quota' },
                            { name: 'FeeExemption', index:'FeeExemption',formatter: 'checkbox'}],


        rowNum: 10,
        rowList: [10, 30, 60, 100, 150, 200, 300, 500],
        height: 'auto',
        width: 'auto',
        sortname: 'HTNo',
        viewrecords: true,
        sortorder: "asc",
        caption: "Bulk Set Fee",
        rownumbers: true,
        pager: jQuery('#page' + contextName),
        loadComplete: function () {
            $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1);
            $(window).trigger('resize');
           // $("#loadingSpan").addClass('hideDiv');
        },
        onSelectRow: function (id) {
            if (id && id !== lastSel) {
                jQuery('#' + contextName).restoreRow(lastSel);
                lastSel = id;
            }
           var rowData = jQuery('#'+contextName).jqGrid('getRowData',id);
           jQuery('#' + contextName)
                    .editRow(
                            id, 
                            true, 
                            function(id){
                                $('#'+id+' input.editable:first').select();
                            },
                            null, 
                            "/setfee/gridAddOrUpdate", 
                            {   id: rowData.setfeeid, 
                                studentid: rowData.studentid, 
                                acaYearid: rowData.acayearid, 
                                feeTypeid: rowData.feetypeid
                            }, 
                            function (id, response) { afterSuccess(id,response); }, 
                            function (id, response) { inlineEditResponseFail(id, response); }
                            );
        },
        
    });
    jQuery("#" + contextName).jqGrid('navGrid', '#page' + contextName, { edit: false, add: false, del: false, search: false });
    $("#" + contextName).setGridWidth($('#gbox_' + contextName).parent().width() - 10);

    $(window).bind('resize', function () {
        $("#" + contextName).setGridWidth($('#gbox_' + contextName).parent().width() - 10);
        $("#gbox_" + contextName + " .ui-jqgrid-bdiv").width($('#gbox_' + contextName).width() + 1);
    });
    function inlineEditResponseFail(id, response) {
        errorDialog('dialog', 'Input seems to be invalid. Enter correct input : Record not saved to server');
    }
    function afterSuccess(id,response) {
        var json=response.responseText;
        var result=eval("("+json+")");
        if(result.success){
            $('#'+contextName+' #'+id).addClass('not-editable-row');
            $('#'+contextName+' #'+id).next().trigger('click');
        } else {
            errorDialog('dialog', result.message.toString() + " : Record not saved to server");
        }
        
//        $('#'+contextName+' #'+id).addClass('not-editable-row');
//        id = parseInt(id) + 1;
//        $('#'+contextName+' #'+id).trigger('click');
    }
</script>