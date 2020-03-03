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
    public partial class order_list : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string Get_orderlist(string username)
        {
            MySqlConnection connection = new MySqlConnection();
            try
            {
                connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
                connection.Open();
                string selectcom = "select * from table_order where user_name='" + username + "' order by id desc";
                MySqlCommand Com = new MySqlCommand(selectcom, connection); 
                MySqlDataAdapter DA = new MySqlDataAdapter();
                DA.SelectCommand = Com;
                DataSet DS = new DataSet(); 
                DA.Fill(DS);

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
        public static string DeleteOrder(int id)
        {
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            string deletecom = "delete from table_order where id='" + id + "'";
            MySqlCommand Com = new MySqlCommand(deletecom, connection);
            Com.ExecuteNonQuery();
            return "";
        }
    }
}