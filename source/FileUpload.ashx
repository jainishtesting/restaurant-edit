<%@ WebHandler Language="C#" Class="FileUpload" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;

public class FileUpload : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        var files = context.Request.Files;
        var data = context.Request.Form;
        List<SqlParameter> param = new List<SqlParameter>();
        SqlParameter Id = new SqlParameter("@Id", data["hdnId"]);
        SqlParameter userid = new SqlParameter("@userid", data["hdnUserId"]);
        SqlParameter name = new SqlParameter("@name", data["txtName"]);
        SqlParameter address = new SqlParameter("@address", data["txtAddress"]);
        SqlParameter stateid = new SqlParameter("@stateid", data["txtState"]);
        SqlParameter cityid = new SqlParameter("@cityid", data["txtCityEdit"]);
        SqlParameter picode = new SqlParameter("@picode", data["txtPinCode"]);
        SqlParameter contactno = new SqlParameter("@contactno", data["txtContactNo"]);
        SqlParameter website = new SqlParameter("@website", data["txtWebAddress"]);
        SqlParameter openingtime = new SqlParameter("@openingtime", data["txtOpeningTime"]);
        SqlParameter closingtime = new SqlParameter("@closingtime", data["txtClosingTime"]);
        SqlParameter lat = new SqlParameter("@lat", null);
        SqlParameter longi = new SqlParameter("@long", null);
        SqlParameter cuisine = new SqlParameter("@cuisine", data["txtCuisine"]);
        SqlParameter LinkMain = new SqlParameter("@LinkMain", context.Request.Url + "?LinkId=" + data["hdnId"]);

        SqlParameter payment = new SqlParameter("@payment", data["payment"]);
        SqlParameter price = new SqlParameter("@price", data["txtPrice"]);
        SqlParameter reservation = new SqlParameter("@reservation", data["reservation"]);
        param.Add(Id);
        param.Add(userid);
        param.Add(LinkMain);
        param.Add(name);
        param.Add(address);
        param.Add(stateid);
        param.Add(cityid);
        param.Add(cuisine);
        
        param.Add(picode);
        param.Add(contactno);
        param.Add(website);
        param.Add(price);
        param.Add(openingtime);
        param.Add(closingtime);
        param.Add(lat);
        param.Add(longi);
        param.Add(payment);
        param.Add(reservation);

        DataAccessCls dObj = new DataAccessCls();
        System.Data.DataTable dt = dObj.RunSP_ReturnDT("pDataUpdates", param, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
        string json = JsonConvert.SerializeObject(dt);

        string highlights = string.Empty;

        if (data["highlights"] != null)
        {
            highlights = data["highlights"];
            if (!string.IsNullOrEmpty(highlights))
            {
                string[] highlights1 = highlights.Split(',');
                List<SqlParameter> delparam = new List<SqlParameter>();
                SqlParameter restauId = new SqlParameter("@restauId", data["hdnId"]);
                delparam.Add(restauId);
                DataAccessCls ddlObj = new DataAccessCls();
                ddlObj.RunSP_ReturnDT("pmstDeleteHighlightsByRestauId", delparam, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());

                foreach (var highlight in highlights1)
                {
                    List<SqlParameter> highparam = new List<SqlParameter>();
                    SqlParameter hId = new SqlParameter("@RestaurantId", data["hdnId"]);
                    SqlParameter hhId = new SqlParameter("@HighlightId", highlight);
                    List<SqlParameter> delparam1 = new List<SqlParameter>();
                    delparam1.Add(hId);
                    delparam1.Add(hhId);

                    DataAccessCls ddlObj1 = new DataAccessCls();
                    ddlObj1.RunSP_ReturnDT("pInsertHighlights", delparam1, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
                }
            }
        }

        if (files.Count > 0)
        {
            foreach (var file in files)
            {
                if (file != null)
                {
                    if (file.ToString().Contains("filemenus"))
                    {
                        if (!string.IsNullOrEmpty(context.Request.Files[file.ToString()].FileName))
                        {
                            if (!Directory.Exists(context.Server.MapPath("~/Upload/RestauMenus/") + data["hdnId"]))
                            {
                                Directory.CreateDirectory(context.Server.MapPath("~/Upload/RestauMenus/") + data["hdnId"]);
                            }
                            string fileName = Guid.NewGuid().ToString().Substring(0, 6) + "_" + context.Request.Files[file.ToString()].FileName;
                            List<SqlParameter> docparam = new List<SqlParameter>();
                            SqlParameter RestaurantId = new SqlParameter("@RestaurantId", data["hdnId"]);
                            SqlParameter FileName = new SqlParameter("@FileName", fileName);
                            SqlParameter date = new SqlParameter("@date", DateTime.Now);
                            SqlParameter AbsolutePath = new SqlParameter("@AbsolutePath", "~/Upload/RestauMenus/" + data["hdnId"] + "/" + fileName);
                            docparam.Add(RestaurantId);
                            docparam.Add(FileName);
                            docparam.Add(AbsolutePath);
                            docparam.Add(date);
                            DataAccessCls docObj = new DataAccessCls();
                            System.Data.DataTable dt1 = docObj.RunSP_ReturnDT("pInsertRestauDocs", docparam, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
                            string json2 = JsonConvert.SerializeObject(dt1);
                            try
                            {
                                context.Request.Files[file.ToString()].SaveAs(context.Server.MapPath("~/Upload/RestauMenus/") + data["hdnId"] + "/" + fileName);
                            }
                            catch (Exception ex)
                            {

                            }
                        }
                    }
                    else if (file.ToString().Contains("filedocs"))
                    {
                        if (!string.IsNullOrEmpty(context.Request.Files[file.ToString()].FileName))
                        {
                            if (!Directory.Exists(context.Server.MapPath("~/Upload/RestauDocs/") + data["hdnId"]))
                            {
                                Directory.CreateDirectory(context.Server.MapPath("~/Upload/RestauDocs/") + data["hdnId"]);
                            }
                            string fileName = Guid.NewGuid().ToString().Substring(0, 6) + "_" + context.Request.Files[file.ToString()].FileName;
                            List<SqlParameter> docparam = new List<SqlParameter>();
                            SqlParameter RestaurantId = new SqlParameter("@RestaurantId", data["hdnId"]);
                            SqlParameter FileName = new SqlParameter("@FileName", fileName);
                            SqlParameter AbsolutePath = new SqlParameter("@AbsolutePath", "~/Upload/RestauDocs/" + data["hdnId"] + "/" + fileName);
                            docparam.Add(RestaurantId);
                            docparam.Add(FileName);
                            docparam.Add(AbsolutePath);
                            DataAccessCls docObj = new DataAccessCls();
                            System.Data.DataTable dt1 = docObj.RunSP_ReturnDT("pInsertRestauDocuments", docparam, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
                            string json2 = JsonConvert.SerializeObject(dt1);
                            try
                            {
                                context.Request.Files[file.ToString()].SaveAs(context.Server.MapPath("~/Upload/RestauDocs/") + data["hdnId"] + "/" + fileName);
                            }
                            catch (Exception ex)
                            {

                            }
                        }
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(context.Request.Files[file.ToString()].FileName))
                        {
                            if (!Directory.Exists(context.Server.MapPath("~/Upload/RestauPics/") + data["hdnId"]))
                            {
                                Directory.CreateDirectory(context.Server.MapPath("~/Upload/RestauPics/") + data["hdnId"]);
                            }
                            string fileName = Guid.NewGuid().ToString().Substring(0, 6) + "_" + context.Request.Files[file.ToString()].FileName;
                            List<SqlParameter> docparam = new List<SqlParameter>();
                            SqlParameter RestaurantId = new SqlParameter("@RestaurantId", data["hdnId"]);
                            SqlParameter FileName = new SqlParameter("@FileName", fileName);
                            SqlParameter IsDefault;
                            if (file.ToString().Contains("defaultpics"))
                            {
                                IsDefault = new SqlParameter("@IsDefault", 1);
                            }
                            else
                            {
                                IsDefault = new SqlParameter("@IsDefault", 0);
                            }
                            SqlParameter AbsolutePath = new SqlParameter("@AbsolutePath", "~/Upload/RestauPics/" + data["hdnId"] + "/" + fileName);
                            docparam.Add(RestaurantId);
                            docparam.Add(FileName);
                            docparam.Add(AbsolutePath);
                            docparam.Add(IsDefault);
                            DataAccessCls docObj = new DataAccessCls();
                            System.Data.DataTable dt1 = docObj.RunSP_ReturnDT("pInsertRestauPics", docparam, System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
                            string json1 = JsonConvert.SerializeObject(dt1);
                            try
                            {
                                context.Request.Files[file.ToString()].SaveAs(context.Server.MapPath("~/Upload/RestauPics/") + data["hdnId"] + "/" + fileName);
                            }
                            catch (Exception ex)
                            {

                            }
                        }
                    }
                }
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}