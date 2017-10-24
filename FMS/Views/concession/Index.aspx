<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.concession>>" %>
<script src="<%: Url.Content("~/Content/chosen/chosen.jquery.min.js") %>" type="text/javascript"></script>
<link href="../../Content/chosen/chosen.css" rel="stylesheet" type="text/css" />
<p class="moduleTitle">Concession</p>
<div class="errorDiv" id="errorContent"></div>

     <fieldset>
            <legend class="ui-widget-header ui-corner-top">Filter Concession</legend>
            <div id="filterconcession" class="padding1px">
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Department</div>
                    <div class="editor-field"><input type="text" id="inputDept" name="Dept" value="" onchange="reloadGrid('concession')"/></div>
                    
                </div>
                 <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Semester</div>
                    <div class="editor-field"><input type="text" id="inputSem" name="Sem" value="" onchange="reloadGrid('concession')"/></div>
               </div>
                
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Name</div>
                    <div class="editor-field"><input type="text" id="inputName" name="Name" value="" onchange="reloadGrid('concession')"/></div>
                </div>  
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Hall Ticket No</div>
                    <div class="editor-field"><input type="text" id="inputHTNo" name="HTNo" value="" onchange="reloadGrid('concession')"/></div>
                </div> 
                
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Quota</div>
                    <%--<div class="editor-field"><input type="text" id="inputQuota" name="Quota" value="" onchange="reloadGrid('payfee')"/></div>--%>
                    <div class="editor-field"><%: Html.DropDownList("quotaid", null, new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('concession')" })%></div>
                </div> 
                <%-- <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Caste</div>
                    <div class="editor-field"><input type="text" id="inputCaste" name="Caste" value="" onchange="reloadGrid('payfee')"/></div>
                </div> --%>
                <div class="formFieldDiv">
                    
                    <div class="editor-label ui-state-default">Batch</div>
                    <div class="editor-field"><%: Html.DropDownList("batchid", null, new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('concession')" })%></div>
                    
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Fee Type</div>
                    <div class="editor-field"><%: Html.DropDownList("feetypeid", null, new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('concession')" })%></div>
                </div>
                <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Academic Year</div>
                    <div class="editor-field"><%: Html.DropDownList("acayearid", null, new { @class = "chzn-select", multiple = "", style = "width:206px;", onchange = "reloadGrid('concession')" })%></div>
                </div>
               <div class="formFieldDiv">
                    <div class="editor-label ui-state-default">Time Range (MM/DD/YYYY HH-MM)</div>
                    <div class="editor-field autoWidth"> 
                        <input type="text" id="inputTime1" name="time1" value=""/>To
                        <input type="text" id="inputTime2" name="time2" value=""/></div>

                </div>
             </div>
              
                <div class="clearFix"></div>
            <input type="button" class="ui-button" onclick="clearChoicesDiv('filterconcession');resetFormReloadGrid('concession');" value="Reset" />
             <input type="button" class="ui-button" onclick="reloadGrid('concession')" value="Reload" />
     </fieldset>
     
     
    <div id="concessionGridContainer" style="position: relative">
            <div class="actionContent hideDiv" id="concessionActions">
                <div id="needToAddId" class="floatLeft">
                    <%: Html.MyActionLink("", "concession", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='concessionEdit'")%>
                    <%: Html.MyActionLink("", "concession", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='concessionDelete'")%>
                    <%: Html.MyActionLink("", "concession", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='concessionDetails'")%>
                </div>
                <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('concessionActions');">
                </span>
            </div>
            <table id="concession" class="scroll" cellpadding="0" cellspacing="0">
            </table>
            <div id="pageconcession" class="scroll" style="text-align: center;">
            </div>
        </div>
   
    <script type="text/javascript">
        
        $(function(){
            d2 = new Date();
            d2.setMinutes(d2.getMinutes+1);
            d1 = new Date();
            // d1.setDate(d1.getDate()-6);
            d1.setHours(0,0,0,0);
         
            var toDate = d2.toLocaleString();
            var fromDate = d1.toLocaleString();

            $('#inputTime1').val(fromDate.toString());
           // $('#inputTime2').val(toDate.toString());
        });

        $(function(){
            var startDateTextBox = $('#inputTime1');
            var endDateTextBox = $('#inputTime2');
            var maxDate = new Date();
            var maxDateString = maxDate.toString();
            startDateTextBox.datetimepicker({ 
                maxDate : maxDate,
	            onClose: function(dateText, inst) {
		            if (endDateTextBox.val() != '') {
			            var testStartDate = startDateTextBox.datetimepicker('getDate');
			            var testEndDate = endDateTextBox.datetimepicker('getDate');
			            if (testStartDate > testEndDate)
				            endDateTextBox.datetimepicker('setDate', testStartDate);
		            }
		            else {
			            endDateTextBox.val(dateText);
		            }
	            },
	            onSelect: function (selectedDateTime){
                   
		            endDateTextBox.datetimepicker('option', 'minDate', startDateTextBox.datetimepicker('getDate') );
	            }
            });
            endDateTextBox.datetimepicker({ 
                maxDate : maxDate,
	            onClose: function(dateText, inst) {
		            if (startDateTextBox.val() != '') {
			            var testStartDate = startDateTextBox.datetimepicker('getDate');
			            var testEndDate = endDateTextBox.datetimepicker('getDate');
			            if (testStartDate > testEndDate)
				            startDateTextBox.datetimepicker('setDate', testEndDate);
		            }
		            else {
			            startDateTextBox.val(dateText);
		            }
	            },
	            onSelect: function (selectedDateTime){
		            startDateTextBox.datetimepicker('option', 'maxDate', endDateTextBox.datetimepicker('getDate'));
	            }
            });
          });

        var contextName = "concession"
        var gridDataUrl = '/concession/toGrid';

        jQuery("#"+contextName).jqGrid({
            url: gridDataUrl,
            postData:
            {
                HTNo    : function () { return $("#inputHTNo").val();},
                Name    : function () { return $("#inputName").val(); },
                Batchid   : function () { return $("#batchid").val(); },
                feetypeid   : function () { return $("#feetypeid").val(); },
                acayearid   : function () { return $("#acayearid").val(); },
//                Caste   : function () { return $("#inputCaste").val(); },
                Quota   : function () { return $("#quotaid").val(); },
                Dept    : function () { return $("#inputDept").val();},
                Sem     : function () { return $("#inputSem").val();},
                Time1     : function () { return $("#inputTime1").val();},
                Time2     : function () { return $("#inputTime2").val();}
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
            colNames: ['id','Student Id', 'HTNo', 'Name','Semester','Batch','Quota',/*'Caste',*/'Academic Year', 'Fee Type','Amount','Time','Remarks'],
            colModel: [
                        { name: 'id', index: 'id', key:true,hidden: true},
                        { name: 'studentid', index: 'studentid', hidden: true },
                        { name: 'HTNo', index: 'HTNo', width:100},
                        { name: 'Name', index: 'Name'},
                        { name: 'Semester', index: 'Semester'},
                        { name: 'Batch', index: 'Batch', width:50},
                        { name: 'Quota', index: 'Quota'},
//                        { name: 'Caste', index: 'Caste'},
                        { name: 'AcaYear', index: 'AcaYear'},
                        { name: 'FeeType', index: 'FeeType'},
                        { name: 'Amount', index: 'Amount', align:'right'},
                        { name: 'Time', index: 'Time',width:200,align:'right',sorttype:'date', formatter:'date', formatoptions: {newformat:'D, M d, Y [ H:i ]'}},
                        { name: 'Remarks', index: 'Remarks', align:'left',width:200}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50, 60,80,100,120,150,200,500,10000],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'Time',
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
                    var myUrl = "/concession/exportGridToExcel?h=h";
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

        if ("True"=="<%:Html.checkActionPermission("concession","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/concession/Create');
                },
                position: "first",
                title : "Add new Concession"
            });
        }
      
        $(function () {
            commonFunctions();
            commonFunctionForChosen();
            $( "#inputDept" ).autocomplete({
                source: "/dept/deptAutoComplete",
                focus:function(event,ui){$(this).val(ui.item.label);}
            });
//            $( "#inputCaste" ).autocomplete({
//                source: "/caste/casteAutoComplete",
//                focus:function(event,ui){$(this).val(ui.item.label);}
//            });
//            $( "#inputQuota" ).autocomplete({
//                source: "/quota/quotaAutoComplete",
//               focus:function(event,ui){$(this).val(ui.item.label);}
//            });
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