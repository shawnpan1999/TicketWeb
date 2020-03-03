<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="MovieWebDemo.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>登录</title>
    <link rel="stylesheet" type="text/css" href="css/user_normal.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/nprogress.css" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/font-awesome.min.css" />
    <link rel="shortcut icon" href="images/favicon.ico" />
</head>

<body>
    <header class="header">
        <nav class="navbar navbar-default" id="navbar">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#header-navbar" aria-expanded="false">
                        <span class="sr-only"></span><span class="icon-bar"></span>
                        <span class="icon-bar"></span><span class="icon-bar"></span>
                    </button>
                    <a href="#">
                        <img width="10%" height="10%" src="images/box.png"/>
                    </a>
                </div>
                <div class="collapse navbar-collapse" id="header-navbar">
                    <form class="navbar-form visible-xs">
                        <div class="input-group">
                            <input type="text" id="keyword2" name="kw" class="form-control" placeholder="请输入关键字" maxlength="20" autocomplete="off"/>
                            <span class="input-group-btn">
                                <button class="btn btn-default btn-search" onclick="search2()" type="submit">搜索</button>
                            </span>
                        </div>
                    </form>
                    <ul id="navigation" class="nav navbar-nav navbar-right">
                        <li><a href="index.aspx">首页</a></li>
                        <li><a href="Login.aspx">登录</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    <div class="container">
        <div>
            <form role="form" class="form-signin" runat="server">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div>
                                <asp:Label ID="h1" Style="color: #4AA4B6" runat="server" Text="登录" Font-Size="XX-Large" Font-Bold="True"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div>
                            <label for="username">用户名</label>
                            <input type="text" class="form-control" id="username" placeholder="Username" runat="server" />
                        </div>
                        <br />
                        <div>
                            <label for="username">密码</label>
                            <input type="text" class="form-control" id="password" placeholder="Password" runat="server" />
                        </div>
                        <br />
                        <asp:Button ID="login_Button" CssClass="btn btn-block btn-search" type="submit" runat="server" Text="登录" OnClick="login_Button_Click" />
                        <br />
                        <div class="text-center">
                            <asp:Button ID="swap_Button" CssClass="btn btn-link" type="button" runat="server" Text="创建新用户 >>" OnClick="swap_Button_Click" />
                        </div>
                        <br />
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
