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
    public partial class detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static string Get_detail(int id)
        {
            //使用json把数据库内的表 t_user 用 DataSet 显示到页面
            MySqlConnection connection = new MySqlConnection();   //实例化连接对象
            try
            {
                string json = "";
                connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";    //设置连接字符串
                connection.Open();

                string findfilm_str = "select * from table_film where id='" + id + "'";  //在电影表中查找相应id的电影
                MySqlCommand Com = new MySqlCommand(findfilm_str, connection);
                MySqlDataAdapter DA = new MySqlDataAdapter();
                DA.SelectCommand = Com;
                DataSet DS = new DataSet();
                DA.Fill(DS);
                json = json + JsonConvert.SerializeObject(DS);

                string time = DateTime.Now.ToString();
                string findschedule_str = "select * from table_schedule where movie_id='" + id + "' and datetime>'" + time + "'";  //在排期表中查找当前时间后的排期
                MySqlCommand Com2 = new MySqlCommand(findschedule_str, connection);
                MySqlDataAdapter DA2 = new MySqlDataAdapter();
                DA.SelectCommand = Com2;
                DataSet DS2 = new DataSet();
                DA.Fill(DS2);
                json = json + "|" + JsonConvert.SerializeObject(DS2);

                return json;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            {
                connection.Close();
            }
        }

        [WebMethod]
        public static string CreateOrder(int sche_id, string sche_dt, string user_name, string movie_name, string seat_chose, int seat_num, float totalprice)
        {
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();

            //判断余额
            string selectCom = "select account from table_user where username='" + user_name + "'";
            MySqlCommand Com0 = new MySqlCommand(selectCom, connection);
            MySqlDataReader accountDR = Com0.ExecuteReader();
            accountDR.Read();
            float account = accountDR.GetFloat("account");
            accountDR.Close();
            string updateCom;
            if (totalprice > account)
                return "|余额不足！|";
            else
            {
                account = account - totalprice;
                updateCom = "update table_user set account=" + account + " where username='" + user_name + "'";
                MySqlCommand Com1 = new MySqlCommand(updateCom, connection);
                Com1.ExecuteNonQuery();
            }

            //在order表中新建记录
            string insertCom = "insert into table_order(sche_id,sche_dt,user_name,movie_name,seat_chose,seat_num,totalprice) values(" + sche_id + ",'" + sche_dt + "','" + user_name + "','" + movie_name + "','" + seat_chose + "'," + seat_num + "," + totalprice + ")";
            MySqlCommand Com = new MySqlCommand(insertCom, connection);
            Com.ExecuteNonQuery();

            //在schedule表中修改已售座位
            selectCom = "select seat_sold from table_schedule where id='" + sche_id + "'";
            MySqlCommand Com2 = new MySqlCommand(selectCom, connection);
            MySqlDataReader DR = Com2.ExecuteReader();
            DR.Read();
            string seatsold;
            try
            {
                seatsold = DR.GetString("seat_sold");
            } catch
            {
                seatsold = "";
            }
            DR.Close();
            updateCom = "update table_schedule set seat_sold=@seatsold WHERE id=@scheid";
            MySqlCommand Com3 = new MySqlCommand(updateCom, connection);
            Com3.Parameters.AddWithValue("@seatsold", seat_chose + ',' + seatsold);
            Com3.Parameters.AddWithValue("@scheid", sche_id);
            Com3.ExecuteNonQuery();
            HttpContext.Current.Session["account"] = account;
            return "|购票成功！|";
        }
    }
}