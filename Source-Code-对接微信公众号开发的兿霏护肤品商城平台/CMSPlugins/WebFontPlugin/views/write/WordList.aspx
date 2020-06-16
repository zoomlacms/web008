<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WordList.aspx.cs" Inherits="ZoomLaCMS.webfont.write.WordList" MasterPageFile="~/Common/Master/Empty.master" EnableViewState="false"%>
<asp:Content runat="server" ContentPlaceHolderID="head">
<title><%=FontName_L.Text %>_文字列表</title>
<link type="text/css" rel="stylesheet" href="/App_Themes/Guest.css" />  
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div class="container margin_t10">
<div class="panel panel-info">
<div class="panel-heading">
<i class="fa fa-font"></i> <asp:Label runat="server" ID="FontName_L"></asp:Label>
<span class="pull-right"><a href="/webfont/write/"><i class="fa fa-reply"></i> 返回首页</a></span>
</div>
<div class="panel-body">
<asp:Repeater runat="server" ID="RPT">
<ItemTemplate>
<a href="wordPanel.aspx?id=<%#Eval("ID") %>"  data-code="<%#Eval("Unicode") %>" class="word_item <%#Eval("ZStatus","").Equals("99")?"completed":"writing" %>">
<span style="padding: 4px;"><%#"&#"+Eval("Unicode") %></span>
</a>
</ItemTemplate>
</asp:Repeater>
</div>
</div>
</div>
<div style="height:55px;"></div>
<div class="word_btns">
<asp:Button runat="server" ID="CreateFont_Btn" Text="OK,点我发布字体!" OnClick="CreateFont_Btn_Click" class="btn btn-info" OnClientClick="return confirm('确定要生成字库吗?');" />
<a href="/webfont/write/" class="btn btn-default">返回首页</a>
</div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Script">
</asp:Content>