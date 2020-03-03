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
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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

                string s1 = "select * from table_film order by releasedate desc limit 0,5";  //查找电影表中上映日期倒序前五个电影
                MySqlCommand Com = new MySqlCommand(s1, connection);  //新建一个在 connection 连接下，命令串为 s1 的命令
                MySqlDataAdapter DA = new MySqlDataAdapter();  //实例化数据适配器
                DA.SelectCommand = Com;
                DataSet DS = new DataSet();   //实例化结果数据集
                DA.Fill(DS);    //将结果放入数据适配器

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

        [WebMethod]
        public static string Logout(string key)
        {
            HttpContext.Current.Session.Clear();    //清session
            return key;
        }
    }
}