<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.reimbursement>>" %>
<script src="<%: Url.Content("~/Content/chosen/chosen.jquery.min.js") %>" type="text/javascript"></script>
<link href="../../Content/chosen/chosen.css" rel="stylesheet" type="text/css" />
    <p class="moduleTitle">List of Reimbursemant Applicants</p>
<div class="commonActions">
    <%: Html.MyActionLink("Add-Edit bulk reimbursemets", "reimbursement", "bulkreimbursement",null, "ajaxLoad", "mainContentPlaceHolder", "class='ui-button' id='reimbursementbulkPayFee'")%>    
</div> 
     <fieldset>
            <legend class="ui-widget-header ui-corner-top">Add Reimbursement Applicants</legend>
            <div id="filterreimbursement" class="padding1px">
               <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Department</div>
                    <div class="editor-field"><input type="text" id="inputDept" name="Dept" value="" onchange="reloadGrid('reimbursement')"/></div>
                    
                </div>
                 <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Semester</div>
                    <div class="editor-field"><input type="text" id="inputSem" name="Sem" value="" onchange="reloadGrid('reimbursement')"/></div>
               </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Hall Ticket No</div>
                    <div class="editor-field"><input type="text" id="inputHTNo" name="HTNo" value="" onchange="reloadGrid('reimbursement')"/></div>
                </div> 
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Name</div>
                    <div class="editor-field"><input type="text" id="inputName" name="Name" value="" onchange="reloadGrid('reimbursement')"/></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Application id</div>
                    <div class="editor-field"><input type="text" id="epassid" name="epass" value="" onchange="reloadGrid('reimbursement')"/></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Caste</div>
                    <div class="editor-field">
                    <%--<input type="text" id="inputCaste" name="Caste" value="" onchange="reloadGrid('reimbursement')"/>--%>
                    <%: Html.DropDownList("casteid", null,new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('reimbursement')" })%>
                    </div>
                </div> 
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Batch</div>
                    <div class="editor-field"><%: Html.DropDownList("batchid", null,new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('reimbursement')" })%></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Academic Year</div>
                    <div class="editor-field"><%: Html.DropDownList("acayearid",null,new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('reimbursement')" })%></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Approved</div>
                    <div class="editor-field">
                        <span>Yes </span><input type="radio" name="approved" value="true" onchange="reloadGrid('reimbursement')" />
                        <span>No </span><input type="radio" name="approved" value="false" onchange="reloadGrid('reimbursement')" />
                        <span>All </span><input type="radio" class="defaultRadioButton" name="approved" checked="checked" value="" onchange="reloadGrid('reimbursement')" />
                    </div>
                </div>
             </div>
            <div class="clearFix"></div>
            <input type="button" class="ui-button" onclick="clearChoicesDiv('filterreimbursement');resetFormReloadGrid('reimbursement');" value="Reset" />
            <input type="button" class="ui-button" onclick="reloadGrid('reimbursement')" value="Reload" />
     </fieldset>
     
     
    <div id="reimbursementGridContainer" style="position: relative">
            <div class="actionContent hideDiv" id="reimbursementActions">
                <div id="needToAddId" class="floatLeft">
                    <%: Html.MyActionLink("", "reimbursement", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='reimbursementEdit'")%>
                    <%: Html.MyActionLink("", "reimbursement", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='reimbursementDelete'")%>
                    <%: Html.MyActionLink("", "reimbursement", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='reimbursementDetails'")%>
                </div>
                <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('reimbursementActions');">
                </span>
            </div>
            <table id="reimbursement" class="scroll" cellpadding="0" cellspacing="0">
            </table>
            <div id="pagereimbursement" class="scroll" style="text-align: center;">
            </div>
        </div>
   
    <script type="text/javascript">

        var contextName = "reimbursement"
        var gridDataUrl = '/reimbursement/toGrid';

        jQuery("#"+contextName).jqGrid({
            url: gridDataUrl,
            postData:
            {
                HTNo    : function () { return $("#inputHTNo").val();},
                Name    : function () { return $("#inputName").val(); },
                Batchid   : function () { return $("#batchid").val(); },
                acayearid   : function () { return $("#acayearid").val(); },
                Caste   : function () { return $("#casteid").val(); },
                Dept    : function () { return $("#inputDept").val();},
                Sem     : function () { return $("#inputSem").val();},
                epassid : function () { return $("#epassid").val();},
                Approved : function(){ return $('[name=approved]:checked').val();}
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
            colNames: ['id','HTNo', 'Name','Semester','Batch','Caste','Application id','Academic Year','approved','Date','remarks'],
            colModel: [
                        { name: 'id', index: 'id', key:true,hidden: true},
                        { name: 'HTNo', index: 'HTNo', width:100},
                        { name: 'Name', index: 'Name'},
                        { name: 'Semester', index: 'Semester'},
                        { name: 'Batch', index: 'Batch', width:50},
                        { name: 'Caste', index: 'Caste'},
                        { name: 'epassid', index: 'epassid'},
                        { name: 'AcaYear', index: 'AcaYear'},
                        {name : 'approved', index:'approved',formatter: 'checkbox'},
                        {name : 'date', index:'date',align:'right',sorttype:'date', formatter:'date', formatoptions: {newformat:'D, M d, Y [ H:i ]'}},
                        {name : 'remarks', index: 'remarks'}],
            rowNum: 10, 
            rowList: [10, 30, 50, 80,150,300,500,1000,10000],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'epassid',
            viewrecords: true,
            sortorder: "desc",
            caption: "Payments List",
            rownumbers: true,
            onSelectRow: function (id, status, e) { gridRowSelected(id, status, e,contextName); },
            loadComplete: function () {
                    $("option[value=10000]").text('All'); 
                    $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1); 
                    $(window).trigger('resize');}
            
        });
        jQuery("#"+contextName).jqGrid('navGrid', '#page'+contextName, { edit: false, add: false, del: false, search: false })
        $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-newwin",
                onClickButton: function () {
                    var myUrl = "/reimbursement/exportGridToExcel?h=h";
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

        if ("True"=="<%:Html.checkActionPermission("reimbursement","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/reimbursement/Create');
                },
                position: "first",
                title : "Add new applicant"
            });
        }
      
        $(function () {
            commonFunctions();
            commonFunctionForChosen();
            $( "#inputDept" ).autocomplete({
                source: "/dept/deptAutoComplete",
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
             $( "#epassid" ).autocomplete({
                source: function(request, response) {
                            $.ajax({
                                url: "/reimbursement/epassidAutoComplete",
                                dataType: "json",
                                data: {
                                    term : request.term,
                                    max : 10
                                },
                                success: function(data) {
                                    response(data);
                                }
                            });
                        },
               minLength: 4,
               focus:function(event,ui){$(this).val(ui.item.label);}
            });
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
            } else errorDialog('dialog', result.message.toString() + " : Record not saved to server");
        }
    
   </script>