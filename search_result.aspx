<%@ Page Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="search_result.aspx.cs" Inherits="MovieWebDemo.search_result" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>搜索结果</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div class="content">
            <div class="title">
                <h3>搜索结果</h3>
            </div>
            <div id="mainlist">
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="script_CPH" runat="server">
    <script>
        $.ajax({
            type: "post",
            url: "search_result.aspx/Get_mainlist",
            contentType: "application/json;cjarset=utf-8",
            dataType: "json",
            success: function (res) {
                var r = jQuery.parseJSON(res.d);
                var table = r.Table;
                if (table.length > 0) {
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
                else {
                    alert("未搜索到任何结果！");
                }
            },
            error: function (res) {
            }
        });
    </script>
</asp:Content>
