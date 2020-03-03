<%@ Page Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="MovieWebDemo.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>主页</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div class="content">
            <div id="focusslide" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#focusslide" data-slide-to="0" class="active"></li>
                    <li data-target="#focusslide" data-slide-to="1"></li>
                </ol>
                <div class="carousel-inner" role="listbox">
                    <div class="item active">
                        <a href="#" target="_blank">
                            <img src="images/adv.jpg" class="img-responsive" /></a>
                    </div>
                    <div class="item">
                        <a href="#" target="_blank">
                            <img src="images/adv.jpg" class="img-responsive" /></a>
                    </div>
                </div>
                <a class="left carousel-control" href="#focusslide" role="button" data-slide="prev" rel="nofollow">
                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span><span class="sr-only">上一个</span>
                </a>
                <a class="right carousel-control" href="#focusslide" role="button" data-slide="next" rel="nofollow">
                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span><span class="sr-only">下一个</span>
                </a>
            </div>
            <div class="title">
                <h3>正在热映</h3>
            </div>
            <div id="mainlist">
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="script_CPH" runat="server">
    <script>
        $(document).ready(function () {
            $.ajax({    //用ajax读列表
                type: "post",
                url: "index.aspx/Get_mainlist",
                contentType: "application/json;cjarset=utf-8",
                dataType: "json",
                success: function (res) { //res是从后端返回回来的对象
                    if (res.d.length > 0) {
                        var r = jQuery.parseJSON(res.d);    //用jQuery解析json
                        var table = r.Table;
                        for (i = 0; i < table.length; i++) {
                            table[i].releasedate = table[i].releasedate.split('T')[0];  //日期只取年月日
                            var output = '<article class="excerpt excerpt-' + i + '" style = "" ><a class="focus" href="detail.aspx?id=' + table[i].id +
                                '" title="' + table[i].name + '" target="_blank"><img class="thumb" data-original="images/covers/' + table[i].image +
                                '" src="images/covers/' + table[i].image + '" style="width: 100%; height: 100%"></a>' +
                                '<header><h2><a href="detail.aspx?id=' + table[i].id + '" title="' + table[i].name + '" target="_blank" >' + table[i].name + '</a></h2></header>' +
                                '<p class="meta"><a class="comment" title="导演" target="_blank" ><i class="glyphicon glyphicon-user"></i> 导演：' + table[i].director + '</a></p>' +
                                '<p class="meta"><a class="comment" title="主演" target="_blank" ><i class="glyphicon glyphicon-list"></i> 主演：' + table[i].mainactor + '</a></p>' +
                                '<p class="meta"><a class="comment" title="上映日期" target="_blank" ><i class="glyphicon glyphicon-calendar"></i> 上映日期：' + table[i].releasedate + '</a></p>' +
                                '<p class="meta"><a class="comment" title="评分" target="_blank" ><i class="glyphicon glyphicon-star"></i> 评分：' + table[i].rating + '</a></p>' +
                                '<p class="note">' + table[i].content + '</p>' + '<p class="meta">' +
                                '<button class="btn btn-buy" type="button" onclick="location.href=\'detail.aspx?id=' + table[i].id + '\'">购票</button></p>' + '</article>';
                            $("#mainlist").append(output);
                        }
                    }
                },
                error: function (res) {
                }
            });
        })
    </script>
</asp:Content>