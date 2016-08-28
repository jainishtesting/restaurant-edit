using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Data.SqlClient;

public partial class Resturent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string getCity()
    {
        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pmstMainSubCategorySelect", null, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getState()
    {
        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pmstMainCategorySelect", null, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getHighlights()
    {
        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pmstHighlights", null, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getCousines()
    {
        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pmstCousines", null, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getCityByState(int stateid)
    {
        DataAccessCls dObj = new DataAccessCls();
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@stateid", stateid);
        param.Add(pkey);
        DataTable dt = dObj.RunSP_ReturnDT("pmstMainSubCategorySelectByCategoryId", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getHighlightsByRestau(int restauId)
    {
        DataAccessCls dObj = new DataAccessCls();
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@restauId", restauId);
        param.Add(pkey);
        DataTable dt = dObj.RunSP_ReturnDT("pmstHighlightsByRestauId", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getRestauMenusByRestau(int restauId)
    {
        DataAccessCls dObj = new DataAccessCls();
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@restauId", restauId);
        param.Add(pkey);
        DataTable dt = dObj.RunSP_ReturnDT("prcGetRestauMenus", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getRestauPicsByRestau(int restauId)
    {
        DataAccessCls dObj = new DataAccessCls();
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@restauId", restauId);
        param.Add(pkey);
        DataTable dt = dObj.RunSP_ReturnDT("prcGetRestauPics", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getRestauDocsByRestau(int restauId)
    {
        DataAccessCls dObj = new DataAccessCls();
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@restauId", restauId);
        param.Add(pkey);
        DataTable dt = dObj.RunSP_ReturnDT("prcGetRestauDocs", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string updateHighlights(string highlights, int restauId)
    {
        if (!string.IsNullOrEmpty(highlights))
        {
            string[] highlights1 = highlights.Split(',');
            List<SqlParameter> delparam = new List<SqlParameter>();
            SqlParameter restauIdd = new SqlParameter("@restauId", restauId);
            delparam.Add(restauIdd);
            DataAccessCls ddlObj = new DataAccessCls();
            ddlObj.RunSP_ReturnDT("pmstDeleteHighlightsByRestauId", delparam, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());

            foreach (var highlight in highlights1)
            {
                List<SqlParameter> highparam = new List<SqlParameter>();
                SqlParameter hId = new SqlParameter("@RestaurantId", restauId);
                SqlParameter hhId = new SqlParameter("@HighlightId", highlight);
                List<SqlParameter> delparam1 = new List<SqlParameter>();
                delparam1.Add(hId);
                delparam1.Add(hhId);

                DataAccessCls ddlObj1 = new DataAccessCls();
                ddlObj1.RunSP_ReturnDT("pInsertHighlights", delparam1, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
            }
        }
        string json = "success";
        return json;
    }
    [WebMethod]
    public static string getRestaurants(string key, int cityid, DateTime? fromdate, DateTime? todate)
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
        DataTable dt = dObj.RunSP_ReturnDT("pRestaurantsSelect", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }

    [WebMethod]
    public static string updateValues(string fieldname, string value, int id)
    {
        HttpContext.Current.Session["UserId"] = 2;
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pkey = new SqlParameter("@fieldname", fieldname);
        SqlParameter pcityid = new SqlParameter("@value", value);
        SqlParameter pfromdate = new SqlParameter("@Id", id);
        SqlParameter pUserId = new SqlParameter("@UserId", HttpContext.Current.Session["UserId"]);
        SqlParameter ptodate = new SqlParameter("@LinkMain", HttpContext.Current.Request.Url + "?LinkId=" + id);
        param.Add(pkey);
        param.Add(pcityid);
        param.Add(pfromdate);
        param.Add(ptodate);
        param.Add(pUserId);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("sp_UpdateFields", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
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
        DataTable dt = dObj.RunSP_ReturnDT("pToggleActiveRestaurants", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string getRestaurentData(int id)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@restauId", id);
        param.Add(pid);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pEditRestau", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }
    [WebMethod]
    public static string RestaurantsDelete(int id)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@Id", id);
        param.Add(pid);

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pRestaurantsDelete", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        if (!string.IsNullOrEmpty(json))
        {
            if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauMenus/") + id + "/"))
            {
                System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauMenus/") + id + "/", true);
            }
            if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauDocs/") + id + "/"))
            {
                System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauDocs/") + id + "/", true);
            }
            if (System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/Upload/RestauPics/") + id + "/"))
            {
                System.IO.Directory.Delete(HttpContext.Current.Server.MapPath("~/Upload/RestauPics/") + id + "/", true);
            }
        }
        return json;
    }

    [WebMethod]
    public static string RestaurantsDeleteImage(int id, string type, string path)
    {
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter pid = new SqlParameter("@Id", id);
        SqlParameter ptype = new SqlParameter("@type", type);

        param.Add(pid);
        param.Add(ptype);
        if (System.IO.File.Exists(HttpContext.Current.Server.MapPath(path)))
        {
            System.IO.File.Delete(HttpContext.Current.Server.MapPath(path));
        }

        DataAccessCls dObj = new DataAccessCls();
        DataTable dt = dObj.RunSP_ReturnDT("pRestaurantsDeleteImage", param, ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);
        return json;
    }

}
