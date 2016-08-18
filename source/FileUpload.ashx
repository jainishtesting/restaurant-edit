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
