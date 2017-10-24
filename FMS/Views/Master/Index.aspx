<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<style>
    .my-ui-corner-top{
        border-bottom-left-radius: 0;
        border-bottom-right-radius: 0;
    }
</style>
    <div id="masterActions">
       <%: Html.MyActionLink("Academic Year", "acayear", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='acayearIndex'")%> 
       <%: Html.MyActionLink("Batch", "batch", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='batchIndex'")%> 
       <%: Html.MyActionLink("Caste", "caste", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='casteIndex'")%> 
       <%: Html.MyActionLink("Department", "dept", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='deptIndex'")%> 
       <%: Html.MyActionLink("Semester", "sem", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='semIndex'")%> 
       <%: Html.MyActionLink("Quota", "quota", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='quotaIndex'")%> 
       <%: Html.MyActionLink("Feetypes", "feetype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='feetypeIndex'")%> 
       <%: Html.MyActionLink("Payment Type", "paymenttype", "Index", null, "ajaxLoad", "masterContentPlaceHolder", "class='ui-button my-ui-corner-top' id='paymenttypeIndex'")%>
    </div>
    <div id="masterContentPlaceHolder" class="masterContentPlaceHolder ui-corner-bottom ui-corner-right">
        Click one of the buttons above to load the content
    </div>
    <script>
        $(function () {
            commonFunctions();
            eval($('#masterActions a:first-child').addClass('ui-state-highlight').attr('href').split(':')[1]);
            $('#masterActions a').each(function () {
                $(this).click(function () {
                    $('#masterActions a.ui-state-highlight').removeClass('ui-state-highlight');
                    $(this).addClass('ui-state-highlight');
                });
            });
        });
    </script>

   