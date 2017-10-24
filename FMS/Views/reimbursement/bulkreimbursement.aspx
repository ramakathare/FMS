<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
    <p class="moduleTitle">Add Reimbursemant Applicants in Bulk</p>
</div> 
     <fieldset>
            <legend class="ui-widget-header ui-corner-top">Ad Bulk Reimbursement Applicants as..</legend>
            <div id="filterbulkReimbursement" class="padding1px">
                
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Academic Year</div>
                    <div class="editor-field"><%: Html.DropDownList("acayearid")%></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Approved</div>
                    <div class="editor-field">
                        <span>Yes </span><input type="radio" class="defaultRadioButton" name="approved" checked="checked" value="true" onchange="reloadGrid('bulkReimbursement')" />
                        <span>No </span><input type="radio" name="approved" value="false" onchange="reloadGrid('bulkReimbursement')" />
                    </div>
                </div>
                <div class="clearFix"></div>
                <div class="editor-label floatLeft ui-state-default">Hallticket,epassid</div>
                <div class="editor-field floatLeft"><textarea style="width: 500px; height: 127px;" id="inputHTNoTextArea" name="HTNo" value="" onchange="reloadGrid('bulkReimbursement')"/></div>
             </div>
            <div class="clearFix"></div>
            <%: Html.MyActionLink("Go to List", "reimbursement", "Index", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='bulkReimbursementsIndex'")%>
            <input type="button" class="ui-button" onclick="reloadGrid('bulkReimbursement')" value="Reload" />
     </fieldset>
     
    <div id="gridHallTicketNotFound"></div>
    <div id="gridNoFeeExemption"></div>
    <div id="gridError"></div>
    <div id="bulkReimbursementGridContainer" style="position: relative">
            <table id="bulkReimbursement" class="scroll" cellpadding="0" cellspacing="0">
            </table>
            <div id="pagebulkReimbursement" class="scroll" style="text-align: center;">
            </div>
        </div>
   
    <script type="text/javascript">

        var contextName = "bulkReimbursement"
        var gridDataUrl = '/reimbursement/bulkReimbursementToGrid';
        var lastSel = 0;
        var nextSel = 0;

        jQuery("#" + contextName).jqGrid({
            url: gridDataUrl,
            postData:
            {
                acayearid: function () { return $("#acayearid").val(); },
                HTNos: function () { return $("#inputHTNoTextArea").val(); },
                Approved: function () { return $('[name=approved]:checked').val(); }
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
            colNames: ['Exists','existingid','studentid', 'acayearid', 'HTNo', 'Name', 'Semester', 'Batch', 'Caste', 'Application id', 'Academic Year', 'approved', 'remarks'],
            colModel: [
                        { name: 'exists', index: 'exists', formatter: 'checkbox', width: 40 },
                        { name: 'existingid', index: 'existingid',hidden:true },
                        { name: 'studentid', index: 'studentid', hidden: true },
                        { name: 'acayearid', index: 'acayearid', hidden: true },
                        { name: 'HTNo', index: 'HTNo', width: 100 },
                        { name: 'Name', index: 'Name' },
                        { name: 'Semester', index: 'Semester' },
                        { name: 'Batch', index: 'Batch', width: 50 },
                        { name: 'Caste', index: 'Caste' },
                        { name: 'epassid', index: 'epassid', editable: true },
                        { name: 'AcaYear', index: 'AcaYear' },
                        { name: 'approved', index: 'approved', editable: true, edittype: 'checkbox', editoptions: { value: "true:false" }, formatter: 'checkbox' },
                        { name: 'remarks', index: 'remarks', editable: true}],
            rowNum: 10,
            rowList: [10, 30, 50, 80, 150, 300, 500, 1000, 10000],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page' + contextName),
            sortname: 'HTNo',
            viewrecords: true,
            sortorder: "asc",
            caption: "Reimbursements List",
            rownumbers: true,
            loadComplete: function (data) {
                $("option[value=10000]").text('All');
                $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1);
                $(window).trigger('resize');

                $('#gridHallTicketNotFound').text("");
                $('#gridNoFeeExemption').text("");
                $('#gridError').text("");

                if (data.HallTicketNotFound != "")
                    $('#gridHallTicketNotFound').text("Students not found : " + data.HallTicketNotFound);
                if (data.NoFeeExemption != "")
                    $('#gridNoFeeExemption').text("Students without feeExemption : " + data.NoFeeExemption);
                if (data.error != "")
                    $('#gridError').text(data.error);
            },
            onSelectRow: function (id) {
                if (id && id !== lastSel) {
                    jQuery('#' + contextName).restoreRow(lastSel);
                    lastSel = id;
                }
                var rowData = jQuery('#' + contextName).jqGrid('getRowData', id);
                jQuery('#' + contextName).
                        editRow(
                                id,
                                true,
                                function (id) { $('#' + id + ' input.editable:first').select(); },
                                null,
                                "/reimbursement/gridAddOrUpdate",
                                {
                                    id: rowData.existingid,
                                    studentid: rowData.studentid,
                                    acayearid: rowData.acayearid,
                                },
                                function (id, response) { afterSuccess(id, response); },
                                function (id, response) { inlineEditResponseFail(id, response); });
            }
            

        });
        jQuery("#" + contextName).jqGrid('navGrid', '#page' + contextName, { edit: false, add: false, del: false, search: false });
        
        $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);

        $(window).bind('resize',function(){
            $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);
            $("#gbox_"+contextName+" .ui-jqgrid-bdiv").width($('#gbox_'+contextName).width()+1);
        });

        function inlineEditResponseFail(id, response) {
            errorDialog('dialog', 'Input seems to be invalid. Enter correct input : Record not saved to server');
        }
        function afterSuccess(id, response) {
            var json = response.responseText;
            var result = eval("(" + json + ")");
            if (result.success) {
                $('#' + contextName + ' #' + id).addClass('not-editable-row');
                $('#' + contextName + ' #' + id).next().trigger('click');
            } else {
                errorDialog('dialog', result.message.toString() + " : Record not saved to server");
            }

            //        $('#'+contextName+' #'+id).addClass('not-editable-row');
            //        id = parseInt(id) + 1;
            //        $('#'+contextName+' #'+id).trigger('click');
        }

        $(function () {
            commonFunctions();
            
        });

    
   </script>