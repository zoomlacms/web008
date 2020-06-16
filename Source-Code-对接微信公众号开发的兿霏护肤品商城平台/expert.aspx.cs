using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using ZoomLa.Common;
using System.Xml;
using ZoomLa.BLL;
using ZoomLa.Model;
using Newtonsoft.Json;
using System.Web.Security;
using ZoomLa.Components;
using ZoomLa.Model.Plat;
using ZoomLa.BLL.Plat;
using Newtonsoft.Json.Linq;
using ZoomLa.BLL.WxPayAPI;
using ZoomLa.Model.User;
using ZoomLa.BLL.User.Addon;

public partial class expert : System.Web.UI.Page
{
    public B_User buser = new B_User();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            M_UserInfo mu = buser.GetLogin();
            M_UserInfo expmu = new M_UserInfo();
            int expid = DataConverter.CLng(Request.QueryString["expid"]);
            int appid = DataConverter.CLng(Request.QueryString["appid"]);
            if (mu != null && mu.UserID > 0)
            {
                if (expid > 0)
                {
                    expmu = buser.SeachByID(expid);
                    if(expmu != null && expmu.UserID > 0)
                    {
						ExpName_L.Text = expmu.TrueName;
                        ExpFace.ImageUrl = expmu.UserFace;
                        ExpComp_L.Text = expmu.CompanyName;
                        ExpJob_L.Text = buser.GetUserBaseByuserid(expmu.UserID).HomePage;
                        try
                        {
                            if (appid == 0) { appid = 1; }
                            WxAPI wxapi = WxAPI.Code_Get(appid);
                            string jsapi_ticket1 = APIHelper.GetWebResult("https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" + wxapi.AccessToken + "&type=jsapi", "POST", "{\"action_name\":\"QR_LIMIT_STR_SCENE\",\"action_info\":{\"scene\":{\"scene_str\":\"" + expmu.UserID + "\"}}}");
                            if (jsapi_ticket1 != "")
                            {
                                JObject jsapi_obj1 = (JObject)JsonConvert.DeserializeObject(jsapi_ticket1);
                                Image1.ImageUrl = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + jsapi_obj1["ticket"];
                            }
                        }
                        catch (Exception ex)
                        {
                            function.WriteErrMsg(ex.Message);
                        }
                    }
                    else
                    {
                        function.WriteErrMsg("专家不存在！");
                    }
                }
                else
                {
                    function.WriteErrMsg("参数错误！");
                }
            }
            else
            {
                Response.Redirect("/wxpromo.aspx?r=" + Request.RawUrl);
            }
        }
    }
}