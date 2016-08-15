﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

public class DataAccessCls
{
    public DataTable RunSP_ReturnDT(string procedureName, List<SqlParameter> parameters, string connectionString)
    {
        DataTable dtData = new DataTable();
        using (SqlConnection sqlConn = new SqlConnection(connectionString))
        {
            using (SqlCommand sqlCommand = new SqlCommand(procedureName, sqlConn))
            {
                sqlCommand.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                {
                    sqlCommand.Parameters.AddRange(parameters.ToArray());
                }
                using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand))
                {
                    sqlDataAdapter.Fill(dtData);
                }
            }
        }
        return dtData;
    }
}
