<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<FMS.Data.rolemoduleactionpermission>>" %>
<p class="moduleTitle">
    Role Module Action Permissions</p>
<div class="errorDiv" id="errorContent">
</div>
<form id="formrolemoduleactionpermission" action="">
<fieldset>
    <legend class="ui-widget-header ui-corner-top">Search Role Modules Actions</legend>
    <div id="filterrolemoduleactionpermission" class="padding1px">
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Role</div>
            <div class="editor-field">
                <%: Html.DropDownList("roleid", null, "Select Role", new { onchange = "reloadGrid('rolemoduleactionpermission')" })%>
            </div>
        </div>
        <div class="formFieldDiv">
            <div class="editor-label ui-state-default">
                Role Module</div>
            <div class="editor-field">
                <%: Html.DropDownList("rolemoduleid", null, "Select Role Module", new { onchange = "reloadGrid('rolemoduleactionpermission')" })%>
            </div>
        </div>
    </div>
    <div class="clearFix" />
    <input type="button" class="ui-button" onclick=" $('#errorContent').html(''); resetFormReloadGrid('rolemoduleactionpermission');"
        value="Reset" />
    <input type="button" class="ui-button" onclick="reloadGrid('rolemoduleactionpermission');" value="Reload" />
    
</fieldset>
</form>

<div id="rolemoduleactionpermissionGridContainer" style="position: relative">
    <div class="actionContent hideDiv" id="rolemoduleactionpermissionActions">
        <div id="needToAddId" class="floatLeft">
            <%: Html.MyActionLink("", "rolemoduleactionpermission", "Edit", new{id=1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-pencil floatLeft' id='rolemoduleactionpermissionEdit'")%>
            <%: Html.MyActionLink("", "rolemoduleactionpermission", "Delete", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-trash floatLeft' id='rolemoduleactionpermissionDelete'")%>
            <%: Html.MyActionLink("", "rolemoduleactionpermission", "Details", new { id =1}, "ajaxLoad", "mainContentPlaceHolder", "class='ui-icon ui-icon-details floatLeft' id='rolemoduleactionpermissionDetails'")%>
        </div>
        <span class="ui-icon ui-icon-close floatLeft curPointer" onclick="hide('rolemoduleactionpermissionActions');">
        </span>
    </div>
    <table id="rolemoduleactionpermission" class="scroll" cellpadding="0" cellspacing="0">
    </table>
    <div id="pagerolemoduleactionpermission" class="scroll" style="text-align: center;">
    </div>
</div>
<script type="text/javascript">
       
        var contextName = "rolemoduleactionpermission"
        var gridDataUrl = '/rolemoduleactionpermission/toGrid';

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
                roleid: function () { return $("#roleid").val(); },
                rolemoduleid: function () { return $("#rolemoduleid").val(); }
            },

            colNames: ['id','roleid','rolemoduleactionid','Role', 'Role Module','Action','Display Name','Permission'],
            colModel: [ { name: 'id', index: 'id',key:true, hidden: true },
                        { name: 'roleid', index: 'roleid',hidden: true },
                        { name: 'rolemoduleactionid', index: 'rolemoduleactionid',hidden: true },
                        { name: 'role', index: 'role', width:100},
                        { name: 'rolemodule', index: 'rolemodule'},
                        { name: 'name', index: 'name'},
                        { name: 'displayname', index: 'displayname'},
                        { name: 'permission', index: 'permission',editable:true,edittype:'checkbox', editoptions: { value:"true:false"},formatter: 'checkbox'}],
            rowNum: 10, 
            rowList: [10, 20, 30, 40, 50,100,500],
            height: 'auto',
            width: 'auto',
            pager: jQuery('#page'+contextName),
            sortname: 'role',
            viewrecords: true,
            sortorder: "asc",
            caption: "rolemoduleactionpermissions List",
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
                                "/rolemoduleactionpermission/gridAddOrUpdate",
                                { 
                                    roleid: rowData.roleid,
                                    rolemoduleactionid: rowData.rolemoduleactionid
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


        if ("True"=="<%:Html.checkActionPermission("rolemoduleactionpermission","DeleteFromGrid")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-trash",
                onClickButton: function () {
                    var gr = jQuery("#"+contextName).jqGrid('getGridParam','selrow');
                    $.ajax({
                        url: "/rolemoduleactionpermission/DeleteFromGrid",
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

        if ("True"=="<%:Html.checkActionPermission("rolemoduleactionpermission","Create")%>") {
            $("#"+contextName).navButtonAdd('#page'+contextName, {
                caption: "",
                buttonicon: "ui-icon-plus",
                onClickButton: function () {
                    ajaxLoad('mainContentPlaceHolder', '/rolemoduleactionpermission/Create');
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
            commonFunctions();
        });

   
</script>