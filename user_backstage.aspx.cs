using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Data;
using Newtonsoft.Json;
using System.Web.Services;

namespace MovieWebDemo
{
    public partial class user_backstage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((string)Session["username"] == "")
            {
                Response.Write("<script>alert('未登录！');</script>");
                Response.Write("<script>location.href='index.aspx'</script>");
            }
        }
        [WebMethod]
        public static string Kejin(float num)
        {
            string user_name = (string)HttpContext.Current.Session["username"];
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            //获取余额
            string selectCom = "select account from table_user where username='" + user_name + "'";
            MySqlCommand Com0 = new MySqlCommand(selectCom, connection);
            MySqlDataReader accountDR = Com0.ExecuteReader();
            accountDR.Read();
            float account = accountDR.GetFloat("account");
            accountDR.Close();
            string updateCom;
            account = account + num;
            updateCom = "update table_user set account=" + account + " where username='" + user_name + "'";
            MySqlCommand Com1 = new MySqlCommand(updateCom, connection);
            Com1.ExecuteNonQuery();
            HttpContext.Current.Session["account"] = account;
            return "";
        }

        [WebMethod]
        public static string BecomeVIP(string key)
        {
            string user_name = (string)HttpContext.Current.Session["username"];
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            string updateCom = "update table_user set access=1 where username='" + user_name + "'";
            MySqlCommand Com1 = new MySqlCommand(updateCom, connection);
            Com1.ExecuteNonQuery();
            HttpContext.Current.Session["accessname"] = "VIP会员";
            return "";
        }

        [WebMethod]
        public static Boolean ChangePwd(string old_pwd, string new_pwd)
        {
            string user_name = (string)HttpContext.Current.Session["username"];
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            //获取原密码
            string selectCom = "select password from table_user where username='" + user_name + "'";
            MySqlCommand Com0 = new MySqlCommand(selectCom, connection);
            MySqlDataReader pwdDR = Com0.ExecuteReader();
            pwdDR.Read();
            string pwd = pwdDR.GetString("password");
            pwdDR.Close();
            if (pwd != old_pwd) return false;
            string updateCom = "update table_user set password='" + new_pwd + "' where username='" + user_name + "'";
            MySqlCommand Com1 = new MySqlCommand(updateCom, connection);
            Com1.ExecuteNonQuery();
            return true;
        }
    }
}