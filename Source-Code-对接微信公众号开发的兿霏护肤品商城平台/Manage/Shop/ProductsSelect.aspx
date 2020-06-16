<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductsSelect.aspx.cs" Inherits="ZoomLaCMS.Manage.Shop.ProductsSelect" MasterPageFile="~/Manage/I/Default.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>选择商品</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <div class="top_opbar">
        <div class="input-group" style="width:867px;">
            <span class="input-group-addon">
                <label><input type="checkbox" id="ALLChk" /> 全选</label>
            </span>
            <select id="ddlnode" name="ddlnode" class="form-control text_300" onchange="UpdateNode()">
                <option value="0">全部栏目</option>
                <asp:Label runat="server" ID="NodeHtml_L"></asp:Label>
            </select>
            <asp:TextBox ID="TxtKeyWord" class="form-control text_300" runat="server" placeholder="请输入商品名称"></asp:TextBox>
            <span class="input-group-btn">
                <asp:LinkButton runat="server" ID="BtnSearch" OnClick="BtnSearch_Click" class="btn btn-info"><i class="fa fa-search"></i> 搜索商品</asp:LinkButton>
                <button type="button" class="btn btn-info" onclick="suresel();"><i class="fa fa-sign-in"></i> 确定选择</button>
            </span>
        </div>
    </div>
    <table class="table table-striped table-bordered" id="EGV" style="min-height:300px;">
        <tr>
            <td class="td_m">ID</td>
            <td class="td_l">商品图片</td>
            <td>商品名称</td>
            <td class="td_l">商品零售价</td>
        </tr>
        <asp:Repeater ID="RPT" runat="server">
            <ItemTemplate>
                <tr>
                    <td><label><input data-name="<%#Eval("Proname") %>" data-price="<%#Eval("LinPrice","{0:F2}") %>" name="idchk" type="checkbox" value="<%#Eval("ID") %>" /><%#Eval("ID") %></label></td>
                    <td><img src=" <%#getproimg()%>" class="img_50" /></td>
                    <td>
                        <div style="display:inline-block;width:40%;overflow:hidden;"><%#Eval("Proname") %></div>
                        <%#GetGroupPro() %>
                    </td>
                    <td><%#Eval("LinPrice","{0:c}")%></td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
    </table>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<style>
.pro_btn{border-radius:11px;padding:0 10px;color:#ededed;border:0px;}
.pro_btn:hover{color:#ededed;}
.pro_btn:focus{outline: none;color:#ededed;}
.grouppro_btn{background-color:#c9302c;}
.suitpro_btn{background-color:#ff0000;}
</style>
<script src="/JS/SelectCheckBox.js"></script>
<script>
    $(function () {
        $("#ddlnode").val("<%:NodeID%>");
        $("#ALLChk").click(function () { selectAllByName(this,"idchk"); });
    })
    function suresel() {
        var list = [];
        var $chks = $("#EGV input[name='idchk']:checked");
        if ($chks.length < 1) { alert("尚未选择商品"); return; }
        $chks.each(function () {
            var $this = $(this);
            list.push({ id: $this.val(), name: $this.data("name"), price: $this.data("price") });
        });
        parent.window["<%:CallBack%>"](JSON.stringify(list));
        parent.closeDiag();
    }
    function UpdateNode() {
        location = "ProductsSelect.aspx?NodeID=" + $("#ddlnode").val()+"&callback=<%:CallBack%>";
    }
    var product = {};
    product.init = function () {
        $(".grouppro_btn").popover({
            animation: true, html: true, trigger: "manual", placement: 'right', title: "商品分组 <a href='javascript:;' class='popClose' title='关闭' onclick='pop.close(this);'><i class='fa fa-remove'></a>",
            content: function () {
                var id = "#sgp_" + $(this).data("pid");
                return $(id).html();
            }
        }).click(function () {
            var $this = $(this);
            $(".grouppro_btn").not(this).popover("hide");
            $this.popover("show");
        });
    }
    product.init();
</script>
</asp:Content>
