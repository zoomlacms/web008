<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvtoManage.aspx.cs" Inherits="ZoomLaCMS.Manage.Shop.InvtoManage"MasterPageFile="~/Manage/I/Default.master"%>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <title>发票类型</title>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <table class="table table-striped table-bordered table-hover">
    <tr class="tdbg">
        <td class="td_s">ID</td>
        <td>发票类型名称</td>
        <td style="width:20%">发票类型说明</td>
        <td class="td_m">税率</td>
        <td class="td_l">操作</td>
    </tr>
    <ZL:ExRepeater ID="IType_RPT" PageSize="20" runat="server" PagePre="<tr><td colspan='5' class='text-center'>" PageEnd="</td></tr>">
        <ItemTemplate>
            <tr class="tdbg" onmouseover="this.className='tdbgmouseover'" onmouseout="this.className='tdbg'" id="<%#Eval("id") %>" ondblclick="getinfo(this.id )">
                <td><%#Eval("id") %></td>
                <td><%#Eval("InvtoType")%></td>
                <td><%#Eval("Remark")%></td>
                <td><%#Eval("Invto")%> %</td>
                <td>
                    <a href="AddInvoType.aspx?id=<%#Eval("id") %>" class="option_style"><i class="fa fa-pencil" title="修改"></i></a>
                     <a href="?menu=del&id=<%#Eval("id") %>" onclick="return confirm('不可恢复性删除数据,你确定将该数据删除吗？');" class="option_style"><i class="fa fa-trash-o" title="删除"></i>删除</a>
                </td>
            </tr>
        </ItemTemplate>
    </ZL:ExRepeater>
</table>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
    <script type="text/javascript">
        function getinfo(id) {
            location.href = "AddInvoType.aspx?menu=edit&id=" + id + "";
        }
</script>
</asp:Content>