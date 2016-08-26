using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TrLink : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string toggleActive(int id, bool active)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@Id", id);
        SqlParameter pactive = new SqlParameter("@IsActive", active);
        param.Add(pid);
        param.Add(pactive);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pToggleActiveTrLinks", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }

    [WebMethod]
    public static string getTrLinks(string key, int cityid, DateTime? fromdate, DateTime? todate)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@keyword", key);
        SqlParameter pcityid = new SqlParameter("@cityid", cityid);
        SqlParameter pfromdate = new SqlParameter("@fromdate", fromdate);
        SqlParameter ptodate = new SqlParameter("@todate", todate);
        param.Add(pkey);
        param.Add(pcityid);
        param.Add(pfromdate);
        param.Add(ptodate);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pTrLinkSelect", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string LinksDelete(int id, int? restauId)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@Id", id);
        param.Add(pid);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pTrLinksDelete", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        if (!string.IsNullOrEmpty(json))
        {
            if (restauId.HasValue)
            {
                if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauMenus/") + restauId + "/"))
                {
                    System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauMenus/") + restauId + "/", true);
                }
                if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauDocs/") + restauId + "/"))
                {
                    System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauDocs/") + restauId + "/", true);
                }
                if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauPics/") + restauId + "/"))
                {
                    System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauPics/") + restauId + "/", true);
                }
            }
        }
        return string.Empty;
    }
    [WebMethod]
    public static string getTrLinkData(int id)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@Id", id);
        param.Add(pid);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pEditTrLink", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
}