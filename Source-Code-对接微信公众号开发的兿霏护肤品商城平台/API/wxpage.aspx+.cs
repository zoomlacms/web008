using System;
using System.Linq;
using System.Web;
using ZoomLa.Common;
using ZoomLa.BLL;
using ZoomLa.Model;
using Newtonsoft.Json;
using System.Web.Security;
using ZoomLa.Components;
using ZoomLa.Model.Plat;
using ZoomLa.BLL.Plat;
using ZoomLa.Model.User;
using ZoomLa.BLL.User.Addon;
using ZoomLa.SQLDAL;
using System.Data;
using ZoomLa.BLL.Helper;

public partial class API_wxpage : System.Web.UI.Page
{
    B_WX_User wxuserBll = new B_WX_User();
    B_WX_ReplyMsg rpBll = new B_WX_ReplyMsg();
    B_WX_APPID appBll = new B_WX_APPID();
    B_UserAPP uappBll = new B_UserAPP();
    B_User buser = null;
    WxAPI api = null;
    string baseUrl = SiteConfig.SiteInfo.SiteUrl;
    //-----------------用于debug
    string errmsg = "";
    string requesdata = "";
    protected void Page_Load(object sender, EventArgs e)
    {
		
        string echoString = HttpContext.Current.Request.QueryString["echoStr"];
        string signature = HttpContext.Current.Request.QueryString["signature"];
        string timestamp = HttpContext.Current.Request.QueryString["timestamp"];
        string nonce = HttpContext.Current.Request.QueryString["nonce"];
        if (Request.HttpMethod == "GET") { Auth(); return; }
        try
        {
            buser = new B_User(HttpContext.Current);
            requesdata = GetXml();
            //requesdata = "<xml><ToUserName><![CDATA[gh_33273dafc0e4]]></ToUserName> <FromUserName><![CDATA[olwfpsvje_OHogJ8rOANahcqSijk]]></FromUserName> <CreateTime>1434081760</CreateTime> <MsgType><![CDATA[text]]></MsgType> <Content><![CDATA[pic]]></Content> <MsgId>6159334259197323209</MsgId> </xml>";
            if (string.IsNullOrEmpty(requesdata)) { return; }
            M_WxTextMsg reqMod = new M_WxTextMsg(requesdata);
            //获取需要返回的公众号
            M_WX_APPID appmod = appBll.GetAppByWxNo(reqMod.ToUserName);
            if (appmod == null) { throw new Exception("目标公众号[" + reqMod.ToUserName + "]不存在"); }
            api = WxAPI.Code_Get(appmod);
            errmsg += "动作:" + reqMod.MsgType;
            switch (reqMod.MsgType)
            {
                case "event"://事件--关注处理,后期扩展单击等
                    {
                        M_WxImgMsg msgMod = new M_WxImgMsg();
                        msgMod.ToUserName = reqMod.FromUserName;
                        msgMod.FromUserName = reqMod.ToUserName;
                        WxEventHandler(reqMod);//系统事件处理
                        //登录检测,可按需取消或修改位置
                        //M_UserInfo mu = UserBindCheck(reqMod);
                        //WxMenuBtnHandler(reqMod, msgMod, mu);
                    }
                    break;
                case "text"://接收文本消息
                    {
                        string xml = UserTextDeal(reqMod);
                        RepToClient(xml);
                    }
                    break;
            }
        }
        catch (Exception ex) { ZLLog.L("微信报错," + errmsg + ",数据:" + requesdata + ",原因:" + ex.Message); }
    }
    private void RepToClient(string xml)
    {
        //自返回,用于避免线程中断报错
        Response.Clear();
        Response.Write(xml);
        Response.Flush();
        //Response.End();
    }
    //检测用户是否关联用户,未关联用户则直接返回,否则返回用户信息
    //帐户在所有公众号通用
    public M_UserInfo UserBindCheck(M_WxTextMsg reqMod)
    {
        B_User_Token tokenBll = new B_User_Token();
        M_User_Token tokenMod = tokenBll.SelByOpenID(reqMod.FromUserName, "WX");
        M_UserInfo mu = new M_UserInfo(true);
        if (tokenMod == null)
        {

        }
        else { mu = buser.SelReturnModel(tokenMod.uid); }
        return mu;
    }
    /// <summary>
    /// 系统事件,如订阅等处理
    /// </summary>
    public void WxEventHandler(M_WxTextMsg reqMod)
    {
        M_WX_User userMod = null;
        errmsg += ",事件:" + reqMod.Event;
        switch (reqMod.Event.ToLower())
        {
            case "subscribe":
                userMod = api.GetWxUserModel(reqMod.FromUserName);
                userMod.CDate = DateTime.Now;
                userMod.AppId = api.AppId.ID;
                wxuserBll.Insert(userMod);
                M_WxImgMsg msgmod = JsonConvert.DeserializeObject<M_WxImgMsg>(api.AppId.WelStr);
                msgmod.ToUserName = reqMod.FromUserName;
                msgmod.FromUserName = reqMod.ToUserName;

                int pid = DataConvert.CLng(reqMod.EventKey.Replace("qrscene_", ""));
                M_UserAPP uappMod1 = new M_UserAPP();

                M_UserInfo mu1 = new M_UserInfo();
                M_WX_User wuserMod = new M_WX_User();
                M_Uinfo mubase = new M_Uinfo();
                uappMod1 = uappBll.SelModelByOpenID(reqMod.FromUserName, "wechat");
                wuserMod = api.GetWxUserModel(reqMod.FromUserName);
                if (uappMod1 != null)
                {
                    mu1 = buser.GetUserByUserID(uappMod1.UserID);
                    if (mu1 != null && mu1.UserID > 0)
                    {
                        mu1.TrueName = wuserMod.Name;
                        try
                        {
                            string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu1.UserName + mu1.UserID + "/wxheadimg.jpg";
                            HttpHelper.DownFile(wuserMod.HeadImgUrl, vpath);
                            mu1.UserFace = vpath;
                        }
                        catch (Exception ex)
                        {
                            ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
                        }
                        
                        mu1.GroupID = 1;
                        buser.UpdateByID(mu1);
                    }
                    else
                    {
                        mu1.UserName = "wx" + DateTime.Now.ToString("yyyyMMddHHmmss") + function.GetRandomString(2).ToLower();
                        mu1.UserPwd = StringHelper.MD5(function.GetRandomString(6));
                        mu1.Email = function.GetRandomString(10) + "@wx.com";
                        mu1.Question = function.GetRandomString(5);
                        mu1.Answer = function.GetRandomString(5);
                        mu1.TrueName = wuserMod.Name;
                        mu1.GroupID = 1;
                        try
                        {
                            string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu1.UserName + mu1.UserID + "/wxheadimg.jpg";
                            HttpHelper.DownFile(wuserMod.HeadImgUrl, vpath);
                            mu1.UserFace = vpath;
                        }
                        catch (Exception ex)
                        {
                            ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
                        }
                       
                        mu1.UserID = buser.Add(mu1);

                        uappMod1.UserID = mu1.UserID;
                        uappMod1.SourcePlat = "wechat";
                        uappMod1.OpenID = reqMod.FromUserName;
                        uappBll.UpdateByID(uappMod1);
                        mubase.UserId = mu1.UserID;
                        buser.AddBase(mubase);
                    }
                }
                else
                {
                    uappMod1 = new M_UserAPP();
                    mu1.UserName = "wx" + DateTime.Now.ToString("yyyyMMddHHmmss") + function.GetRandomString(2).ToLower();
                    mu1.UserPwd = StringHelper.MD5(function.GetRandomString(6));
                    mu1.Email = function.GetRandomString(10) + "@wx.com";
                    mu1.Question = function.GetRandomString(5);
                    mu1.Answer = function.GetRandomString(5);
                    mu1.TrueName = wuserMod.Name;
                    mu1.GroupID = 1;
                    try
                    {
                        string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu1.UserName + mu1.UserID + "/wxheadimg.jpg";
                        HttpHelper.DownFile(wuserMod.HeadImgUrl, vpath);
                        mu1.UserFace = vpath;
                    }
                    catch (Exception ex)
                    {
                        ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
                    }
                    
                    mu1.UserID = buser.Add(mu1);

                    uappMod1.UserID = mu1.UserID;
                    uappMod1.SourcePlat = "wechat";
                    uappMod1.OpenID = reqMod.FromUserName;
                    uappBll.Insert(uappMod1);
                    mubase.UserId = mu1.UserID;
                    buser.AddBase(mubase);
                }

                if (string.IsNullOrEmpty(msgmod.Articles[0].PicUrl)) //如未设置图片则以纯文本格式发送,纯文本支持内置超链接
                {
                    M_WxTextMsg textMod = ImageToText(msgmod);
                    RepToClient(textMod.ToXML());
                }
                else
                {
                    RepToClient(msgmod.ToXML());
                }
                //关注时发送多条信息
                if (pid > 0)
                    System.Threading.ThreadPool.QueueUserWorkItem(new System.Threading.WaitCallback(SendMsg), reqMod);
                //关注时发送多条信息
                //System.Threading.ThreadPool.QueueUserWorkItem(new System.Threading.WaitCallback(SendMsg), reqMod);
                break;
            case "unsubscribe":
                wxuserBll.DelByOpenid(api.AppId.ID, reqMod.FromUserName);
                break;
            case "location"://用户进入公众号(包含定位信息)
                break;
            case "scan":
                M_UserAPP uappMod = new M_UserAPP();
                M_UserInfo mu = new M_UserInfo();
                M_WxTextMsg textMod2 = new M_WxTextMsg();
                M_WX_User wuserMod1 = api.GetWxUserModel(reqMod.FromUserName);
                M_Uinfo mubase1 = new M_Uinfo();

                textMod2.FromUserName = reqMod.ToUserName;
                textMod2.ToUserName = reqMod.FromUserName;
                textMod2.MsgType = "text";
                textMod2.Content = "";
                uappMod = uappBll.SelModelByOpenID(reqMod.FromUserName, "wechat");
                if (uappMod != null)
                {
                    mu = buser.GetUserByUserID(uappMod.UserID);
                    M_UserInfo pmu = buser.GetUserByUserID(DataConvert.CLng(reqMod.EventKey));
                    if (mu != null && mu.UserID > 0)
                    {
                        if (DataConvert.CLng(mu.ParentUserID) > 0)
                        {
                            textMod2.Content = "您已绑定了专家不能重复绑定！";
                            RepToClient(textMod2.ToXML());
                        }
                        else
                        {
                            if (mu.UserID == DataConvert.CLng(reqMod.EventKey))
                            {
                                textMod2.Content = "您扫描的是您自己的二维码！";
                            }
                            else
                            {
                                mu.ParentUserID = DataConvert.CLng(reqMod.EventKey).ToString();
                                if (pmu != null && pmu.UserID > 0)
                                {
                                    string err = "";
                                    try
                                    {
                                        if (CheckParentUser(pmu.UserID, mu.UserID, ref err))
                                        {
                                            mu.ParentUserID = pmu.UserID.ToString();
                                            if (buser.UpdateByID(mu))
                                                textMod2.Content = "您成功绑定了专家：" + pmu.TrueName + "！";

                                            else
                                                textMod2.Content = "绑定专家失败！";
                                        }
                                        else
                                        {
                                            textMod2.Content = "绑定专家失败,错误信息：" + err;
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        textMod2.Content = "绑定专家失败,错误信息：" + pmu.TrueName + "的推荐关系有循环！";
                                    }
                                }
                                else
                                {
                                    textMod2.Content = "绑定专家失败,专家不存在！";
                                }
                            }
                            RepToClient(textMod2.ToXML());
                        }
                    }
                }
                else
                {
                    uappMod1 = new M_UserAPP();
                    mu.UserName = "wx" + DateTime.Now.ToString("yyyyMMddHHmmss") + function.GetRandomString(2).ToLower();
                    mu.UserPwd = StringHelper.MD5(function.GetRandomString(6));
                    mu.Email = function.GetRandomString(10) + "@wx.com";
                    mu.Question = function.GetRandomString(5);
                    mu.Answer = function.GetRandomString(5);
                    mu.TrueName = wuserMod1.Name;
                    mu.GroupID = 1;
                    try
                    {
                        string vpath = SiteConfig.SiteOption.UploadDir + "User/" + mu.UserName + mu.UserID + "/wxheadimg.jpg";
                        HttpHelper.DownFile(wuserMod1.HeadImgUrl, vpath);
                        mu.UserFace = vpath;
                    }
                    catch (Exception ex)
                    {
                        ZLLog.L("微信获取头衔出错,原因:" + ex.Message);
                    }
                    
                    M_UserInfo pmu = buser.GetUserByUserID(DataConvert.CLng(reqMod.EventKey));
                    if (pmu != null && pmu.UserID > 0)
                    {
                        mu.ParentUserID = reqMod.EventKey;
                    }
                    mu.UserID = buser.Add(mu);

                    uappMod1.UserID = mu.UserID;
                    uappMod1.SourcePlat = "wechat";
                    uappMod1.OpenID = reqMod.FromUserName;
                    uappBll.Insert(uappMod1);
                    mubase1.UserId = mu.UserID;
                    buser.AddBase(mubase1);

                    if (pmu != null && pmu.UserID > 0)
                    {
                        textMod2.Content = "您成功绑定了专家：" + pmu.TrueName + "！";
                        RepToClient(textMod2.ToXML());
                    }
                }
                break;
            default:
                break;
        }
    }
    private void SendMsg(Object info)
    {
        try
        {
            M_WxTextMsg reqMod = (M_WxTextMsg)info;
            System.Threading.Thread.Sleep(1000);//延迟1秒,避免先于欢迎消息
            M_WX_APPID appmod = new B_WX_APPID().GetAppByWxNo(reqMod.ToUserName);
            if (appmod == null) { throw new Exception("目标公众号[" + reqMod.ToUserName + "]不存在"); }
            string msgStr = "";
            M_UserAPP uappMod = new M_UserAPP();
            B_UserAPP uappBll = new B_UserAPP();
            M_UserInfo mu = new M_UserInfo();
            uappMod = uappBll.SelModelByOpenID(reqMod.FromUserName, "wechat");
            if (uappMod != null)
            {
                mu = buser.GetUserByUserID(uappMod.UserID);
                M_UserInfo pmu = buser.GetUserByUserID(DataConvert.CLng(reqMod.EventKey.Replace("qrscene_", "")));
                if (mu != null && mu.UserID > 0)
                {
                    if (DataConvert.CLng(mu.ParentUserID) > 0)
                    {
                        msgStr = "您已绑定了专家不能重复绑定！";
                    }
                    else
                    {
                        if (mu.UserID == DataConvert.CLng(reqMod.EventKey.Replace("qrscene_", "")))
                        {
                            msgStr = "您扫描的是您自己的二维码！";
                        }
                        else
                        {

                            if (pmu != null && pmu.UserID > 0)
                            {
                                string err = "";
                                try
                                {
                                    if (CheckParentUser(pmu.UserID, mu.UserID, ref err))
                                    {
                                        mu.ParentUserID = pmu.UserID.ToString();
                                        if (buser.UpdateByID(mu))
                                            msgStr = "您成功绑定了专家：" + pmu.TrueName + "！";

                                        else
                                            msgStr = "绑定专家失败！";
                                    }
                                    else
                                    {
                                        msgStr = "绑定专家失败,错误信息：" + err;
                                    }
                                }
                                catch (Exception ex)
                                {
                                    msgStr = "绑定专家失败,错误信息：" + pmu.TrueName + "的推荐关系有循环！";
                                }
                            }
                            else
                            {
                                msgStr = "绑定专家失败,专家不存在！";
                            }
                        }
                    }
                }
                WxAPI.Code_Get(appmod).SendMsg(reqMod.FromUserName, msgStr);
            }
        }
        catch (Exception ex) { ZLLog.L("微信多信息出错,原因:" + ex.Message); }
    }
    //private void SendMsg(Object info)
    //{
    //    try
    //    {
    //        M_WxTextMsg reqMod = (M_WxTextMsg)info;
    //        System.Threading.Thread.Sleep(1000);//延迟1秒,避免先于欢迎消息
    //        M_WX_APPID appmod = new B_WX_APPID().GetAppByWxNo(reqMod.ToUserName);
    //        if (appmod == null) { throw new Exception("目标公众号[" + reqMod.ToUserName + "]不存在"); }
    //        WxAPI.Code_Get(appmod).SendMsg(reqMod.FromUserName, "test");
    //    }
    //    catch (Exception ex) { ZLLog.L("微信多信息出错,原因:" + ex.Message); }
    //}
    /// <summary>
    /// 自定义单击事件处理,按需扩展
    /// </summary>
    public void WxMenuBtnHandler(M_WxTextMsg reqMod, M_WxImgMsg msgMod, M_UserInfo mu)
    {
        //switch (reqMod.Event)
        //{
        //    case "CLICK":
        //        break;
        //}
        //<xml><ToUserName><![CDATA[gh_02d7c9c8ec54]]></ToUserName>
        //<FromUserName><![CDATA[obaF_jigkjUCPDpFeCMx25TV7qQk]]></FromUserName>
        //<CreateTime>1450326669</CreateTime>
        //<MsgType><![CDATA[event]]></MsgType>
        //<Event><![CDATA[CLICK]]></Event>
        //<EventKey><![CDATA[menu_0_btn_0]]></EventKey>
        //</xml>
        switch (reqMod.EventKey)
        {
            case "menu_0_btn_0"://项目进度
                {
                    msgMod.Articles.Add(new M_WXImgItem()
                    {
                        Title = mu.UserName + "[项目进度]的信息1",
                        Description = "点击访问[项目进度]信息",
                        //PicUrl=baseUrl+"/Template/Ke/style/images/login1.png",
                        Url = baseUrl + "/User/Default"
                    });
                }
                break;
            case "menu_0_btn_1":
                {
                    M_WxTextMsg textMod = new M_WxTextMsg()
                    {
                        MsgType = "text",
                        CreateTime = reqMod.CreateTime,
                        Content = "点击访问[<a href='" + baseUrl + "/User/Default'>发布项目</a>]信息",
                        FromUserName = msgMod.FromUserName,
                        ToUserName = msgMod.ToUserName
                    };
                    RepToClient(textMod.ToXML());
                }
                break;
        }
        RepToClient(msgMod.ToXML());
    }
    //用户文件信息处理
    public string UserTextDeal(M_WxTextMsg reqMod)
    {
        M_WX_ReplyMsg rpMod = rpBll.SelByFileAndDef(appBll.GetAppByWxNo(reqMod.ToUserName).ID, reqMod.Content);
        M_WxImgMsg msgMod = new M_WxImgMsg();
        msgMod.ToUserName = reqMod.FromUserName;
        msgMod.FromUserName = reqMod.ToUserName;
        //如果未匹配到则直接返回
        string result = "";
        if (rpMod == null)
        {
            //未匹配则不响应
            //msgMod.Articles.Add(new M_WXImgItem() { Title = "未找到相关联的操作" });
            //result = msgMod.ToXML();
        }
        else//如果匹配到
        {
            M_WXImgItem item = JsonConvert.DeserializeObject<M_WXImgItem>(rpMod.Content);
            if (item.Description.Contains("{$UserName}"))
            {
                M_WX_User wuserMod = api.GetWxUserModel(reqMod.FromUserName);
                item.PicUrl = wuserMod.HeadImgUrl;
                item.Description = item.Description.Replace("{$UserName}", wuserMod.Name);
            }
            msgMod.Articles.Add(item);
            switch (rpMod.MsgType)
            {
                case "0":
                    M_WxTextMsg textMod = ImageToText(msgMod);
                    result = textMod.ToXML();
                    break;
                case "1":
                    result = msgMod.ToXML();
                    break;
            }
        }
        return result;
    }
    //用于处理微信初次验证
    private void Auth()
    {
        string echoString = HttpContext.Current.Request.QueryString["echoStr"];
        string signature = HttpContext.Current.Request.QueryString["signature"];
        string timestamp = HttpContext.Current.Request.QueryString["timestamp"];
        string nonce = HttpContext.Current.Request.QueryString["nonce"];
        ZLLog.L(echoString + "|||" + signature + "|||" + timestamp + "|||" + nonce);
        Response.Clear();
        Response.Write(echoString); Response.Flush(); Response.End();
        //string token = "demo";
        //if (CheckSignature(token, signature, timestamp, nonce))
        //{
        //    if (!string.IsNullOrEmpty(echoString))
        //    {
        //        HttpContext.Current.Response.Write(echoString);
        //        HttpContext.Current.Response.End();
        //    }
        //}
    }
    //------------------Tools
    private string GetXml()
    {
        byte[] inputdata = new byte[Request.InputStream.Length];
        Request.InputStream.Read(inputdata, 0, inputdata.Length);
        return System.Text.Encoding.UTF8.GetString(inputdata);
    }
    // 验证微信签名
    private bool CheckSignature(string token, string signature, string timestamp, string nonce)
    {
        string[] ArrTmp = { token, timestamp, nonce };
        Array.Sort(ArrTmp);
        string tmpStr = string.Join("", ArrTmp);

        tmpStr = FormsAuthentication.HashPasswordForStoringInConfigFile(tmpStr, "SHA1");
        tmpStr = tmpStr.ToLower();

        if (tmpStr == signature)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //图文消息转文本(存储时以图片消息为准)
    //文本的优点在于,可以内置超链接
    private M_WxTextMsg ImageToText(M_WxImgMsg msgmod)
    {
        M_WxTextMsg textMod = new M_WxTextMsg();
        textMod.ToUserName = msgmod.ToUserName;
        textMod.FromUserName = msgmod.FromUserName;
        textMod.Content = msgmod.Articles[0].Description;
        textMod.CreateTime = DateTime.Now.Millisecond;
        textMod.MsgType = "text";
        return textMod;
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
            if (!(puids.Split(',').FirstOrDefault(p => p.Equals(mu.UserID.ToString())) == null)) { err = "父级链中有用户[" + mu.UserName + "]存在"; return false; }
            if (!(cuids.Split(',').FirstOrDefault(p => p.Equals(mu.UserID.ToString())) == null)) { err = "子级链中有用户[" + pmu.UserName + "]存在"; return false; }
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