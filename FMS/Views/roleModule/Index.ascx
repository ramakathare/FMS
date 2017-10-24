<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<FMS.Data.rolemodule>>" %>
<p class="moduleTitle">
    Role Modules</p>
<div class="errorDiv" id="errorContent">
</div>
<div id="rolemoduleGridContainer" style="position: relative">
    <div class="actionContent hideDiv" id="rolemoduleActions">
        <div id="needToAddId" class="floatLeft">
            <%: Html.MyActionLink("", "rolemodule", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='rolemoduleEdit'")%>
            <%: Html.MyActionLink("", "rolemodule", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='rolemoduleDelete'")%>
            <%: Html.MyActionLink("", "rolemodule", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='rolemoduleDetails'")%>
        </div>
        <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('rolemoduleActions');">
        </span>
    </div>
    <table id="rolemodule" class="scroll" cellpadding="0" cellspacing="0">
    </table>
    <div id="pagerolemodule" class="scroll" style="text-align: center;">
    </div>
</div>
<script type="text/javascript">
       
        var contextName = "rolemodule"
        var gridDataUrl = '/rolemodule/toGrid';

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

            colNames: ['Role Module id', 'Role Module Name', 'Display Name'],
            colModel: [{ name: 'id', index: 'id',key:true, hidden: true },
                        { name: 'name', index: 'name', width:100, editable: true},
                        { name: 'displayname', index: 'displayname', editable: true}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50,100,500],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'name',
            viewrecords: true,
            sortorder: "asc",
            caption: "rolemodules List",
            rownumbers: true,
            onSelectRow: function (id) {
                if (id && id !== lastSel) {
                    jQuery('#' + contextName).restoreRow(lastSel);
                    lastSel = id;
                }
                jQuery('#' + contextName).
                        editRow(
                                id, 
                                true, 
                                function(id){$('#'+id+' input:first').select();},
                                null, 
                                "/rolemodule/gridAddOrUpdate",
                                null,
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

        if ("True"=="<%:Html.checkActionPermission("rolemodule","DeleteFromGrid")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-trash",
                onClickButton: function () {
                    var gr = jQuery("#"+contextName).jqGrid('getGridParam','selrow');
                    $.ajax({
                        url: "/rolemodule/DeleteFromGrid",
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

        if ("True"=="<%:Html.checkActionPermission("rolemodule","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/rolemodule/Create');
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
