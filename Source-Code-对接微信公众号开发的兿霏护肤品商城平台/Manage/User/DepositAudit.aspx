<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DepositAudit.aspx.cs" Inherits="ZoomLaCMS.Manage.User.DepositAudit" MasterPageFile="~/Manage/I/Default.Master" %>
<asp:Content runat="server" ContentPlaceHolderID="head"><title>提现审核</title></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
  <table class="table table-striped table-bordered">
        <tr>
            <td style="width: 15%" class="text-right">用户名：</td>
            <td><asp:Label ID="UName_L" runat="server" /></td>
        </tr>
       <tr><td class="text-right">提现金额：</td><td><asp:Label runat="server" ID="Money_L"></asp:Label></td></tr>
       <tr runat="server" id="reject_tr"><td class="text-right">提示：</td><td class="rd_red">拒绝提现后,预扣的金额将会返还给用户
           </td></tr>
        <tr>
            <td class="text-right">备注信息：</td>
            <td>
                <asp:TextBox ID="BackDecs_T" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control txtbody"></asp:TextBox></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:Button ID="Audit_L" runat="server" OnClick="Audit_L_Click" CssClass="btn btn-info" />
                <button type="button" onclick="parent.diag.CloseModal();" class="btn btn-info">取消</button>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">

</asp:Content>