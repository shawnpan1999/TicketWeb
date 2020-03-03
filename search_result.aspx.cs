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
using System.Text.RegularExpressions;

namespace MovieWebDemo
{
    public partial class search_result : System.Web.UI.Page
    {
        static public string keyword;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                keyword = Request.Form.Get("kw");    //取得前端传来的form
                keyword = keyword.Trim();   //Trim()去除首尾空格
                if (keyword == "")
                {
                    Response.Write("<script>alert('未输入关键字！')</script>");
                    Response.Write("<script>location.href='index.aspx'</script>");
                    return;
                }
            }
            catch
            { return; }
            finally { }
        }

        [WebMethod]
        public static string Get_mainlist()
        {
            //使用json把数据库内的表 t_user 用 DataSet 显示到页面
            MySqlConnection connection = new MySqlConnection();   //实例化连接对象
            try
            {
                connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";    //设置连接字符串
                connection.Open();
                //————————————————
                string comstr = "select * from table_film where";  //SQL命令前半部分
                string[] split = Regex.Split(keyword, "\\s+", RegexOptions.IgnoreCase); //以空格分隔搜索词
                for (int i = 0; i < split.Length; i++)
                {
                    comstr = comstr + " name like '%" + split[i] + "%' " + "or";
                }
                comstr = comstr.Substring(0, comstr.Length - 2);    //剔除末位的"or"
                comstr += "order by releasedate desc";
                //——
                MySqlCommand Com = new MySqlCommand(comstr, connection); 
                MySqlDataAdapter DA = new MySqlDataAdapter();
                DA.SelectCommand = Com;
                DataSet DS = new DataSet();
                DA.Fill(DS);    //将结果放入DataSet

                //用newtonjson把DS转为字符串
                return JsonConvert.SerializeObject(DS);
            }
            catch
            { return null; }
            finally
            {
                connection.Close();
            }
        }
    }
}