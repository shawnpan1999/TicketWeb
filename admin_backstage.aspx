<%@ Page Title="" Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="admin_backstage.aspx.cs" Inherits="MovieWebDemo.admin_backstage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>管理后台</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div id="main" class="content">
            <div class="title">
                <h3>管理后台</h3>
            </div>
            <div class="widget widget-tabs" style="height: auto">
                <ul id="headtab" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#insert_movie" aria-controls="insert_movie" role="tab" data-toggle="tab">新增电影</a></li>
                    <li role="presentation"><a href="#manage_sche" aria-controls="manage_sche" role="tab" data-toggle="tab">排期管理</a></li>
                </ul>
                <div class="tab-content">
                    <div id="insert_movie" role="tabpanel" class="tab-pane contact active">
                        <div class="card">
                            <p style="line-height: 50px; margin-left: 10px;">电影名称：<input id="movie_name" class="form-control" style="display: inline; width: 50%;" type="text" runat="server" /></p>
                            <p style="line-height: 50px; margin-left: 10px;">上映日期：<input id="movie_releasedate" class="form-control" style="display: inline; width: 50%;" type="date" runat="server" /></p>
                            <p style="line-height: 50px; margin-left: 10px;">导演：<input id="movie_director" class="form-control" style="display: inline; width: 50%;" type="text" runat="server" /></p>
                            <p style="line-height: 50px; margin-left: 10px;">主演：<input id="movie_mainactor" class="form-control" style="display: inline; width: 50%;" type="text" runat="server" /></p>
                            <p style="line-height: 50px; margin-left: 10px;"><span>简介：</span><textarea id="movie_content" rows="3" class="form-control" style="display: inline; width: 50%;" maxlength="255" type="text" runat="server"></textarea></p>
                            <p style="line-height: 50px; margin-left: 10px;">封面图片：<asp:FileUpload Style="display: inline;" ID="movie_iamge" runat="server" /></p>
                            <asp:Button ID="movie_submit" runat="server" class="btn btn-buy" Text="提交" OnClick="movie_submit_Click" />
                        </div>
                    </div>
                    <div id="manage_sche" role="tabpanel" class="tab-pane contact" style="text-align: center">
                        <div style="border-bottom: 1px solid #ebebeb;">
                            <p>
                                选择电影：<select id="movie_select"></select>
                                <button class="btn btn-search" id="select_search" onclick="selected()" type="button">查询</button>
                            </p>
                        </div>
                        <div id="schelist">
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
            $.ajax({    //初始化下拉框
                type: "post",
                url: "admin_backstage.aspx/Get_mainlist",
                contentType: "application/json;cjarset=utf-8",
                dataType: "json",
                success: function (res) {
                    if (res.d.length > 0) {
                        var r = jQuery.parseJSON(res.d);
                        var table = r.Table;
                        var movie_select = document.getElementById("movie_select");
                        for (i = 0; i < table.length; i++) {
                            op = new Option(table[i].name, table[i].id);
                            movie_select.add(op);
                        }
                    }
                },
                error: function (res) {
                }
            });
        })
        function selected() {
            var options = $("#movie_select option:selected");
            var id = options.val();
            var name = options.text();
            var schelist = document.getElementById("schelist");
            $.ajax({
                type: "post",
                url: "admin_backstage.aspx/Get_selected",
                contentType: "application/json;cjarset=utf-8",
                dataType: "json",
                data: "{id:'" + id + "'}",
                success: function (res) {
                    if (res.d.length > 0) {
                        var r = jQuery.parseJSON(res.d);
                        var table = r.Table;
                        schelist.innerHTML = "";
                        for (i = 0; i < table.length; i++) {
                            table[i].datetime = table[i].datetime.replace("T", " ");
                            table[i].seat_sold = table[i].seat_sold.replace(/_/g, "排");
                            table[i].seat_sold = table[i].seat_sold.replace(/,/g, "座 ");
                            table[i].seat_sold = table[i].seat_sold.concat("座");
                            var text = '<div style="text-align: left;padding-left: 40px;" class="card"><p>排期：' + table[i].datetime + '</p><p>价格：' + table[i].price + '</p><p>已售座位：' + table[i].seat_sold +
                                '</p><p><button class="btn btn-seat" type="button" onclick="deletesche(' + table[i].id + ')"><i class="glyphicon glyphicon-remove"></i> 删除排期</button></p></div>';
                            schelist.innerHTML += text;
                        }
                    }
                },
                error: function (res) {
                }
            });
        }
        function deletesche(id) {
            PageMethods.DeleteSche(id, deletescheCallComplete, deletescheCallError);
        }
        function deletescheCallComplete(result, userContext, methodName) {
            location.reload();
        }
        function deletescheCallError(error, userContext, methodName) {
        }
    </script>
</asp:Content>
