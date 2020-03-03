<%@ Page Title="" Language="C#" MasterPageFile="~/base.Master" AutoEventWireup="true" CodeBehind="detail.aspx.cs" Inherits="MovieWebDemo.detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head_CPH" runat="server">
    <title>影片详情</title>
    <link rel="stylesheet" type="text/css" href="css/seat.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="content_CPH" runat="server">
    <div class="content-wrap">
        <div id="main" class="content">
            <div id="moviename" class="title">
            </div>
            <div class="widget widget-tabs" style="height: auto">
                <ul id="datetab" class="nav nav-tabs" role="tablist">
                </ul>
                <div id="bodytab" class="tab-content">
                </div>
            </div>
            <div id="detail" class="booking-details">
            </div>
            <div style="clear: both"></div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="script_CPH" runat="server">
    <script src="js/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="js/jquery.seat-charts.min.js"></script>
    <script>
        var sche;
        var movie;
        function addDateTab(date) {
            text = '<li id="' + date + '_datetab" role="presentation"><a href="#' + date + '_bodytab" aria-controls="' + date + '_bodytab" role="tab" data-toggle="tab">' + date + '</a></li>';
            $("#datetab").append(text);
            text = '<div id="' + date + '_bodytab" role = "tabpanel" class="tab-pane contact"><div id="timebtnset_' + date + '"></div>' +
                '<div class="seatCharts-container"><div id="' + date + '_seatmap"></div></div></div>';
            $("#bodytab").append(text);
        }
        function addTimeBtn(id, date, time) {
            //选择时间的按钮id="yy-mm-ddThh:mm:ss"
            text = '<button id="' + date + 'T' + time + '" onclick="location.href=\'detail.aspx?id=' + id + '&datetime=' + date + 'T' + time +
                '\'" style="margin-left: 30px;" class="btn btn-buy" type="button">' + time.substring(0, time.length - 3) + '</button>';
            $("#timebtnset_" + date).append(text);
        }
        function getScdDetail(schedule, datetime) {
            for (i = 0; i < schedule.length; i++) {
                if (schedule[i].datetime == datetime) {
                    return schedule[i];
                }
            }
        }
        function recalculateTotal(sc, price) {
            var total = 0;
            sc.find('selected').each(function () {
                total += price;
            });

            return total;
        }
        function loadSeat(sche) {
            var price = sche.price;
            var date = sche.datetime.split('T')[0];
            var time = sche.datetime.split('T')[1];
            document.getElementById(date + '_seatmap').innerHTML = '<div class="front">屏幕</div>';
            var $cart = $('#seats_detail'), //座位区
                $counter = $('#counter_detail'), //票数
                $total = $('#total_detail'); //总计金额

            sc = $('#' + date + '_seatmap').seatCharts({
                map: [  //座位图
                    'eeeeeeeeeeeeee',
                    'eeeeeeeeeeeeee',
                    '______________',
                    'eeee__eeeeeeee',
                    'eeee__eeeeeeee',
                    'eeee__eeeeeeee',
                    'eeee__eeeeeeee',
                    '______eeeeeeee'
                ],
                naming: {
                    top: false,
                    getLabel: function (character, row, column) {
                        return column;
                    }
                },
                //legend: {   //图例
                //    node: $('#legend'),
                //    items: [
                //        ['e', 'available', '可选座'],
                //        ['e', 'unavailable', '已售出']
                //    ]
                //},
                click: function () { //点击事件
                    if (this.status() == 'available') { //可选座
                        //在结算列表中添加
                        text = '<button id="sledseat_' + this.settings.id + '" class="btn btn-seat"  onclick="document.getElementById(\'' + this.settings.id + '\').click()"><i class="glyphicon glyphicon-remove"></i> ' + (this.settings.row + 1) + '排' + this.settings.label + '座</button>';
                        $cart.append(text);

                        $counter.text(sc.find('selected').length + 1);
                        $total.text(recalculateTotal(sc, price) + price);

                        return 'selected';
                    } else if (this.status() == 'selected') { //已选中
                        //更新数量
                        $counter.text(sc.find('selected').length - 1);
                        //更新总计
                        $total.text(recalculateTotal(sc, price) - price);

                        //删除已预订座位
                        $('#sledseat_' + this.settings.id).remove();
                        //可选座
                        return 'available';
                    } else if (this.status() == 'unavailable') { //已售出
                        return 'unavailable';
                    } else {
                        return this.style();
                    }
                }
            });
            //已售出的座位
            sc.status(sche.seat_sold.split(','), 'unavailable');
        }
        function loadDetail(sche, movie) {
            document.getElementById('detail').innerHTML = '<p>影片：<span id="name_detail"></span></p>' +
                '<p> 时间：<span id="datetime_detail"></span></p>' +
                '<p>已选座位：</p>' +
                '<ul id="seats_detail"></ul>' +
                '<p>数量：<span id="counter_detail">0</span></p>' +
                '<p>总计：  ￥:<span id="total_detail" style="color:red;font-weight:bold;font-size:24px">0</span></p>' +
                '<button id="purchase" onclick="order();" class="btn btn-buy">提交订单</button>';
            document.getElementById('name_detail').innerHTML = movie.name;
            var dt = sche.datetime.substring(0, sche.datetime.length - 3);
            dt = dt.replace('T', ' ');
            document.getElementById('datetime_detail').innerHTML = dt;

        }
        function highlightTab(datetime) {
            var temp, date, time;
            temp = datetime.split("T");
            date = temp[0];
            time = temp[1];
            var dtab = document.getElementById('datetab');
            var liArr = dtab.getElementsByTagName("li");
            for (i = 0; i < liArr.length; i++) {
                if (liArr[i].id != date + '_datetab') {
                    liArr[i].setAttribute('class', '');
                } else {
                    liArr[i].setAttribute('class', 'active');
                }
            }
            var btab = document.getElementById('bodytab');
            var divArr = btab.getElementsByTagName("div");
            for (i = 0; i < divArr.length; i++) {
                if (divArr[i].id != date + '_bodytab') {
                    divArr[i].setAttribute('class', 'tab-pane contact');
                } else {
                    divArr[i].setAttribute('class', 'tab-pane contact active');
                }
            }
            document.getElementById(datetime).setAttribute('disabled', 'true');
            document.getElementById(datetime).setAttribute('class', 'btn btn-blue');
        }
        function order() {
            var scchose = sc.find('selected').seatIds;
            var scnum = sc.find('selected').length;
            var username = '<%=Session["username"]%>';
            var datatext = '{sche_id:' + sche.id + ',sche_dt:"' + sche.datetime + '",user_name:"' + username + '",movie_name:"' + movie[0].name + '",seat_chose:"' + scchose + '",seat_num:' + scnum + ',totalprice:' + (sche.price * scnum) + '}'
            $.ajax({
                type: "post",
                url: "detail.aspx/CreateOrder",
                contentType: "application/json;cjarset=utf-8",
                dataType: "text",
                data: datatext,
                success: function (res) {
                    res = res.split("|")[1];
                    res = res.split("|")[0];
                    alert(res);
                    location.reload();
                },
                error: function (res) {
                }
            });

        }
        $(document).ready(function () {
            var schedule;
            $.ajax({    //初始化movie
                type: "post",
                url: "detail.aspx/Get_detail",
                contentType: "application/json;cjarset=utf-8",
                dataType: "json",
                data: "{id:'" + getQueryVariable("id") + "'}",    //此项为参数，格式为："{name:value}"
                success: function (res) {
                    if (res.d.length > 0) {
                        var id = getQueryVariable("id");
                        var arr = res.d.split("|");
                        var r = jQuery.parseJSON(arr[0]);
                        movie = r.Table;
                        var text;
                        movie[0].releasedate = movie[0].releasedate.split('T')[0];
                        document.getElementById("moviename").innerHTML += '<h3>' + movie[0].name + '</h3>';

                        //根据schedule增加tab和btn
                        r = jQuery.parseJSON(arr[1]);
                        schedule = r.Table;
                        var temp, date, time;
                        for (i = 0; i < schedule.length; i++) {
                            temp = schedule[i].datetime.split("T");
                            if (temp[0] == date) {  //如果该date已经出现过，只要加button就好了
                                time = temp[1];
                                addTimeBtn(id, date, time);
                                continue;
                            } else {    //如果date还没有出现，即前面的date和time已经添加完毕，需要添加新tab
                                date = temp[0];
                                time = temp[1];
                                addDateTab(date);
                                addTimeBtn(id, date, time);
                            }
                        }
                        sche = getScdDetail(schedule, getQueryVariable("datetime"));
                        if (!sche) {    //默认第一项tab打开
                            var dtab = document.getElementById('datetab');
                            var liArr = dtab.getElementsByTagName("li");
                            liArr[0].setAttribute('class', 'active');
                            var btab = document.getElementById('bodytab');
                            var divArr = btab.getElementsByTagName("div");
                            divArr[0].setAttribute('class', 'tab-pane contact active');
                        } else {
                            loadDetail(sche, movie[0]);
                            highlightTab(sche.datetime);
                            loadSeat(sche);
                        }
                    }
                },
                error: function (res) {
                }
            });
        })
    </script>
</asp:Content>
