function semDropDownFromDept(deptid,div) {
        if(deptid!=""){
            $.ajax({
                url: "/sem/semDropDownFromDept",
                dataType: "json",
                data: {
                    deptid: deptid,
                },
                success: function (data) {
                   var s="<option value=\"\">Select Sem</option>";
                   $.each(data,function(){
                    s+="<option value=\""+this.id+"\">"+this.name+"</option>";
                   });
                   $('#'+div).html(s);
                }
            });
        }else{
           $('#'+div).html("<option value=\"\">Select Sem</option>");
        }
    }

function clearChoicesDiv(div) {
    $('#' + div).find('.chzn-choices').each(
                        function () {
                            $(this).children('li.search-choice').each(
                                function () {
                                    $(this).remove();
                                });
                        });
    $('#' + div).find('.chzn-results').each(
                        function () {
                            $(this).children('li.result-selected').each(
                                function () {
                                    $(this).removeClass('result-selected');
                                    $(this).addClass('active-result');
                                });
                        });
}

function ajaxLoadToPdf(div, url) {
    window.open(url, "Receipt", "menubar=0,location=0,height=827,width=583,addressbar=0");
}

function ajaxLoad(div, url) {
    //   $('#dialog').dialog("close");
    $('#' + div).html("<img class=\"loadingImg\" src=\"../../Content/themes/images/preloader.gif\" />");
   
    $.get(url, function (data) {
        $('#' + div).html(data);
        });
}

function hide(div) {
    $('#'+div).hide();
}

function reloadGrid(gridId) {
    $("#" + gridId).trigger("reloadGrid", [{ page: 1}]);
}

function resetFormReloadGrid(gridId) {
    $('#filter' + gridId).find('input:text').val('');
    $('#filter' + gridId).find('input:hidden').val('');
    $('#filter' + gridId).find('select').val(0);
    $('input:radio').each(function(){$(this).attr('checked','');});
    reloadGrid(gridId);
}

function resetForm(formId) {
    $('#' + formId).find('input:text').val('');
    $('#'+formId).find('input:hidden').val('');
    $('#' + formId).find('select').val(0);
    $('input:radio').each(function(){$(this).attr('checked','');});
}

function commonFunctions() {
    
    $(".ui-button").button();
    $('.formFieldDiv input, .formFieldDiv select').focus(function () { $(this).siblings('.field-validation-error').hide(); });
}

function commonFunctionForChosen(){
        $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({ allow_single_deselect: true });
//        $('.chzn-container').hover(
//                function () { $(this).css("height","auto"); },
//                function () { $(this).css("height","26px"); });
}

function errorDialog(div, message) {
    $('#'+div).html(message);
    $('#' + div).dialog({position: "center",minHeight:100}).dialog("open");
}

function gridRowSelected(id, status, e, contextName1) {
    var actionEleList = $('#' + contextName1 + 'Actions #needToAddId').children();
    var height = $('#' + contextName1 + 'Actions').height();
    var width = $('#' + contextName1 + 'Actions').width();
    i=0;
    leftVal = (e.pageX + 1 - $('#' + contextName1 + 'GridContainer').offset().left) +10+ "px";
    topVal = (e.pageY - height - $('#' + contextName1 + 'GridContainer').offset().top) - (height / 2) + "px";
    $('#' + contextName1 + 'Actions').css({ left: leftVal, top: topVal }).show();
    for (i = 0; i < actionEleList.length; i++) {
        var href = $(actionEleList[i]).attr('href');
        lastIndex = href.lastIndexOf('/') + 1;
        var hrefPartOne = href.substring(0, lastIndex);
        $(actionEleList[i]).attr('href', hrefPartOne + id + '\')');
    }
    setInterval(function(){if(i>=2000 && $('#' + contextName1 + 'Actions').is(':visible')) $('#' + contextName1 + 'Actions').hide(); else i++},10); 
}