<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cart.aspx.cs" Inherits="ZoomLaCMS.Cart.cart" MasterPageFile="~/Cart/order.master" EnableViewState="false"%>
<asp:Content runat="server" ContentPlaceHolderID="head">
<title>购物车</title>
<link href="/Template/EasyFace/style/global.css" rel="stylesheet" />
<style type="text/css">
body { height:550px;}
.head_div { padding:10px 0 10px;}
.width360 { width:360px;}
#EGV tr { background:#fff;}
#EGV .media-left img { width:80px; height:80px; border:1px solid #ddd;}
#EGV .media-heading { font-size:1.1em;}
#EGV .media-heading a { text-decoration:none;}
.pronum_td { width:85px;}
.pronum_text { padding-left:5px; padding-right:5px;}
.media-heading a { color:#333;}
.weui_cells { margin-top:0; font-size:1em;}
.weui_check_label { margin-bottom:0; font-weight:normal;}
.weui_cell_bd p { margin-bottom:0;}
.weui_media_box  { padding:0;}
.weui_media_box .weui_media_title { margin-top:0; font-size:1em;}
.weui_media_box .weui_media_title a { color:#333;}
body { background:#f5f5f5;}
.cart_tit { margin-top:20px; margin-bottom:20px; font-family:"STHeiti","Microsoft YaHei","黑体","arial";}
.cart_tit h2 { font-size:24px; margin-top:0; margin-bottom:0;}
.cart_tit span { font-size:14px; margin-left:20px;}
#empty_div { position:absolute; margin-bottom:0; text-align:center; width:100%; top:50%; left:0; margin-top:-75px;}
#empty_div i { font-size:5em;}
#empty_div a { display:block; margin-left:auto; margin-right:auto; width:40%; padding-top:10px; padding-bottom:10px; text-align:center; font-size:1.4em; background:#1AAD19; color:#FFF; text-decoration:none; border-radius:50px;}
.main_div { display:none;}
</style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div class="visible-xs">
<div class="new_top">
<div class="media">
<div class="media-left media-middle"><a href="/Class_8/Default.aspx"><img src="/Template/EasyFace/style/images/logo_w.svg" alt="EasyFace" /></a></div>
<div class="media-body"><h3><a href="/User/Login">登录</a></h3><p><img src="/Template/EasyFace/style/images/hometop_pic1.png" alt="EasyFace" /> 简单护肤，护肤可以很简单</p></div>
</div>
</div>
</div>
<div class="hidden-xs"><%Call.Label("{ZL.Label id=\"新版全站头部\" /}");%></div>
<div class="clearfix"></div>
<div class="container padding0_xs">
<div id="empty_div" runat="server" visible="false">
<i class="fa fa-exclamation-circle"></i>
<i class="weui-icon-warn weui-icon_msg-primary"></i>
<p>您的购物车内还没有商品</p>
<a href="/Class_8/Default.aspx">立即购物</a>
</div>
<table id="EGV" class="table cartbody">
        <asp:Repeater runat="server" ID="RPT" OnItemDataBound="RPT_ItemDataBound">
            <ItemTemplate>
                <tbody style="border:none;" class="cart_body">
                    <tr>
                        <td colspan="7" class="storename">
                            <label style="margin-bottom:0; height:34px; line-height:34px;"><input type="checkbox" class="store_chk" name="store_chk" checked="checked" value="<%#Eval("ID") %>" />
                            <i class="fa fa-home" title="店铺"></i> <%#Eval("StoreName") %></label>
                            <span class="pull-right">
                            	<button type="button" class="btn btn-danger pro_bian" onClick="EditCart();" >编辑</button>
                            	<button type="button" class="btn btn-info pro_suc" onClick="EditDown();" style="display:none;">完成</button>
                            </span>
                        </td>
                    </tr>
                    <asp:Repeater runat="server" ID="ProRPT" OnItemDataBound="ProRPT_ItemDataBound">
                        <ItemTemplate>
                            <asp:Panel runat="server" Visible='<%#(Eval("Class","")=="2"?true:false) %>'>
                                <tbody style="border:none;" id="suit_wrap_<%#Eval("ID") %>">
                                    <tr data-id="<%#Eval("ID") %>" class="cart_item">
                                    <td style="position:relative;">
                                        <input type="checkbox" name="prochk" data-store="<%#Eval("StoreID") %>" checked="checked" value="<%#Eval("ID") %>" />
                                        <div class="line_vertical"></div>
                                    </td>
                                    <td><strong>【套装】</strong><%#Eval("ProName") %></td>
                                    <td><%#GetMyPrice() %></td>
                                    <td class="pronum_td hidden-xs" colspan="2">
                                        <div class="input-group td_m">
                                            <span class="input-group-addon" onclick="cart.suit.setnum('<%#Eval("ID") %>','+');"><span class="fa fa-minus"></span></span>
                                            <input type="text" class="form-control pronum_text" id="pronum_<%#Eval("ID") %>" value="<%#Eval("Pronum") %>" autocomplete="off" onblur="cart.suit.setnum('<%#Eval("ID") %>',this.value);">
                                            <span class="input-group-addon" onclick="cart.suit.setnum('<%#Eval("ID") %>','-');"><span class="fa fa-plus"></span></span>
                                        </div>
                                    </td>
                                    <td class=""><span id="trprice_<%#Eval("ID") %>" class="trprice"><%#GetPrice() %></span></td>
                                    <td class="">
                                        <a href="javascript:;" class="grayremind" onclick="cart.del('<%#Eval("ID") %>');">删除</a>
                                    </td>
                                </tr>
                                    <asp:Repeater runat="server" ID="SuitPro_RPT">
                                        <ItemTemplate>
                                            <tr class="suit_item">
                                                <td style="position: relative;">
                                                    <span class="line_circle"></span>
                                                    <div class="line_vertical"></div>
                                                </td>
                                                <td>
                                                    <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品">
                                                        <img src="<%#GetImgUrl(Eval("Thumbnails"))%>" onerror="shownopic(this);" class="preimg_l" />
                                                    </a>
                                                    <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><%#Eval("ProName") %></a>
                                                </td>
                                                <td class="tdline hidden-xs suit_item_price" style="color: #999; font-size: 12px;"><%#Eval("LinPrice","{0:F2}") %></td>
                                                <td class="tdline text-center" style="color: #999; font-size: 12px;">
                                                    <span class="suit_item_num"><%#Eval("suitnum") %></span><%#Eval("ProUnit") %>/套 X<span class="suit_item_pronum"><%#Eval("Pronum") %></span>
                                                </td>
                                                <td class="tdline hidden-xs"></td>
                                                <td class="tdline suit_item_total" style="color: #999;"><%#(Convert.ToDouble(Eval("LinPrice"))*Convert.ToInt32(Eval("Pronum"))).ToString("F2") %></td>
                                                <td class="tdline">
                                                    <%-- <a href="javascript:;" class="grayremind" onclick="cart.del('<%#Eval("ID") %>');">删除</a>--%>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </asp:Panel>
                            <asp:Panel runat="server" Visible='<%#(Eval("Class","")=="0"?true:false) %>'>
                                <tr data-id="<%#Eval("ID") %>" class="cart_item">
                                    <td colspan="7">
                                    <div class="media">
                                    	<div class="media-left media-middle"><input type="checkbox" name="prochk" data-store="<%#Eval("StoreID") %>" checked="checked" value="<%#Eval("ID") %>" /></div>
                                        <div class="media-left"><a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><img src="<%#GetImgUrl(Eval("Thumbnails"))%>" onerror="shownopic(this);" class="preimg_l" /></a></div>
                                        <div class="media-body media-middle">
                                        	<h4 class="media-heading"><a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><%#Eval("ProName") %></a></h4>
                                            <div class="cart_list_cp">
                                                 <span id="price_<%#Eval("ID") %>" class="hidden"><%#GetMyPrice() %></span>
                                                 <span class="trprice pull-left" style="display:block; line-height:30px; color:#c00; font-size:1.2em;"><i class="fa fa-rmb"></i> <span id="trprice_<%#Eval("ID") %>"><%#Eval("linPrice","{0:f2}") %></span></span>
                                                 <div class="pull-right pronum_td">
                                                <div class="input-group input-group-sm">
                                                <span class="input-group-addon minus" style="padding-left:5px; padding-right:5px;" onClick="cart.setnum('<%#Eval("ID") %>','+');"><span class="fa fa-minus"></span></span>
                                                <input type="text" class="form-control pronum_text" id="pronum_<%#Eval("ID") %>" value="<%#Eval("pronum") %>">
                                                <span class="input-group-addon" style="padding-left:5px; padding-right:5px;" onClick="cart.setnum('<%#Eval("ID") %>','-');"><span class="fa fa-plus"></span></span>
                                                </div>
                                                </div>
                                                <div class="pull-right pro_del" style="display:none;"><a href="javascript:;" class="btn btn-info btn-sm" onclick="cart.del('<%#Eval("ID") %>');">删除</a></div>
                                            </div>
                                    	</div>
                                    </div>
                                    </td>
                                </tr>
                            </asp:Panel>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </ItemTemplate>
        </asp:Repeater>
</table>
<div class="cart_bottom">
<label style="float:left; margin-top:10px; margin-right:5px;"><input type="checkbox" checked="checked" onclick="ChkAll(this);" />全选</label>
<span style=" display:block; float:left; line-height:42px; font-size:1.1em; color:#e4393c;">合计：<span runat="server" id="totalmoney" class="totalmoney">0.00</span></span>
<div class="pull-right">
<%--
<span>余额:<span id="totalPurse_sp"></span></span>
<span>银币:<span id="totalSicon_sp"></span></span>
<span>积分:<span id="totalPoint_sp"></span></span>
--%>
<input type="button" id="NextStep" value="去结算" class="btn btn-danger " onclick="GetNextStep();" style="border-radius:0; padding-top:10px; padding-bottom:10px; height:44px; line-height:24px;" />
<asp:Button runat="server" ID="RealNext_Btn" OnClick="NextStep_Click" Style="display: none;" />
<input type="button" value="批量删除" class="btn btn-warning pull-right btn_del" onclick="cart.batdel();" style="display:none; border-radius:0; padding-top:10px; padding-bottom:10px; height:44px; line-height:24px;" />
</div>
</div>
<div id="remind_max" style="padding: 20px; display: none;">
    <div>
        <span class="fa fa-warning" style="font-size: 48px; color: #ffd800;"></span>
        <span style="font-size: 18px; font-weight: bold; margin-left: 10px;">商品数量不能大于200</span>
    </div>
</div>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<style type="text/css">
@media(max-width:768px) {.container {padding-left:0px;padding-right:0px;}}
.cartbody .suit_item{background:#fff4e8;}
.cartbody .line_circle{background:url(/App_Themes/Admin/shop/cart-line-02.png) 0 -17px no-repeat;top:0px;left:10px;height:30px;display:block;position:absolute;width:7px;}
.cartbody .line_vertical{border:none; border-left:1px dashed #ddd;width:1px;height:100%;display:block;position:absolute;left:13px;min-height:90px;}
</style>
<script src="/JS/Controls/B_User.js"></script>
<script src="/JS/Controls/ZL_Dialog.js"></script>
<script src="/JS/Controls/Control.js"></script>
<script src="/JS/ICMS/ZL_Common.js"></script>
<script src="/JS/ZL_Regex.js"></script>
<script src="/JS/Modal/APIResult.js"></script>
<script>
    var buser = new B_User();
    var diag = new ZL_Dialog();
    var cart = { api: "/cart/OrderCom.ashx?action=", suit: {}, price: {} };
    cart.del = function (id) {
        if (!confirm("确定要删除吗")) { return false; }
        $.post(cart.api + "cart_del", { "ids": id }, function (data) {
            APIResult.ifok(data, function () { location = location; }, function () { console.log("failed", data); });
        })
    }
    cart.batdel = function () {
        var ids = "";
        var $chks = $("input[name='prochk']:checked");
        if ($chks.length < 1) { alert("未选定需要删除的商品"); }
        $chks.each(function () { ids += this.value + ","; });
        ids = ids.substr(0, ids.length - 1);
        cart.del(ids);
    }
    cart.setnum = function (id, num) {
        num = cart.getnum(id, num);
        $.post(cart.api + "cart_setnum", { "id": id, pronum: num }, function (data) {
            APIResult.ifok(data, function () { }, function () { console.log("setnum failed:", data); })
        });
        cart.updatePrice(id);
    }
    cart.updatePrice = function (id) {
        var pronum = $("#pronum_" + id).val();
        var price = $("#price_" + id).text();
        var obj = $("#trprice_" + id);
        obj.text((price * pronum).toFixed(2));
        UpdateTotalPrice();
    }
    //套装商品修改数量
    cart.suit.setnum = function (id, num) {
        num = cart.getnum(id, num);
        //$("#suit_wrap_" + id).find(".suit_item_pronum").text(num);
        $.post(cart.api + "cart_setnum", { "id": id, pronum: num }, function (data) {
            APIResult.ifok(data, function () { }, function () { console.log("setnum failed:", data); })
        });
        cart.updatePrice(id);
        cart.suit.updateNumAndPrice(id,num);
    }
    //更新套装商品价格,仅显示,不参与逻辑
    cart.suit.updateNumAndPrice = function (id,num) {
        var $items = $("#suit_wrap_" + id).find(".suit_item");
        //直接根据零售价和数量算出总价
        $items.each(function () {
            var $this = $(this);
            var price = Convert.ToDouble($this.find(".suit_item_price").text());
            var suitnum = Convert.ToInt($this.find(".suit_item_num").text());
            $this.find(".suit_item_pronum").text(num * suitnum);
            $this.find(".suit_item_total").text((price * num).toFixed(2))
        });
    }
    //解绑套装,并删除对应商品,解绑定作为普通商品存在
    cart.suit.unbind = function (suitid, proid) {

    }
    //-----------------公用方法
    cart.getnum = function (id, num) {
        var $text = $("#pronum_" + id);
        var v = Convert.ToInt($text.val(), 1);
        switch (num) {
            case "+":
                if (v > 1) { --v; }
                $text.val(v);
                break;
            case "-":
                $text.val(++v);
                break;
            default:
                $text.val(Convert.ToInt(num, 1));
                break;
        }
        return parseInt($text.val());
    }
    //-------------------------------------------
    $(function () {
        ZL_Regex.B_Num(".pronum_text");
        ZL_Regex.B_Value(".pronum_text", {
            min: 1, max: 200, overmin: function () { }, overmax: function () {
                ShowRemind();
            }
        });
        $("input[name=prochk]").click(function () {
            UpdateTotalPrice();
            UpdateItemNum();
        });
        $(".store_chk").click(function () {
            ChkByStore(this);
            UpdateItemNum();
            UpdateTotalPrice();
        });
        UpdateItemNum();
        UpdateTotalPrice();
        Control.EnableEnter();
        buser.IsLogged(function () { });
    })
    //------AJAX
    function GetNextStep() {
        disBtn($("#NextStep")[0], 2000);
        buser.IsLogged(function (data, flag) {
            if (flag) {
                $("#RealNext_Btn").click();
            }
            else {
                diag.width = "minwidth";
                diag.title = "用户登录";
                diag.url = "/com/login_Ajax";
                diag.maxbtn = false;
                diag.backdrop = true;
                diag.ShowModal();
            }
        });
    }
    function LoginSuccess() {
        diag.CloseModal();
        $("#RealNext_Btn").click();
    }
    function AutoHeight() { diag.AutoHeight(); }
    //------Page
    function skey()
    {
        var key = $("#skey_t").val();
        window.open("/Search/SearchList?node=0&keyword="+key);
    }
    //全选本店商品
    function ChkByStore(obj) {
        $(":checkbox[name=prochk][data-store=" + obj.value + "]").each(function () { this.checked = obj.checked; });
    }
    //--商品数量相关
    function ChkAll(obj) {
        $("#EGV :checkbox").each(function () { this.checked = obj.checked; });
        UpdateItemNum();
    }
    //更新数量,确定是否禁用按钮
    function UpdateItemNum() {
        var num = $("[name=prochk]:checked").length;
        $("#pronum_span").text(num);
        document.getElementById("NextStep").disabled = (num < 1) ? "disabled" : "";
    }
    //更新总金额
    function UpdateTotalPrice() {
        var $chkarr = $("[name=prochk]:checked");
        var money = 0.00, purse = 0.00, sicon = 0.00, point = 0.00;
        for (var i = 0; i < $chkarr.length; i++) {
            var id = $chkarr[i].value;
            var num = $("#pronum_" + id).val();
            var pursePrice = parseFloat($("#price_purse_" + id).text());
            var siconPrice = parseFloat($("#price_sicon_" + id).text());
            var pointPrice = parseFloat($("#price_point_" + id).text());
            if (pursePrice)
                purse += pursePrice * num;
            if (siconPrice)
                sicon += siconPrice * num;
            if (pointPrice)
                point += pointPrice * num;
            money += parseFloat($("#trprice_" + id).text());
        }
        $("#totalmoney").text(money.toFixed(2));
        $("#totalPurse_sp").text(purse.toFixed(2));
        $("#totalSicon_sp").text(sicon.toFixed(2));
        $("#totalPoint_sp").text(point.toFixed(2));
    }
    //---------------------------数量提示窗
    var reminddiv;
    $(function () {
        reminddiv = $("#remind_max");
        reminddiv.remove();
        reminddiv.show();
    })
    function ShowRemind() {
        var diag = new ZL_Dialog();
        diag.width = "minwidth";
        diag.maxbtn = false;
        diag.backdrop = false;
        diag.title = "提示";
        diag.body = reminddiv[0].outerHTML;
        diag.ShowModal();
    }
	function EditCart(){
		$(".pro_bian").hide();
		$(".pro_suc").show();
		$(".pronum_td").hide();
		$(".pro_del").show();
		$("#NextStep").hide();
		$(".btn_del").show();
	}
	function EditDown(){
		$(".pro_bian").show();
		$(".pro_suc").hide();
		$(".pronum_td").show();
		$(".pro_del").hide();
		$("#NextStep").show();
		$(".btn_del").hide();
	}
	$().ready(function(e) {
		buser.IsLogged(function(data,flag){
			if(flag)
			{
				data=JSON.parse(data);
				data.UserName="<%Call.Label("{ZL.Label id=\"获取当前登录用户真实姓名\"/}");%>";
				if(data.TrueName=='') data.TrueName=data.UserName;
				$(".home_top_l a:nth-child(1)").html("欢迎您，"+data.TrueName+"！");
				$(".home_top_l a:nth-child(1)").attr("href","/User");
				$(".home_top_l a:nth-child(2)").hide();
				$(".home_top_l a:nth-child(3)").show();
				$(".new_top .media-body h3 a").html("欢迎您，"+data.UserName);
				$(".new_top .media-body h3 a").attr("href","/User");
			}
			else{
				$(".home_top_l a:nth-child(3)").hide();
			}
		});
    });
</script>
</asp:Content>