<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="getOrderInfo.aspx.cs" Inherits="ZoomLaCMS.Cart.getOrderInfo"  MasterPageFile="~/Cart/order.master" EnableViewStateMac="true"%>
<asp:Content runat="server" ContentPlaceHolderID="head">
<script src="/JS/Controls/ZL_Dialog.js"></script>
<script src="/JS/ICMS/ZL_Common.js"></script>
<title>订单结算</title>
<style type="text/css">
.arsbtn {color:#ddd;border-color:#ddd;}
.arsbtn:hover { color:#ddd; border-color:#ddd; background:none;}
.arsbtn .fa{display:none;}
.arsbtn.checked{border:1px solid rgb(70, 184, 218);color:rgb(70, 184, 218); background:none;}
.arsbtn.checked .fa{display:inline-block;color:rgb(70, 184, 218);}
.orderbody .suit_item{background:#fff4e8;}
.orderbody .tdtext { line-height: 50px;text-align:center; }
</style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <div class="head_div hidden-xs">
        <a href="/"><img src="<%=Call.LogoUrl %>" /></a>
    </div>
    <div class="gray_border">
        <div class="bordered address_div"><span class="address_head">填写并核对订单信息</span><img class="pull-right" src="/App_Themes/User/step2.png" /></div>
        <div class="bordered" runat="server" id="Address_Div" style="margin:0 15px;padding-left:0px;">
            <p><i class="fa fa-pencil-square-o strong"> 收货人信息</i>
                 <button type="button" class="btn btn-info btn-xs margin_l20" onclick="AddAddress();"><i class="fa fa-adn"></i> 添加新地址</button></p>
            <ul class="addresssul indent" id="addressul" style="font-size:12px;"></ul>
            <div>
                <span>配送时间：</span>
                <span id="exptime_sp">工作日、双休日与节假日均可送货</span>
                <a href="javascript:;" onclick="exp.showExpTime();">修改</a>
                <asp:HiddenField runat="server" ID="exptime_hid" Value="工作日、双休日与节假日均可送货" />
            </div>
        </div>
        <div class="bordered" hidden>
            <p>
                <button type="button" class="btn btn-default btn-sm arsbtn" id="arsbtn" onclick="exp.arsSelf(this);"><i class="fa fa-check"></i> 用户自提取商品</button>
                <input type="checkbox" value="1" id="arsbtn_chk" name="arsbtn_chk" style="display:none;"/>
            </p>
        </div>
        <div class="bordered">
            <p><i class="fa fa-th strong"> 发票信息</i></p>
            <div class="indent">
                <label>
                    <input type="radio" name="invoice_rad" value="0" onclick="$('#invoice_div').hide();" checked="checked"/>不开发票</label>
                    <label><input type="radio" name="invoice_rad" value="1" onclick="$('#invoice_div').show();" />需要发票</label><br />
                <div id="invoice_div">
                    <ul class="addresssul indent padding0">
                        <asp:Repeater ID="Invoice_RPT" runat="server">
                            <ItemTemplate>
                                <li>
                                    <label class="normalw"><input class="invoice_item_rad" name="invoice_item_rad" type="radio" value='<%#Eval("Detail") %>' data-head="<%#Eval("Head") %>" /><%#Eval("Head") %></label>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate> 
                                 <li><label class="normalw"><input class="invoice_item_rad" name="invoice_item_rad" type="radio" value='' data-head=""/>使用新发票</label></li>
                            </FooterTemplate>
                        </asp:Repeater>
                    </ul>
                    <div>
                        <asp:TextBox runat="server" ID="InvoTitle_T" CssClass="form-control text_400 margin_t5" MaxLength="50" placeholder="发票抬头（个人或公司名称）"/> 
                        <asp:TextBox runat="server" ID="Invoice_T" TextMode="MultiLine" class="form-control invoice_t" MaxLength="180" placeholder="在此输入发票开具科目明细"/>
                    </div>
                </div>
            </div>
        </div>
        <div class="bordered">
            <p><i class="fa fa-cubes strong">商品清单</i>
                <a runat="server" id="ReUrl_A1" visible="false" title="返回购物车" class="pull-right padding_r10">返回修改购物车</a>
                <a runat="server" id="ReUrl_A2" visible="false" class="pull-right padding_r10">返回修改信息</a>
            </p>
            <div class="indent orderbody">
                <table class="table text-center">
                <tr style="background:#eeeeee;"><td>商品</td><td>金额</td><td>优惠</td><td>数量</td><td>状态</td></tr>
                    <asp:Repeater runat="server" ID="Store_RPT" OnItemDataBound="Store_RPT_ItemDataBound" EnableViewState="false">
                        <ItemTemplate>
                            <tbody style="border: none;">
                                <tr>
                                    <td colspan="6" class="storename text-left"><label><i class="fa fa-home"></i> <%#Eval("StoreName") %></label></td></tr>
                                     <asp:Repeater runat="server" ID="ProRPT" EnableViewState="false" OnItemDataBound="ProRPT_ItemDataBound">
                                                <ItemTemplate>
                                                    <asp:Panel runat="server" Visible='<%#(Eval("Class","")=="2"?true:false) %>'>
                                                        <tr>
                                                            <td class="text-left">
                                                                <div>
                                                                    <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><strong>【套装】</strong><%#Eval("ProName") %></a>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <i class="fa fa-rmb"><%#Eval("AllMoney","{0:F2}") %></i>
                                                            </td>
                                                            <td class="r_red"><%#GetDisCount()%></td>
                                                            <td>x <%#Eval("Pronum") %></td>
                                                            <td><%#GetStockStatus() %></td>
                                                        </tr>
                                                        <asp:Repeater runat="server" ID="SuitPro_RPT">
                                                            <ItemTemplate>
                                                                <tr class="suit_item">
                                                                    <td class="text-left" style="padding-left:40px;">
                                                                        <div class="pull-left">
                                                                            <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品">
                                                                                <img src="<%#GetImgUrl(Eval("Thumbnails"))%>" onerror="shownopic(this);" class="preimg_m" /></a>
                                                                        </div>
                                                                        <div class="padding_l55 tdtext" style="text-align:left;">
                                                                            <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><span><%#Eval("ProName") %></span></a>
                                                                        </div>
                                                                    </td>
                                                                    <td class="tdtext">
                                                                       <%-- <i class="fa fa-rmb"><%#Eval("AllMoney","{0:F2}") %></i>--%>
                                                                    </td>
                                                                    <td class="r_red"></td>
                                                                    <td class="r_gray tdtext">1件/套 x<%#Eval("Pronum") %></td>
                                                                    <td class="tdtext"><%#GetStockStatus() %></td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </asp:Panel>
                                                    <asp:Panel runat="server" Visible='<%#(Eval("Class","")=="0"?true:false) %>'>
                                                        <tr>
                                                            <td class="text-left">
                                                                <div class="pull-left">
                                                                    <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品">
                                                                        <img src="<%#GetImgUrl(Eval("Thumbnails"))%>" onerror="shownopic(this);" class="preimg_m" /></a>
                                                                </div>
                                                                <div class="padding_l55 tdtext" style="text-align:left;">
                                                                    <a href="<%#GetShopUrl() %>" target="_blank" title="浏览商品"><span><%#Eval("ProName") %></span></a>
                                                                    <p class="grayremind"><%#GetAddition() %></p>
                                                                </div>
                                                            </td>
                                                            <td class="tdtext">
                                                                <i class="fa fa-rmb"><%#Eval("AllMoney","{0:F2}") %></i>
                                                            </td>
                                                            <td class="tdtext r_red"><%#GetDisCount()%></td>
                                                            <td class="tdtext">x <%#Eval("Pronum") %></td>
                                                            <td class="tdtext"><%#GetStockStatus() %></td>
                                                        </tr>
                                                    </asp:Panel>
                                                </ItemTemplate>
                                        </asp:Repeater>
                                   <tr><td colspan="6" class="text-right">
                                           <span>配送方式:</span>
                                       <asp:Literal runat="server" ID="FareType_L" EnableViewState="false"></asp:Literal>
                                       </td></tr>
                                 </tbody>
                        </ItemTemplate>
                    </asp:Repeater>
                <tr>
                    <td colspan="5">
                        <div class="text-right total_count_div">
                            <div><span><span runat="server" id="itemnum_span" class="r_red_x">1</span>件商品,总商品金额：</span><i class="fa fa-rmb" runat="server" id="totalmoney_span1">0.00</i>
                               <%-- <span>余额:<span id="totalPurse_sp"></span></span>
                                <span>银币:<span id="totalSicon_sp"></span></span>
                                <span>积分:<span id="totalPoint_sp"></span></span>--%>
                            </div>
                            <div><span>优惠卷：</span><i class="fa fa-rmb" id="arrive_money_sp">0.00</i></div>
                            <div><span>积分折扣：</span><i class="fa fa-rmb" id="point_money_sp">0.00</i></div>
                            <div><span>运费：</span><i class="fa fa-rmb" id="fare_span">0.00</i></div>
                            <div class="pay_moneyAll"><span>应付总额：</span><i class="fa fa-rmb" runat="server" id="totalmoney_span2">0.00</i></div>
                        </div>
                    </td>
                </tr>
            </table>
                <ul class="extend_ul">
                    <li runat="server" visible="false" id="userli">
                         <p><a href="javascript:;" onclick="$('#userlist_div').toggle();" title="显示顾客详情"><i class="fa fa-users"> 顾客与联系人列表</i></a></p>
                        <div id="userlist_div" class="extenddiv" style="display:block;">
                            <table class="table table-bordered">
                                <tr>
                                    <td class="td_m">姓名</td><td>证件号</td><td>手机</td>
                                </tr>
                                <asp:Repeater runat="server" ID="UserRPT" EnableViewState="false">
                                    <ItemTemplate><tr><td><%#Eval("Name") %></td><td><%#Eval("CertCode") %></td><td><%#Eval("Mobile") %></td></tr></ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </li>
                    <li>
                        <div><a href="javascript:;" onclick="$('#arrive_div').toggle();"><i class="fa fa-plus-circle"> 优惠券</i></a></div>
                        <asp:Literal runat="server" ID="Arrive_Lit" EnableViewState="false"></asp:Literal>
                    </li>
                    <li id="point_li">
                        <div><a href="javascript:;" onclick="$('.point_div').toggle();"><i class="fa fa-plus-circle"> 积分抵扣</i></a></div>
                        <div id="point_body" runat="server" visible="false" class="extenddiv point_div">
                            共<asp:Label ID="Point_L" runat="server"></asp:Label>个积分,本次可用<span id="usepoint_span" class="r_red"></span>个积分,<asp:TextBox runat="server" ID="Point_T" Text="0" onkeyup="checkMyPoint(this);" CssClass="form-control text_150 num"/>
                        </div>
                        <div id="point_tips" runat="server" visible="false" class="alert alert-warning point_div extenddiv" role="alert">
                            <i class="fa fa-exclamation-circle"></i> 积分抵扣已关闭!
                        </div>
                    </li>
                    <li>
                       <div><a href="javascript:;" onclick="$('#oremind_div').toggle();"><i class="fa fa-plus-circle"> 订单备注</i></a></div>
                        <div id="oremind_div" class="extenddiv">
                            <p>提示：请勿填写有关支付、收货、发票方面的信息</p>
                            <asp:TextBox runat="server" ID="ORemind_T" CssClass="form-control max" MaxLength="100" placeholder="限100个字" />
                        </div>
                   </li>
                </ul>
            </div>
        </div>
        <div class="total_div">
            <span class="total">应付总额：<i runat="server" id="totalmoney_i" class="fa fa-rmb">0.00</i></span><asp:Button runat="server" CssClass="btn btn-danger" ID="AddOrder_Btn" Text="提交订单" OnClientClick="disBtn(this,5000);" OnClick="AddOrder_Btn_Click" />
        </div>
    </div>
    <asp:HiddenField ID="PointRate_Hid" runat="server" />
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<script src="/JS/Modal/APIResult.js"></script>
<script>
    $(function () {
        //付款方式
        $(".methodul li").click(function () {
            $(this).siblings().removeClass("active");
            $(this).addClass("active");
            $(this).find(":radio")[0].checked = true;
        })
        $(".methodul li:first").click();
        //发票
        $(".invoice_item_rad").click(function () {
            $("#InvoTitle_T").val($(this).data("head"));
            $("#Invoice_T").val($(this).val());
        });
        $(".invoice_item_rad:first").click();
        //运费
        $(".fare_select").change(function () {
            UpdateTotalPrice();
        });
        arrive.init();
        exp.init();
        UpdateTotalPrice();
        ZL_Regex.B_Num(".num");
        IsDisBtn();
    })
    var diag = new ZL_Dialog();
    diag.width = "minwidth";
    diag.maxbtn = false;
    function AddAddress() {
        diag.title = "添加新地址";
        diag.url = "address.aspx";
        diag.ShowModal();
    }
    function EditAddress(id) {
        diag.title = "修改地址";
        diag.url = "address.aspx?id=" + id;
        diag.ShowModal();
    }
    function DelAddress(myid) {
        if (confirm("确定要删除吗")) {
            $("#addli_" + myid).remove();
            exp.addressDefChk();
            $.post("ordercom.ashx", { action: "deladdress", id: myid }, function () {});
        }
    }
    function SelInvo(dp) {
        if ($(dp).val() != "") {
            $("#InvoTitle_T").val($(dp).find(":selected").text());
            $("#Invoice_T").val($(dp).val());
        }
    }
    //价格统计
    function UpdateTotalPrice() {
        var total = parseFloat($("#totalmoney_span1").text());
        var arrive = parseFloat($("#arrive_money_sp").text());
        var point = parseFloat($("#point_money_sp").text());
        var fare = 0;
        //根据所选,计算运费
        $(".fare_select").each(function () {
            fare += parseFloat($(this).find("option:selected").data("price"));
        });
        total = (total + arrive + fare - point);
        total = total > 0 ? total : 0;
        $("#fare_span").text(fare.toFixed(2));
        $("#totalmoney_span2").text(total.toFixed(2));
        $("#totalmoney_i").text(total.toFixed(2));
        $("#totalPurse_sp").text(GetSumByFilter(".purse_sp"));
        $("#totalSicon_sp").text(GetSumByFilter(".sicon_sp"));
        $("#totalPoint_sp").text(GetSumByFilter(".point_sp"));
    }
    //计算可用积分抵扣
    function SumByPoint(usepoint) {
        var point = parseFloat($("#Point_L").text());
        if (usepoint > point) { usepoint = point; };
        $("#usepoint_span").text(usepoint);
        $("#Point_T").change(function () {
            var point = Convert.ToDouble(this.value);
            if (point > usepoint) { point = usepoint; }
            this.value = point;
        });
    }
    function GetSumByFilter(filter) {
        var total = 0.00;
        $(filter).each(function () {
            var price = parseFloat($(this).text());
            if (price) total += price;
        });
        return total.toFixed(2);
    }
    //是否禁用按钮
    function IsDisBtn() {
        var flag = false;
        if ($(".arsbtn").hasClass("checked")) { }
        else if ($("#Address_Div").length > 0 && $(".addresssul li").length < 1) {
            console.log("未选定地址"); flag = true;
        }
        if ($(".stockout").length > 0) { console.log("有缺货数据"); flag = true; }
        if (flag) { disBtn(document.getElementById("AddOrder_Btn")); }
        else { console.log("检测通过"); disBtn(document.getElementById("AddOrder_Btn"),100); }
    }
    function checkMyPoint(obj) {
        if (isNaN(parseFloat($(obj).val()))) { $(obj).val("0"); }
        var val = parseFloat($(obj).val());
        var usepoint = parseFloat($("#usepoint_span").text());//可用积分
        if (usepoint <= val) { val = usepoint; };
        var pointrate = parseFloat($("#PointRate_Hid").val());
        $("#point_money_sp").text((val * pointrate).toFixed(2));
        UpdateTotalPrice();
    }
    function closeDiag() { diag.CloseModal(); CloseComDiag(); }
    //--------------
    var exp = {};
    exp.init = function () {
        $("#addressul").load("/cart/comp/AddressList.aspx", {}, function () {
            exp.addressDefChk();          
        });
    }
    //选中第一个地址,添加或删除后
    exp.addressDefChk = function () {
        if ($(".addresssul li").length > 0) {
            $(".addresssul li").click(function () {
                $(this).siblings().removeClass("active");
                $(this).addClass("active");
                $(this).find("input:radio")[0].checked = true;
                $(".arsbtn").removeClass("checked");
                $("#arsbtn_chk")[0].checked = false;
            });
            $(".addresssul li:first").click(); $(":radio[name=address_rad]")[0].checked = true;
        }
        IsDisBtn();
    }
    //快递添加修改后回调
    exp.addressBack = function () {
        diag.CloseModal(); $("#addressul").load("/cart/comp/AddressList.aspx", {}, function () {
            exp.addressDefChk();
        });
    }
    //用户自提
    exp.arsSelf = function (btn) {
        $(".addresssul li").removeClass("active");
        $(".addresssul li input:radio").each(function () { this.checked = false; });
        $(btn).addClass("checked");
        $("#arsbtn_chk")[0].checked = true;
    }
    exp.showExpTime = function () {
        diag.title = "配送时间";
        diag.url = "/cart/comp/exptime.aspx";
        diag.ShowModal();
    }
    exp.expTimeBack = function (json) {
        $("#exptime_sp").text(json.txt);
        $("#exptime_hid").val(json.txt);
        //$("#exptime_hid").data("json", JSON.stringify(json));
    }
    //--------------
    var arrive = {};
    arrive.init = function () {
        $("#arrive_active_ul .item").click(function () {
            var $this = $(this);
            if ($this.hasClass("choose")) {//取消使用
                $this.removeClass("choose");
                arrive.use("");
            }
            else {
                $(".arrive_o .item").removeClass("choose");
                $this.addClass("choose");
                arrive.use($this.data("flow"));
            }
        });
    }
    arrive.use = function (flow) {
        var model = { action: "arrive", "flow": flow, money: $("#totalmoney_span1").text(), ids: "<%=Request["ids"]%>" };
        if (flow == "") {
            $("#arrive_money_sp").text("-0.00"); $("#Arrive_Hid").val(flow); UpdateTotalPrice(); return;
        }
        $.post("ordercom.ashx", model, function (data) {
            var model = APIResult.getModel(data);
            if (APIResult.isok(model)) {
                $("#arrive_money_sp").text("-" + parseFloat(model.result.amount).toFixed(2));
            }
            else { $("#arrive_money_sp").text("-0.00"); alert(model.retmsg); }
            $("#Arrive_Hid").val(flow);
            UpdateTotalPrice();
        });
    }
</script>
</asp:Content>