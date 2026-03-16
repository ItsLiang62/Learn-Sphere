using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public class DatabaseHelper
{
    private static string connStr =
        ConfigurationManager.ConnectionStrings["Learn_Sphere"].ConnectionString;

    public static SqlConnection GetConnection()
    {
        return new SqlConnection(connStr);
    }

    public static DataTable ExecuteSelect(string query, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = GetConnection())
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                {
                    foreach (SqlParameter p in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(p.ParameterName, p.Value));
                    }
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }

    public static int ExecuteNonQuery(string query, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = GetConnection())
        {
            conn.Open();

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                {
                    foreach (SqlParameter p in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(p.ParameterName, p.Value));
                    }
                }

                return cmd.ExecuteNonQuery();
            }
        }
    }

    public static object ExecuteScalar(string query, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = GetConnection())
        {
            conn.Open();

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (parameters != null)
                {
                    foreach (SqlParameter p in parameters)
                    {
                        cmd.Parameters.Add(new SqlParameter(p.ParameterName, p.Value));
                    }
                }

                return cmd.ExecuteScalar();
            }
        }
    }
}