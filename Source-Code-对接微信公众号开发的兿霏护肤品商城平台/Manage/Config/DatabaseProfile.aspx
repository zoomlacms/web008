<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DatabaseProfile.aspx.cs" Inherits="ZoomLaCMS.Manage.Config.DatabaseProfile" MasterPageFile="~/Manage/I/Default.master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript" src="/js/Common.js"></script>
    <title>运行库概况</title>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#Tabs0" data-toggle="tab">整体概况</a></li>
        <li><a href="#Tabs1" data-toggle="tab">数据详情</a></li>
    </ul>
    <div class="tab-content panel-body padding0">
        <div class="tab-pane active" id="Tabs0">
            <asp:Label ID="tableTotal" runat="server"></asp:Label>
        </div>
        <div class="tab-pane" id="Tabs1">
            <div id="RunOK" runat="server"></div>
        </div>
    </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
    <script type="text/javascript">

    </script>
</asp:Content>





