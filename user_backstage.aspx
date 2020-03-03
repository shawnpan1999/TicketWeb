<%@ Page Title="" Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="user_backstage.aspx.cs" Inherits="MovieWebDemo.user_backstage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>用户后台</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div id="main" class="content">
            <div class="title">
                <h3>用户后台</h3>
            </div>
            <div class="widget widget-tabs" style="height: auto">
                <ul id="headtab" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#account_detail" aria-controls="account_detail" role="tab" data-toggle="tab">账户详情</a></li>
                    <li role="presentation"><a href="#change_pwd" aria-controls="change_pwd" role="tab" data-toggle="tab">更改密码</a></li>
                </ul>
                <div class="tab-content">
                    <div id="account_detail" role="tabpanel" class="tab-pane contact active">
                        <div class="card">
                            账户权限：<a id="user_access"></a><button id="become_VIP" onclick="becomeVIP()" style="float: right;" class="btn btn-buy"><i class="glyphicon glyphicon-king"></i> 成为VIP</button>
                        </div>
                        <div class="card">
                            账户余额：<a id="user_account"></a><button id="kejin"  type="button" onclick="displayKejin(1);" style="float: right;" class="btn btn-buy"><i class="glyphicon glyphicon-yen"></i> 余额充值</button>
                            <div id="kejin_path" style="display: none">
                                <p style="line-height: 50px;"><span>请输入充值金额：</span>
                                    <input type="text" id="kejin_num" class="form-control" style="display: inline;width: auto;" size="35" placeholder="氪金金额" oninput="this.value=this.value.replace(/[^0-9]/g,'');" autocomplete="off" />
                                </p>
                                <p><button id="kejin_submit" onclick="kejin()" class="btn btn-seat"><i class="glyphicon glyphicon-yen"></i> 提交</button></p>
                            </div>
                        </div>
                    </div>
                    <div id="change_pwd" role="tabpanel" class="tab-pane contact" style="text-align: center">
                        <div  class="card">
                            <p style="line-height: 50px;"><span>原密码：</span><input type="text" id="old_pwd" class="form-control" style="display: inline;width: auto;" size="35" placeholder="原密码" autocomplete="off" /></p>
                            <p style="line-height: 50px;"><span>新密码：</span><input type="text" id="new_pwd" class="form-control" style="display: inline;width: auto;" size="35" placeholder="新密码" autocomplete="off" /></p>
                            <p><button id="pwd_submit" onclick="changePwd()"  class="btn btn-buy"><i class="glyphicon glyphicon-floppy-disk"></i> 提交</button></p>
                        </div>
                    </div>
                </div>
            </div>
            <div id="detail" class="booking-details">
            </div>
            <div style="clear: both"></div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="script_CPH" runat="server">
    <script>
        $(document).ready(function () {
            var username = '<%=Session["username"]%>';
            var accessname = '<%=Session["accessname"]%>';
            var account = '<%=Session["account"]%>';
            document.getElementById("user_access").innerHTML = accessname;
            if (accessname != '普通会员') {
                document.getElementById('become_VIP').setAttribute('disabled', 'true');
            }
            document.getElementById('user_account').innerHTML = account;
        })
        function displayKejin(i) {
            if (i == 1) {
                document.getElementById("kejin_path").style.display = "";
                document.getElementById("kejin").setAttribute('onclick', 'displayKejin(0)');
                document.getElementById("kejin").setAttribute('class', 'btn btn-blue');
            } else {
                document.getElementById("kejin_path").style.display = "none";
                document.getElementById("kejin").setAttribute('onclick', 'displayKejin(1)');
                document.getElementById("kejin").setAttribute('class', 'btn btn-buy');
            }
        }
        function kejin() { //氪金(用webmethod调用后台cs方法)
            PageMethods.Kejin(document.getElementById('kejin_num').value, KejinCallComplete, KejinCallError);
        }
        function KejinCallComplete(result, userContext, methodName) {
            alert("充值成功！");
            location.reload();
        }
        function KejinCallError(error, userContext, methodName) {
            alert("充值失败！");
        }
        function becomeVIP() { //氪金(用webmethod调用后台cs方法)
            PageMethods.BecomeVIP("", becomeVIPCallComplete, becomeVIPCallError);
        }
        function becomeVIPCallComplete(result, userContext, methodName) {
            alert("注册会员成功！");
            location.reload();
        }
        function becomeVIPCallError(error, userContext, methodName) {
            alert("注册会员失败！");
        }
        function changePwd() { //氪金(用webmethod调用后台cs方法)
            PageMethods.ChangePwd(document.getElementById('old_pwd').value, document.getElementById('new_pwd').value, changePwdCallComplete, changePwdCallError);
        }
        function changePwdCallComplete(result, userContext, methodName) {
            if (result) {
                alert("修改成功！");
                location.reload();
            } else {
                alert("原密码不匹配！");
            }
        }
        function changePwdCallError(error, userContext, methodName) {
            alert("原密码不匹配！");
        }
    </script>
</asp:Content>
