var ZLHelper = {};
ZLHelper.ToWordByID = function (id, name) {
    var html = document.getElementById(id).innerHTML;
    ZLHelper.OutToWord(html, name);
}
ZLHelper.ToExcelByID = function (id, name) {
    var html = document.getElementById(id).innerHTML;
    ZLHelper.OutToExcel(html, name);
}
//可对html自定义处理后,再利用其导出
//元素间(<div></div>)不能换行,否则后台格式需要特殊处理 
ZLHelper.OutToWord = function (html, name) {
    if (name == undefined || !name) { name = ""; }
    if (name && name != "") { name = escape(name); }
    var $form = $('<form target="_blank"  method="post" action="/Common/Label/OutToWord.aspx?name=' + name + '"></form>');
    $form.append('<input type="hidden" name="html_toword_hid" value=' + encodeURI(html) + '>');
    $("body").append($form);//兼容IE
    $form.submit();
    $form.remove();
}
ZLHelper.OutToExcel = function (html, name) {
    if (name == undefined || !name) { name = ""; }
    if (name && name != "") { name = escape(name); }
    var $form = $('<form target="_blank"  method="post" action="/Common/Label/OutToExcel.aspx?name=' + name + '"></form>');
    $form.append('<input type="hidden" name="html_toword_hid" value=' + encodeURI(html) + '>');
    $("body").append($form);//兼容IE
    $form.submit();
    $form.remove();
}
ZLHelper.OutToPdf = function (html, name) {

}
//点击非目标对象关闭提示层
var pophelp = {};
pophelp.autoclose = function () {
    $body = $("body");
    $body.find('.popovers').each(function () {
        $(this).click(function (e) {
            $('.popover').remove();
            e.preventDefault();
            return false;
        });
        $(this).popover({
            trigger: 'click'
        });
    });
    $body.click(function () {
        $('.popover').remove();
    });
}
