﻿var upro = {};
upro.init = function () { $("#uprolist").load("/Common/Comp/ProductList.aspx?ProIDS=" + $("#UProIDS_Hid").val()); }
upro.showdiag = function () { ShowComDiag("/Common/Dialog/SelProduct.aspx?callback=selupro", "选择商品"); }
upro.del = function (btn, proid) {
    var ids = $("#UProIDS_Hid").val();
    ids = ids.replace("," + proid + ",", ",");
    $("#UProIDS_Hid").val(ids);
    $(btn).closest(".up_proitem").remove();
}
function selupro(list) {
    list = JSON.parse(list);
    var ids = list.GetIDS("id");
    ids = $("#UProIDS_Hid").val() + "," + ids;
    $("#UProIDS_Hid").val(ids);
    $("#uprolist").load("/Common/Comp/ProductList.aspx?ProIDS=" + ids);
}
$(function () { upro.init(); })