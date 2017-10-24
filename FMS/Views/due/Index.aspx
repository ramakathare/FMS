<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<p class="moduleTitle">List of Dues</p>
<div class="errorDiv" id="errorContent"></div>
<div class="commonActions">
    <%: Html.MyActionLink("Export Dues Sem Wise", "Due", "DuesToExcel", null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='duesToExcel'")%>    
</div>
     <fieldset>
            <legend class="ui-widget-header ui-corner-top">Filter dues</legend>
            <div id="filterdue" class="padding1px">
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Department</div>
                    <div class="editor-field"><input type="text" id="inputDept" name="Dept" value="" onchange="reloadGrid('due')"/></div>
                    
                </div>
                 <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Semester</div>
                    <div class="editor-field"><input type="text" id="inputSem" name="Sem" value="" onchange="reloadGrid('due')"/></div>
               </div>
              
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Hall Ticket No</div>
                    <div class="editor-field"><input type="text" id="inputHTNo" name="HTNo" value="" onchange="reloadGrid('due')"/></div>
                </div> 

                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Name</div>
                    <div class="editor-field"><input type="text" id="inputName" name="HTNo" value="" onchange="reloadGrid('due')"/></div>
                </div> 
                
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Quota</div>
                    <div class="editor-field"><input type="text" id="inputQuota" name="Quota" value="" onchange="reloadGrid('due')"/></div>
                </div> 
                 <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Caste</div>
                    <div class="editor-field"><input type="text" id="inputCaste" name="Caste" value="" onchange="reloadGrid('due')"/></div>
                </div> 
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Aca Year</div>
                    <div class="editor-field"><%: Html.DropDownList("acayearid", null,null, new { onchange = "reloadGrid('due')" })%></div>
                </div>
                <div class="formFieldDiv">
                    
                    <div class="editor-label ui-state-default">Batch</div>
                    <div class="editor-field"><%: Html.DropDownList("batchid", null,"Select Batch", new { onchange = "reloadGrid('due')" })%></div>
                    
                </div>
                
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Fee Type</div>
                    <div class="editor-field"><%: Html.DropDownList("feetypeid", null,"Select Fee Type", new { onchange = "reloadGrid('due')" })%></div>
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
                <div class="clearFix"></div>
             <input type="button" class="ui-button" onclick="resetFormReloadGrid('due');" value="Reset" />
             <input type="button" class="ui-button" onclick="reloadGrid('due')" value="Reload" />
     </fieldset>
     
     
    <div id="dueGridContainer" style="position: relative">
            <div class="actionContent hideDiv" id="dueActions">
                <div id="needToAddId" class="floatLeft">
                    <%: Html.MyActionLink("", "due", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='dueEdit'")%>
                    <%: Html.MyActionLink("", "due", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='dueDelete'")%>
                    <%: Html.MyActionLink("", "due", "PrintToPDF", new { id = 1 }, "ajaxLoadToPdf", "mainContentPlaceHolder", "class='ui-icon ui-icon-print floatLeft' id='duePrint'")%>
                    <%: Html.MyActionLink("", "due", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='dueDetails'")%>
                </div>
                <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('dueActions');">
                </span>
            </div>
            <table id="due" class="scroll" cellpadding="0" cellspacing="0">
            </table>
            <div id="pagedue" class="scroll" style="text-align: center;">
            </div>
        </div>
   
    <script type="text/javascript">
        var contextName = "due"
        var gridDataUrl = '/due/toGrid';

        jQuery("#" + contextName).jqGrid({
            url: gridDataUrl,
            postData:
            {
                HTNo: function () { return $("#inputHTNo").val(); },
                Name: function () { return $("#inputName").val(); },
                Batchid: function () { return $("#batchid").val(); },
                Caste: function () { return $("#inputCaste").val(); },
                Quota: function () { return $("#inputQuota").val(); },
                Dept: function () { return $("#inputDept").val(); },
                Sem: function () { return $("#inputSem").val(); },
                AcaYearId: function () { return $("#acayearid").val(); },
                feetypeid: function () { return $("#feetypeid").val(); },
                feeExemption: function () { return $('[name=feeExemption]:checked').val(); }
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
                userdata: "userdata",
                subgrid: {
                    root: "rows",
                    repeatitems: false,
                    cell: ""
                }
            },
            colNames: ['Student Id', 'HTNo', 'Name', 'Semester', 'Batch', 'Quota', 'Caste', 'Aca Year', 'Fee Type', 'Amount', 'Concessions', 'Payments', 'Due', 'FE'],
            colModel: [

                        { name: 'studentid', index: 'studentid', hidden: true },
                        { name: 'HTNo', index: 'HTNo', width: 120 },
                        { name: 'Name', index: 'Name',width:200 },
                        { name: 'Semester', index: 'Semester' },
                        { name: 'Batch', index: 'Batch', width: 50 },
                        { name: 'Quota', index: 'Quota', width: 50 },
                        { name: 'Caste', index: 'Caste', width: 40 },
                        { name: 'AcaYear', index: 'AcaYear' },
                        { name: 'FeeType', index: 'FeeType' },
                        { name: 'Amount', index: 'Amount', align: 'right' },
                        { name: 'Concessions', index: 'Concessions', align: 'right' },
                        { name: 'Payments', index: 'Payments', align: 'right' },
                        { name: 'Due', index: 'Due', align: 'right' },
                        { name: 'FeeExemption', index: 'FeeExemption', formatter: 'checkbox'}],

            rowNum: 10,
            rowList: [10, 20, 30, 40, 50, 60, 80, 100, 120, 150, 200, 500, 10000],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page' + contextName),
            sortname: 'HTNo',
            viewrecords: true,
            sortorder: "asc",
            caption: "Payments List",
            rownumbers: true,
            onSelectRow: function (id, status, e) { }, // gridRowSelected(id, status, e,contextName); },
            loadComplete: function () {
                $("option[value=10000]").text('All');
                $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1);
                $(window).trigger('resize');
            }

        });
        jQuery("#"+contextName).jqGrid('navGrid', '#page'+contextName, { edit: false, add: false, del: false, search: false })
        $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-newwin",
                onClickButton: function () {
                    var myUrl = "/due/exportGridToExcel/?h=h";
                    var postData = jQuery("#"+contextName).jqGrid('getGridParam', 'postData');
                    $.each(postData, function(key, value) {
                    if(value.toString().indexOf('$')>=0){
                        value = value.toString().substring(value.toString().indexOf('$'));
                        value = value.toString().substring(0,value.toString().indexOf(';'));
                        value = eval(value.toString());
                    }
                    myUrl += "&"+key+"="+encodeURIComponent(value);
                    });
                   
                    window.open(myUrl);
                },
                position: "first",
                title : "Export the above rows to Excel"
            }); 
               
        $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);

        

        $(window).bind('resize',function(){
            $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);
            $("#gbox_"+contextName+" .ui-jqgrid-bdiv").width($('#gbox_'+contextName).width()+1);
        });
        
      
        $(function () {
            commonFunctions();
            $( "#inputDept" ).autocomplete({
                source: "/dept/deptAutoComplete",
                focus:function(event,ui){$(this).val(ui.item.label);}
            });
            $( "#inputCaste" ).autocomplete({
                source: "/caste/casteAutoComplete",
                focus:function(event,ui){$(this).val(ui.item.label);}
            });
            $( "#inputQuota" ).autocomplete({
                source: "/quota/quotaAutoComplete",
               focus:function(event,ui){$(this).val(ui.item.label);}
            });
            $( "#inputSem" ).autocomplete({
                source: function(request, response) {
                            $.ajax({
                                url: "/sem/semAutoComplete",
                                dataType: "json",
                                data: {
                                    term : request.term,
                                    Dept : $("#inputDept").val()
                                },
                                success: function(data) {
                                    response(data);
                                }
                            });
                        },
                focus:function(event,ui){$(this).val(ui.item.label);}
            });

            $( "#inputHTNo" ).autocomplete({
                source: function(request, response) {
                            $.ajax({
                                url: "/student/HTNoAutoComplete",
                                dataType: "json",
                                data: {
                                    term : request.term,
                                    max : 12,
                                    Dept : $("#inputDept").val(),
                                    Sem : $("#inputSem").val()
                                },
                                success: function(data) {
                                    response(data);
                                }
                            });
                        },
               minLength: 3,
               focus:function(event,ui){$(this).val(ui.item.label);}
            });
        });

    
   </script>