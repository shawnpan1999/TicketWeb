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
    public partial class admin_backstage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((string)Session["accessname"] != "管理员")
            {
                Response.Write("<script>alert('宁还不是管理员！');</script>");
                Response.Write("<script>location.href='index.aspx'</script>");
            }

        }

        protected void movie_submit_Click(object sender, EventArgs e)
        {
            string name = movie_name.Value;
            string releasedate = movie_releasedate.Value;
            string director = movie_director.Value;
            string mainactor = movie_mainactor.Value;
            string content = movie_content.Value;
            string image = movie_iamge.FileName;
            if (name == "" || releasedate == "" || director == "" || mainactor == "" || content == "" || image == "" )
            {
                Response.Write("<script>alert('电影信息不能为空！');</script>");
                return;
            }
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            string selectCom = "select * from table_film where name='" + name + "'";
            MySqlCommand sCom = new MySqlCommand(selectCom, connection);
            MySqlDataReader sDR = sCom.ExecuteReader();
            bool hasRow = sDR.HasRows;
            sDR.Close();
            if (hasRow)
            {
                Response.Write("<script>alert('电影已存在！');</script>");
                return;
            }
            else
            {
                movie_iamge.SaveAs(Server.MapPath(".") + "//Images//covers//" + image);
                string insertCom = "insert into table_film(name,releasedate,director,mainactor,rating,image,content) values('" + name + "','" + releasedate + "','" + director + "','" + mainactor + "'," + 0 + ",'" + image + "','" + content + "')"; 
                MySqlCommand cmd = new MySqlCommand(insertCom, connection);
                int result = cmd.ExecuteNonQuery();
                Response.Write("<script>alert('提交成功！');</script>");
                Response.Write("<script>location.href='admin_backstage.aspx'</script>");
            }
        }
        //protected void sche_submit_Click(object sender, EventArgs e)
        //{
        //    int movie_id = int.Parse(sche_movie_id.Value);
        //    int hall_id = 1;
        //    string datetime = sche_datetime.Value;
        //    float price = float.Parse(sche_price.Value);
        //    if (movie_id == 0 || datetime == "" || price == 0.0)
        //    {
        //        Response.Write("<script>alert('排期信息不能为空！');</script>");
        //        return;
        //    }
        //    MySqlConnection connection = new MySqlConnection();
        //    connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
        //    connection.Open();
        //    string selectCom = "select * from table_film where name='" + movie_id + "' and datetime='" + datetime + "'";
        //    MySqlCommand sCom = new MySqlCommand(selectCom, connection);
        //    MySqlDataReader sDR = sCom.ExecuteReader();
        //    bool hasRow = sDR.HasRows;
        //    sDR.Close();
        //    if (hasRow)
        //    {
        //        Response.Write("<script>alert('排期已存在！');</script>");
        //        return;
        //    }
        //    else
        //    {
        //        string insertCom = "insert into table_film(movie_id,hall_id,datetime,price) values(" + movie_id + "," + hall_id + ",'" + datetime + "'," + price + ")";
        //        MySqlCommand cmd = new MySqlCommand(insertCom, connection);
        //        int result = cmd.ExecuteNonQuery();
        //        Response.Write("<script>alert('提交成功！');</script>");
        //        Response.Write("<script>location.href='admin_backstage.aspx'</script>");
        //    }
        //}

        [WebMethod]
        public static string Get_mainlist()
        {
            MySqlConnection connection = new MySqlConnection();
            try
            {
                connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8"; 
                connection.Open();

                string s1 = "select * from table_film order by releasedate desc";
                MySqlCommand Com = new MySqlCommand(s1, connection);
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
        public static string Get_selected(int id)
        {
            MySqlConnection connection = new MySqlConnection();
            try
            {

                connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
                connection.Open();

                string s1 = "select * from table_schedule where movie_id='" + id + "'";
                MySqlCommand Com = new MySqlCommand(s1, connection);
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
        public static string DeleteSche(int id)
        {
            MySqlConnection connection = new MySqlConnection();
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system; charset=utf8";
            connection.Open();
            string deletecom = "delete from table_schedule where id='" + id + "'";
            MySqlCommand Com = new MySqlCommand(deletecom, connection);
            Com.ExecuteNonQuery();
            return "";
        }
    }
}