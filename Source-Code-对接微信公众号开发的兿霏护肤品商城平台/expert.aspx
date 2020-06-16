<%@ Page Language="C#" AutoEventWireup="true" CodeFile="expert.aspx.cs" Inherits="expert" Debug="true" %>
<!DOCTYPE HTML>
<html>
<head runat="server">
<meta charset="utf-8">
<meta name="msapplication-TileColor" content="#1A0066"/>
<meta name="msapplication-TileImage" content="/images/win8_symbol_140x140.png"/>
<title>专家主页</title>
<meta name="Keywords" content="META关键字">
<meta name="Description" content="META网页描述">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
<link href="/dist/css/weui.min.css" rel="stylesheet" />
<link href="/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="/JS/jquery-1.11.1.min.js" ></script>
<script src="/dist/js/bootstrap.min.js"></script>
<link href="/dist/css/font-awesome.min.css" rel="stylesheet"/>
<link href="<%Call.Label("{$CssDir/}"); %>global.css?Version=<%Call.Label("{ZL.Label id=\"前端样式版本号\"/}"); %>" rel="stylesheet"/>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
$.post("/API/UserCheck.ashx?action=HasLogged", "", function (data) {
	if (!data || data == "-1") {
		location = "/wxpromo.aspx?r=" + window.location.href;
	}
});
</script>
<style>
.weui-media-box__title { margin-top:0;}
.weui-media-box__desc { margin-bottom:0;}
.expert_list { margin-top:0;}
.weui-media-box_appmsg .weui-media-box__thumb { max-height:none; height:100%; border-radius:50%;}
.expert_qrcode { margin-bottom:1em; margin-top:1em; text-align:center;}
.expert_qrcode h3 { margin-bottom:0; font-size:1.2em;}
.expert_qrcode img { max-width:80%;}
.expert_cont { margin-top:15px; text-align:justify; text-justify:inter-ideograph; overflow:hidden; }
.expert_cont img { max-width:100%;}
</style>
</head>
<body>
<form id="form1" runat="server">
<div class="weui-panel weui-panel_access" style="margin-top:0;">
<div class="weui-panel__bd">
<div class="weui-media-box weui-media-box_appmsg">
<div class="weui-media-box__hd">
<asp:Image ID="ExpFace" runat="server" class="weui-media-box__thumb" onerror="javascript:this.src='/Images/userface/noface.png';" />
</div>
<div class="weui-media-box__bd">
<h4 class="weui-media-box__title">
<asp:Label ID="ExpName_L" runat="server" Text=""></asp:Label> | <asp:Label ID="ExpJob_L" runat="server" Text=""></asp:Label></h4>
<p class="weui-media-box__desc">
<asp:Label ID="ExpComp_L" runat="server" Text=""></asp:Label></p>
</div>
</div>
</div>
</div>
<div class="container">
<div class="expert_cont">
<%Call.Label("{ZL.Label id=\"获取指定专家详情\" /}");%>
</div>
</div>
<div class="container expert_qrcode">
<div style="display:none">
<h3>扫描二维码绑定专家</h3>
<asp:Image ID="Image1" runat="server" /></div>
<a href="/User/iServer/AddQuestion?title=咨询<%=ExpName_L.Text%>" class="btn btn-info btn-block">咨询专家</a>
<a href="/User/iServer/FiServer" class="btn btn-primary btn-block">我的提问</a>
</div>
</form>

<%Call.Label("{ZL.Label id=\"微信底部\"/}");%>
</body>
</html>