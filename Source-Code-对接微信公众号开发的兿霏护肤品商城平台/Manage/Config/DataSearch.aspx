<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataSearch.aspx.cs" Inherits="ZoomLaCMS.Manage.Config.DataSearch" MasterPageFile="~/Manage/I/Default.master" %>
<%@ Register Src="~/Manage/I/ASCX/SPwd.ascx" TagPrefix="uc1" TagName="SPwd" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>全库搜索</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<uc1:SPwd runat="server" ID="SPwd" Visible="false" />
<div runat="server" id="maindiv" visible="false">
    <div class="input-group margin_t5 text_500">
        <span class="input-group-addon">全库搜索</span>
        <ZL:TextBox runat="server" ID="SearchText_T" class="form-control" placeholder="请输入需要检索的值" AllowEmpty="false"/>
        <span class="input-group-btn">
            <asp:Button ID="Button1" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="Button1_Click" />
        </span>
    </div>
   <ZL:ExGridView runat="server" ID="EGV" AutoGenerateColumns="False" PageSize="10" IsHoldState="false" Visible="false"
    OnPageIndexChanging="EGV_PageIndexChanging" AllowPaging="True" AllowSorting="True"
    CssClass="table table-striped table-bordered margin_t5" EnableTheming="False" EnableModelValidation="True" EmptyDataText="未检索到相关数据">
       <Columns>
           <asp:BoundField HeaderText="表名" DataField="tablename" ItemStyle-CssClass="td_l" />
           <asp:BoundField HeaderText="字段名" DataField="columnname"/>
       </Columns>
   </ZL:ExGridView>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<style type="text/css">
.allchk_l{display:none;}
</style>
</asp:Content>