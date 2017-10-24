<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.student>>" %>

<p class="moduleTitle">
    Students</p>
<div class="errorDiv" id="errorContent">
</div>
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Filter Students</legend>
    <div id="filterstudent" class="padding1px">
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Department</div>
            <div class="editor-field">
                <input type="text" id="inputDept" name="Dept" value="" onchange="reloadGrid('student')" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Semester</div>
            <div class="editor-field">
                <input type="text" id="inputSem" name="Sem" value="" onchange="reloadGrid('student')" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Name</div>
            <div class="editor-field">
                <input type="text" id="inputName" name="Name" value="" onchange="reloadGrid('student')" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Hall Ticket No</div>
            <div class="editor-field">
                <input type="text" id="inputHTNo" name="HTNo" value="" onchange="reloadGrid('student')" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Quota</div>
            <div class="editor-field">
                <input type="text" id="inputQuota" name="Quota" value="" onchange="reloadGrid('student')" /></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Caste</div>
            <div class="editor-field">
                <input type="text" id="inputCaste" name="Caste" value="" onchange="reloadGrid('student')" /></div>
        </div>
        
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Batch</div>
            <div class="editor-field">
                <%: Html.DropDownList("batchid",null, "Select Batch",new {onchange="reloadGrid('student')"})%></div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Fee Exemption</div>
            <div class="editor-field">
                <span>Yes </span><input type="radio" name="feeExemption" value="true" onchange="reloadGrid('student')" />
                <span>No </span><input type="radio" name="feeExemption" value="false" onchange="reloadGrid('student')" />
                <span>All </span><input type="radio" class="defaultRadioButton" name="feeExemption" checked="checked" value="" onchange="reloadGrid('student')" />
            </div>
        </div>
    </div>
    <div class="clearFix">
    </div>
    <input type="button" class="ui-button" onclick="resetFormReloadGrid('student');"
        value="Reset" />
    <input type="button" class="ui-button" onclick="reloadGrid('student')" value="Reload" />
</fieldset>
<div id="studentGridContainer" style="position: relative">
    <div class="actionContent hideDiv" id="studentActions">
        <div id="needToAddId" class="floatLeft">
            <%: Html.MyActionLink("", "student", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='studentEdit'")%>
            <%: Html.MyActionLink("", "student", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='studentDelete'")%>
            <%: Html.MyActionLink("", "student", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='studentDetails'")%>
        </div>
        <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('studentActions');">
        </span>
    </div>
    <table id="student" class="scroll" cellpadding="0" cellspacing="0">
    </table>
    <div id="pagestudent" class="scroll" style="text-align: center;">
    </div>
</div>
<script type="text/javascript">
       
        var contextName = "student"
        var gridDataUrl = '/student/toGrid';

        jQuery("#"+contextName).jqGrid({
            url: gridDataUrl,
            postData:
            {
                HTNo    : function () { return $("#inputHTNo").val(); },
                Name    : function () { return $("#inputName").val(); },
                Batchid   : function () { return $("#batchid").val(); },
                Caste   : function () { return $("#inputCaste").val(); },
                Quota   : function () { return $("#inputQuota").val(); },
                Dept    : function () { return $("#inputDept").val();},
                Sem     : function () { return $("#inputSem").val();},
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

            colNames: ['Student Id', 'HTNo', 'Name','Semester','Batch','Quota','Caste','Fee Exemption'],
            colModel: [{ name: 'id', index: 'id', key: true, hidden: true },
                        { name: 'HTNo', index: 'HTNo', width:60},
                        { name: 'Name', index: 'Name'},
                        // { name: 'Deparment', index: 'Deparment'},
                        { name: 'Semester', index: 'Semester'},
                        { name: 'Batch', index: 'Batch'},
                        { name: 'Quota', index: 'Quota'},
                        { name: 'Caste', index: 'Caste'},
                        {name : 'FeeExemption', index:'FeeExemption',formatter: 'checkbox'}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50, 60,80,100,120,150,200],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'HTNo',
            viewrecords: true,
            sortorder: "asc",
            caption: "Students List",
            rownumbers: true,
            onSelectRow: function (id, status, e) { gridRowSelected(id, status, e,contextName); },
            loadComplete: function () { $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1); $(window).trigger('resize');}
        });
        jQuery("#"+contextName).jqGrid('navGrid', '#page'+contextName, { edit: false, add: false, del: false, search: false });
        $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);

        $(window).bind('resize',function(){
            $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);
            $("#gbox_"+contextName+" .ui-jqgrid-bdiv").width($('#gbox_'+contextName).width()+1);
        });

        if ("True"=="<%:Html.checkActionPermission("Student","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/Student/Create');
                },
                position: "first"
            });
        }
      
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
                minLength:3,
               focus:function(event,ui){$(this).val(ui.item.label);}
            });
        });

   
</script>
