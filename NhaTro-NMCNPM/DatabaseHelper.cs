using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CNPM
{
    /// <summary>
    /// Lớp hỗ trợ truy xuất Cơ sở dữ liệu SQL Server (ADO.NET)
    /// Thiết kế chuẩn kỹ nghệ phần mềm: Hỗ trợ kết nối SQL Server và tự động Fallback bảo đảm ứng dụng không bao giờ bị Crash
    /// </summary>
    public static class DatabaseHelper
    {
        private static string GetConnectionString()
        {
            try
            {
                if (ConfigurationManager.ConnectionStrings["NganHangNhaTroDB"] != null)
                {
                    return ConfigurationManager.ConnectionStrings["NganHangNhaTroDB"].ConnectionString;
                }
            }
            catch { }

            // Chuỗi kết nối mặc định tới Database ngan_hang_nha_tro trên máy nội bộ
            return "Server=.;Database=ngan_hang_nha_tro;Integrated Security=True;MultipleActiveResultSets=True;Connect Timeout=2;";
        }

        /// <summary>
        /// Thực thi truy vấn SELECT trả về DataTable
        /// </summary>
        public static DataTable ExecuteQuery(string sql, SqlParameter[] parameters = null)
        {
            DataTable dt = new DataTable();
            string connStr = GetConnectionString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        conn.Open();
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        /// <summary>
        /// Thực thi INSERT, UPDATE, DELETE trả về số dòng bị ảnh hưởng
        /// </summary>
        public static int ExecuteNonQuery(string sql, SqlParameter[] parameters = null)
        {
            string connStr = GetConnectionString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Thực thi truy vấn trả về một giá trị duy nhất (Scalar)
        /// </summary>
        public static object ExecuteScalar(string sql, SqlParameter[] parameters = null)
        {
            string connStr = GetConnectionString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

        /// <summary>
        /// Kiểm tra nhanh trạng thái kết nối SQL Server
        /// </summary>
        public static bool IsDatabaseOnline()
        {
            try
            {
                string connStr = GetConnectionString();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    return (conn.State == ConnectionState.Open);
                }
            }
            catch
            {
                return false;
            }
        }
    }

    /// <summary>
    /// Lớp mô hình dữ liệu tài khoản người dùng phục vụ cơ chế Fallback Offline trong bộ nhớ ứng dụng
    /// </summary>
    public class UserAccountModel
    {
        public string UserId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string FullName { get; set; }
        public string PhoneNumber { get; set; }
        public string Role { get; set; }
    }
}
