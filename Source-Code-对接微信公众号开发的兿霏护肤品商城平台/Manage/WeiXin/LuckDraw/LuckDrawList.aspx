<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LuckDrawList.aspx.cs" Inherits="ZoomLaCMS.Manage.WeiXin.LuckDraw.LuckDrawList" MasterPageFile="~/Manage/I/Default.Master"%>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>抽奖信息</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<ZL:ExGridView ID="EGV" runat="server" AutoGenerateColumns="False" PageSize="10" IsHoldState="false" 
    OnPageIndexChanging="EGV_PageIndexChanging" AllowPaging="True" AllowSorting="True" OnRowCommand="EGV_RowCommand" OnRowDataBound="EGV_RowDataBound"
    CssClass="table table-striped table-bordered" EnableTheming="False" EnableModelValidation="True" EmptyDataText="数据为空">
    <Columns>
        <asp:TemplateField ItemStyle-CssClass="td_xs">
            <ItemTemplate>
                <input type="checkbox" name="idchk" value="<%#Eval("ID") %>" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField HeaderText="ID" DataField="ID" ItemStyle-CssClass="td_s" />
        <asp:TemplateField HeaderText="参与用户">
            <ItemTemplate>
              <a href="javascript:;" onclick="showuinfo('<%#Eval("UserID") %>');"><%#Eval("UserName") %></a>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField HeaderText="奖品名称" DataField="Prize" />
        <asp:BoundField DataField="CDate" DataFormatString="{0:yyyy年MM月dd日 HH:mm:ss}" HeaderText="参与时间" ItemStyle-CssClass="td_l"/>
        <asp:TemplateField HeaderText="操作" ItemStyle-CssClass="td_l">
            <ItemTemplate>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</ZL:ExGridView>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">

</asp:Content>