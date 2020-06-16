using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.BLL;
using ZoomLa.BLL.Helper;
using ZoomLa.BLL.User.Addon;
using ZoomLa.BLL.WxPayAPI;
using ZoomLa.Common;
using ZoomLa.Components;
using ZoomLa.Model;
using ZoomLa.Model.User;
using ZoomLa.SQLDAL;

public partial class wxback : System.Web.UI.Page
{
    B_User buser = new B_User();
    HttpHelper httpHelper = new HttpHelper();
    //进入该页即开始推广,自动创建用户,关联APPID
    protected void Page_Load(object sender, EventArgs e)
    {
        int AppID = DataConverter.CLng(Request.QueryString["appid"]);
        
        B_UserAPP appBll = new B_UserAPP();
        int puid = DataConverter.CLng(Session["WX_PUserID"]);
        string rurl = DataConvert.CStr(Session["WX_R"]);
        
        //if (puid < 1) { function.WriteErrMsg("推荐用户不存在"); }
        M_WX_APPID appMod = new M_WX_APPID();//自行置入缓存,使用时取出
        appMod = WxPayApi.Pay_GetByID(AppID);
		
		if (string.IsNullOrEmpty(rurl))
        {
            string url = HttpUtility.UrlEncode(SiteConfig.SiteInfo.SiteUrl + "/User/");
            rurl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appMod.APPID + "&redirect_uri=" + url + "&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect";
        }
		
        string code = Request["code"];
        string access_token = APIHelper.GetWebResult("https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + appMod.APPID + "&secret=" + appMod.Secret + "&code=" + code + "&grant_type=authorization_code");
        JObject obj = (JObject)JsonConvert.DeserializeObject(access_token);
        JObject userobj = (JObject)JsonConvert.DeserializeObject(APIHelper.GetWebResult("https://api.weixin.qq.com/sns/userinfo?access_token=" + obj["access_token"] + "&openid=" + obj["openid"] + "&lang=zh_CN"));
        string openID = obj["openid"].ToString();
        M_UserAPP umod = appBll.SelModelByOpenID(openID, "wechat");
        M_UserInfo mu = new M_UserInfo();
        if (umod != null)
        {
            mu = buser.SelReturnModel(umod.UserID);
            buser.SetLoginState(mu);
            try
            {
                string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu.UserName + mu.UserID + "/wxheadimg.jpg";
                HttpHelper.DownFile(userobj["headimgurl"].ToString(), vpath);
                mu.UserFace = vpath;
                buser.UpdateByID(mu);
            }
            catch (Exception ex)
            {
                ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
            }
            if (puid > 0 && DataConvert.CLng(mu.ParentUserID) <= 0)
            {
                if (puid == mu.UserID)
                {
                    function.WriteErrMsg("不能绑定自己！");
                }
                else
                {
                    string err = "";
                    if (CheckParentUser(puid, mu.UserID, ref err))
                    {
                        mu.ParentUserID = puid.ToString();
                        buser.UpdateByID(mu);
                    }
                    else
                    {
                        function.WriteErrMsg("绑定失败，错误信息：" + err);
                    }
                }
                
            }
            Response.Redirect(rurl);
        }
        else //新用户则注册
        {
            umod = new M_UserAPP();
            mu.UserName = "wx" + DateTime.Now.ToString("yyyyMMddHHmmss") + function.GetRandomString(2).ToLower();
            mu.UserPwd = StringHelper.MD5(function.GetRandomString(6));
            mu.Email = function.GetRandomString(10) + "@wx.com";
            mu.Question = function.GetRandomString(5);
            mu.Answer = function.GetRandomString(5);
            mu.ParentUserID = puid.ToString();
            mu.TrueName = userobj["nickname"].ToString();
            try
            {
                string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu.UserName + mu.UserID + "/wxheadimg.jpg";
                HttpHelper.DownFile(userobj["headimgurl"].ToString(), vpath);
                mu.UserFace = vpath;
            }
            catch (Exception ex)
            {
                ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
            }
            mu.GroupID=1;
            mu.UserID = buser.Add(mu);

            umod.UserID = mu.UserID;
            umod.SourcePlat = "wechat";
            umod.OpenID = openID;
            appBll.Insert(umod);
            M_Uinfo mubase = new M_Uinfo();
            mubase.UserId = mu.UserID;
            buser.AddBase(mubase);
            //推广人得积分
            if (puid > 0)
            {
                M_UserInfo pmu = buser.SelReturnModel(puid);
                if (!pmu.IsNull)
                {
                    buser.ChangeVirtualMoney(pmu.UserID, new M_UserExpHis()
                    {
                        score = 20,
                        ScoreType = (int)M_UserExpHis.SType.Point,
                        detail = "新用户[" + mu.UserName + "]注册,获得推广积分:" + 20
                    });
                }
            }
            buser.SetLoginState(mu);
            Response.Redirect(rurl);
        }
    }
    /// <summary>
    /// 检测推荐人
    /// </summary>
    /// <param name="puid">推荐人ID</param>
    /// <param name="uid">用户ID,未注册用户为0</param>
    /// <param name="err">错误信息</param>
    /// <returns>true:推荐人信息正常</returns>
    public bool CheckParentUser(int puid, int uid, ref string err)
    {
        //1,数据库中旧数据都是检测过的,不需要重检,所以只需要把好入口,对新用户的检测即可,即新用户的ParentUserID链中,不能有新用户ID
        //2,父ID是单线的不会有枝丫
        //3,子级仅需检测父ID是否包含在其子链当中即可
        M_UserInfo pmu = buser.SelReturnModel(puid);
        M_UserInfo mu = buser.SelReturnModel(uid);
        if (pmu.IsNull) { err = "推荐人不存在"; return false; }
        if (uid > 0 && puid == uid) { err = "推荐人ID不能同于用户ID"; return false; }
        if (!mu.IsNull)//在数据库中已有记录
        {
            //puid的父级链条中不能有该uid存在
            string puids = SelParentTree("ZL_User", "UserID", "ParentUserID", puid);
            string cuids = SelChildTree("ZL_User", "UserID", "ParentUserID", mu.UserID);
            //父级链条中不能包含当前用户ID
            if (!(puids.Split(',').FirstOrDefault(p => p.Equals(mu.UserID.ToString())) == null)) { err = "父级链中有用户[用户名：" + mu.TrueName + "，用户ID：" + mu.UserID + "]存在"; return false; }
            if (!(cuids.Split(',').FirstOrDefault(p => p.Equals(mu.UserID.ToString())) == null)) { err = "子级链中有用户[用户名：" + pmu.TrueName + "，用户ID：" + pmu.UserID + "]存在"; return false; }
            return true;
        }
        return true;
    }
    /// <summary>
    /// 返回父级链,包含起始ID
    /// </summary>
    /// <param name="tbname">ZL_Node</param>
    /// <param name="pk">NodeID</param>
    /// <param name="pfield">示例:ParentID</param>
    /// <param name="startid">起始的ID值,如UserID的值</param>
    /// <param name="ids">返回的层级IDS</param>
    /// <returns></returns>
    private string SelParentTree(string tbname, string pk, string pfield, int startID)
    {
        string ids = "";
        if (startID < 1) { return ids; }
        string sql = "WITH f AS(SELECT * FROM {ZL_Node} WHERE {NodeID}=" + startID + " UNION ALL SELECT A.* FROM {ZL_Node} A, f WHERE a.{NodeID}=f.{ParentID}) SELECT * FROM {ZL_Node} WHERE {NodeID} IN(SELECT {NodeID} FROM f)";
        string oracle = "SELECT * FROM {tbname} START WITH {NodeID} =" + startID + " CONNECT BY PRIOR {ParentID} = {NodeID}";
        sql = sql.Replace("{ZL_Node}", tbname).Replace("{NodeID}", pk).Replace("{ParentID}", pfield);
        DataTable dt = DBCenter.ExecuteTable(DBCenter.GetSqlByDB(sql, oracle));
        foreach (DataRow dr in dt.Rows)
        {
            ids += dr[pk] + ",";
        }
        return ids.Trim(',');
    }
    /// <summary>
    /// 获取子级链,包含起始ID
    /// </summary>
    private string SelChildTree(string tbname, string pk, string pfield, int startID)
    {
        string ids = "";
        string sql = "WITH TREE as(SELECT * FROM {ZL_Node} WHERE {ParentID}=" + startID + " UNION ALL SELECT a.* FROM {ZL_Node} a JOIN Tree b on a.{ParentID}=b.{NodeID}) SELECT {NodeID} FROM Tree AS A";
        sql = sql.Replace("{ZL_Node}", tbname).Replace("{NodeID}", pk).Replace("{ParentID}", pfield);
        DataTable dt = DBCenter.ExecuteTable(sql);
        foreach (DataRow dr in dt.Rows)
        {
            ids += dr[pk] + ",";
        }
        return ids.Trim(',');
    }
}