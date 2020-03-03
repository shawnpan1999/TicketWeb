<%@ Page Title="" Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="order_list.aspx.cs" Inherits="MovieWebDemo.order_list" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>订单详情</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div class="content">
            <div class="title">
                <h3>订单列表</h3>
            </div>
            <div id="mainlist">
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="script_CPH" runat="server">
    <script>
        var username = '<%=Session["username"]%>';
        $.ajax({
            type: "post",
            url: "order_list.aspx/Get_orderlist",
            contentType: "application/json;cjarset=utf-8",
            dataType: "json",
            data: "{username:'" + username + "'}",
            success: function (res) {
                if (res.d.length > 0) {
                    var r = jQuery.parseJSON(res.d);
                    var table = r.Table;
                    for (i = 0; i < table.length; i++) {
                        table[i].sche_dt = table[i].sche_dt.replace("T", " ");  //日期格式一致
                        table[i].seat_chose = table[i].seat_chose.replace(/_/g, "排");
                        table[i].seat_chose = table[i].seat_chose.replace(/,/g, "座 ");
                        table[i].seat_chose = table[i].seat_chose.concat("座");
                        var output = '<article class="excerpt excerpt-' + i + '" style ="padding: 20px;" ><header><h2><a title="' + table[i].movie_name + '" target="_blank" >' + table[i].movie_name + '</a></h2></header>' +
                            '<p class="meta"><a class="comment" title="放映时间" target="_blank" ><i class="glyphicon glyphicon-calendar"></i> 放映时间：' + table[i].sche_dt + '</a></p>' +
                            '<p class="meta"><a class="comment" title="座位" target="_blank" ><i class="glyphicon glyphicon-th-list"></i> 座位：' + table[i].seat_chose + '</a></p>' +
                            '<p class="meta"><a class="comment" title="数量" target="_blank" ><i class="glyphicon glyphicon glyphicon-tags"></i> 数量：' + table[i].seat_num + '</a></p>' +
                            '<p class="meta"><a class="comment" title="总价" target="_blank" ><i class="glyphicon glyphicon glyphicon-yen"></i> 订单总价：' + table[i].totalprice + '</a></p>' +
                            '<p class="meta"><button class="btn btn-seat" type="button" onclick="deleteorder(' + table[i].id + ')"><i class="glyphicon glyphicon-remove"></i> 删除订单</button></p></article>';
                        $("#mainlist").append(output);
                    }
                }
                else {

                }
            },
            error: function (res) {
            }
        });

        function deleteorder(id) {
            PageMethods.DeleteOrder(id, deleteorderCallComplete, deleteorderCallError);
        }
        function deleteorderCallComplete(result, userContext, methodName) {
            location.reload();
        }
        function deleteorderCallError(error, userContext, methodName) {
        }
    </script>
</asp:Content>
