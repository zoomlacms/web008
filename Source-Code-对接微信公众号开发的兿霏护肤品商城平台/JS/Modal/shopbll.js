//单品促销
var grouppro = {};
grouppro.del = function (id, callback) {
    $.post("/common/comp/GroupPro.aspx?action=del&proid=" + id, {}, function (data) {
        if (callback) { callback(data); }
    });
}