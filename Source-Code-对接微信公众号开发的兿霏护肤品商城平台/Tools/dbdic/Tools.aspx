<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tools.aspx.cs" Inherits="ZoomLaCMS.Tools.dbdic.Tools" MasterPageFile="~/Common/Master/Empty.master"%>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>数据字典工具</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div>
   <asp:Button runat="server" ID="HasDelTables_Btn" Text="获取已删除的表" OnClick="HasDelTables_Btn_Click" />
</div>
<div runat="server" id="result_div" class="margin_t5">

</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script"></asp:Content>