<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.rolemoduleaction>>" %>
<p class="moduleTitle">
    Role Module Actions</p>
<div class="errorDiv" id="errorContent">
</div>
<form id="formrolemoduleaction" action="">
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Filter Role Module Actions</legend>
    <div id="filterrolemoduleaction" class="padding1px">
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Role Module</div>
            <div class="editor-field">
                <%: Html.DropDownList("rolemoduleid", null, "Select Role Module", new { onchange = "reloadGrid('rolemoduleaction')" })%>
            </div>
        </div>
    </div>
    <div class="clearFix" />
    <input type="button" class="ui-button" onclick=" $('#errorContent').html(''); resetFormReloadGrid('rolemoduleaction');"
        value="Reset" />
    <input type="button" class="ui-button" onclick="reloadGrid('rolemoduleaction');" value="Reload" />
    
</fieldset>
</form>

<div id="rolemoduleactionGridContainer" style="position: relative">
    <div class="actionContent hideDiv" id="rolemoduleactionActions">
        <div id="needToAddId" class="floatLeft">
            <%: Html.MyActionLink("", "rolemoduleaction", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='rolemoduleactionEdit'")%>
            <%: Html.MyActionLink("", "rolemoduleaction", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='rolemoduleactionDelete'")%>
            <%: Html.MyActionLink("", "rolemoduleaction", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='rolemoduleactionDetails'")%>
        </div>
        <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('rolemoduleactionActions');">
        </span>
    </div>
    <table id="rolemoduleaction" class="scroll" cellpadding="0" cellspacing="0">
    </table>
    <div id="pagerolemoduleaction" class="scroll" style="text-align: center;">
    </div>
</div>
<script type="text/javascript">
       
        var contextName = "rolemoduleaction"
        var gridDataUrl = '/rolemoduleaction/toGrid';

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
            postData: //$('#form' + contextName).serialize(),
            {
                rolemoduleid: function () { return $("#rolemoduleid").val(); }
            },

            colNames: ['Role Module Action id','rolemoduleid','Role Module','Role Module Action', 'Display Name'],
            colModel: [{ name: 'id', index: 'id',key:true, hidden: true },
                        { name: 'rolemoduleid', index: 'rolemoduleid',hidden: true },
                        { name: 'rolemodule', index: 'rolemodule', width:100, editable: true},
                        { name: 'name', index: 'name', width:100, editable: true},
                        { name: 'displayname', index: 'displayname', editable: true}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50,100,500],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'rolemodule',
            viewrecords: true,
            sortorder: "asc",
            caption: "rolemoduleactions List",
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
                                "/rolemoduleaction/gridAddOrUpdate",
                                { 
                                   rolemoduleid: rowData.rolemoduleid
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

        if ("True"=="<%:Html.checkActionPermission("rolemoduleaction","DeleteFromGrid")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-trash",
                onClickButton: function () {
                    var gr = jQuery("#"+contextName).jqGrid('getGridParam','selrow');
                    $.ajax({
                        url: "/rolemoduleaction/DeleteFromGrid",
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

        if ("True"=="<%:Html.checkActionPermission("rolemoduleaction","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/rolemoduleaction/Create');
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