<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.sem>>" %>
<p class="moduleTitle">
    List of semesters</p>
<div class="errorDiv" id="errorContent">
</div>
<div id="semGridContainer" style="position: relative">
    <div class="actionContent hideDiv" id="semActions">
        <div id="needToAddId" class="floatLeft">
            <%: Html.MyActionLink("", "sem", "Edit",new { id=1 }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='semEdit'")%>
    		<%: Html.MyActionLink("", "sem", "Details",new { id=1 }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='semDetails'")%>
    		<%: Html.MyActionLink("", "sem", "Delete",new { id=1 }, "ajaxLoad", "masterContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='semDelete'")%>
    	 </div>
        <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('semActions');">
        </span>
    </div>
    <table id="sem" class="scroll" cellpadding="0" cellspacing="0">
    </table>
    <div id="pagesem" class="scroll" style="text-align: center;">
    </div>
</div>
<script type="text/javascript">
       
        var contextName = "sem"
        var gridDataUrl = '/sem/toGrid';

         var lastSel = 0;

        jQuery("#"+contextName).jqGrid({
            url: gridDataUrl,
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

            colNames: ['Sem id','deptid','Department','Semester','Description','Students'],
            colModel: [ { name: 'id', index: 'id',key:true, hidden: true },
                        { name: 'deptid', index: 'deptid',hidden: true },
                        { name: 'dept', inedx:'dept'},
                        { name: 'name', index: 'name', width:100, editable: true},
                        { name: 'desc', index: 'desc', width:100, editable: true},
                        { name: 'students', index: 'students'}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50,100],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'name',
            viewrecords: true,
            sortorder: "asc",
            caption: "sems List",
            rownumbers: true,
            onSelectRow: function (id) {
                if (id && id !== lastSel) {
                    jQuery('#' + contextName).restoreRow(lastSel);
                    lastSel = id;
                }
                var rowData = jQuery('#'+contextName).jqGrid('getRowData',id);
                jQuery('#' + contextName).
                        editRow(
                                id, 
                                true, 
                                function(id){$('#'+id+' input:first').select();},
                                null, 
                                "/sem/gridAddOrUpdate",
                                {   
                                    deptid: rowData.deptid, 
                                },
                                function (id,response) { afterSuccess(id,response); }, 
                                function (id, response) { inlineEditResponseFail(id, response); });
            },
            loadComplete: function () { $('.ui-jqgrid-bdiv').width($('.ui-jqgrid-bdiv').width() + 1); $(window).trigger('resize');}
        });

        jQuery("#"+contextName).jqGrid('navGrid', '#page'+contextName, { edit: false, add: false, del: false, search: false });

        $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);

        $(window).bind('resize',function(){
            $("#"+contextName).setGridWidth($('#gbox_'+contextName).parent().width()-10);
            $("#gbox_"+contextName+" .ui-jqgrid-bdiv").width($('#gbox_'+contextName).width()+1);
        });

        if ("True"=="<%:Html.checkActionPermission("sem","DeleteFromGrid")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-trash",
                onClickButton: function () {
                    var gr = jQuery("#"+contextName).jqGrid('getGridParam','selrow');
                    $.ajax({
                        url: "/sem/DeleteFromGrid",
                        type:"Post",
                        dataType: "json",
                        data: {
                            id: gr
                        },
                        success: function (data) {
                            if(data.success){
                                $('#'+contextName).trigger('reloadGrid');
                            } else errorDialog('dialog', data.message.toString());
                        }
                    });
                },
                position: "first"
            });
        }

        if ("True"=="<%:Html.checkActionPermission("sem","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('masterContentPlaceHolder', '/sem/Create');
                },
                position: "first"
            });
        }

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
      
        $(function () {
            $('#page'+contextName+'_left').css("width","auto");
            commonFunctions();
        });

   
</script>