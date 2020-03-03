using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;

namespace MovieWebDemo
{
    public partial class login : System.Web.UI.Page
    {
        public static int type = 1;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] != null)
            {
                Response.Redirect("index.aspx");
            }
        }
        protected void login_Button_Click(object sender, EventArgs e)
        {
            string uid = username.Value;
            string pwd = password.Value;
            int access = 0;
            int account = 0;
            //————建立连接————
            MySqlConnection connection = new MySqlConnection();   //实例化连接对象
            connection.ConnectionString = "server=localhost; user id=root; password=123456; database=film_system";    //设置连接字符串
            connection.Open();
            //————————————————
            if (type == 1)
            {
                string selectCom = "select * from table_user where username='" + uid + "' and password='" + pwd + "'";    //编写SQL命令
                MySqlCommand loginCom = new MySqlCommand(selectCom, connection);  //新建一个在 connection 连接下，命令串为 s1 的命令
                MySqlDataReader loginDR = loginCom.ExecuteReader(); //用datareader处理每个记录
                bool hasRow = loginDR.HasRows;
                if (!hasRow)
                {
                    password.Value = "";
                    Session["username"] = null;
                    loginDR.Close();
                    Response.Write("<script>alert('用户名或密码错误，请返回重试！')</script>");
                }
                else
                {
                    loginDR.Read();
                    access = loginDR.GetInt32("access");
                    account = loginDR.GetInt32("account");
                    Session["username"] = username.Value;
                    Session["account"] = account;
                    Session["access"] = access;
                    if (access == 0) { Session["accessname"] = "普通会员"; }
                    if (access == 1) { Session["accessname"] = "VIP会员"; }
                    if (access == 2) { Session["accessname"] = "管理员"; }
                    loginDR.Close();
                    Response.Write("<script>location.href='index.aspx'</script>");
                }
            }
            else
            {
                string selectCom = "select * from table_user where username='" + uid +"'";
                MySqlCommand loginCom = new MySqlCommand(selectCom, connection);
                MySqlDataReader loginDR = loginCom.ExecuteReader();
                bool hasRow = loginDR.HasRows;
                loginDR.Close();
                if (hasRow)
                {
                    password.Value = "";
                    Response.Write("<script>alert('用户名已存在！');</script>");
                }
                else
                {
                    string insertCom = "insert into table_user(username,password) values('" + uid + "','" + pwd + "')";
                    MySqlCommand cmd = new MySqlCommand(insertCom, connection);
                    int result = cmd.ExecuteNonQuery();
                    if (result > 0)
                    {
                        type = 1;
                        Response.Write("<script>alert('注册成功！'); location.href=\"Login.aspx\";</script>");
                    }
                    else
                    {
                        password.Value = "";
                        Response.Write("<script>alert('注册失败！');</script>");
                    }
                }
            }
            //————释放连接————
            connection.Close();
        }
        protected void swap_Button_Click(object sender, EventArgs e)
        {
            if (type == 1)
            {
                username.Value = "";
                password.Value = "";
                login_Button.Text = "注册";
                swap_Button.Text = "返回登录 >>";
                h1.Text = "sign up";

            }
            else
            {
                username.Value = "";
                password.Value = "";
                login_Button.Text = "登录";
                swap_Button.Text = "创建新用户 >>";
                h1.Text = "sign in";
            }
            type = -1 * type;
        }
    }
}
