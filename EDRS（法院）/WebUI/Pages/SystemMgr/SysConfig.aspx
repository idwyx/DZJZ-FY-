﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysConfig.aspx.cs" Inherits="WebUI.SysConfig" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>系统配置</title>
    <link href="/LigerUI/lib/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet"
        type="text/css" />
    <link href="/LigerUI/lib/LigerUI/skins/ligerui-icons.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/tools/easyui/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="/LigerUI/lib/LigerUI/js/ligerui.all.js"></script>
    <style type="text/css">
        .l-panel-topbar
        {
            padding: 5px 0;
            border-bottom: 1px solid #a3c0e8;
            display: inline-block;
            width: 100%;
        }
        .l-text-wrapper
        {
            display: inline-block;
        }
        .l-text-field
        {
            position: inherit;
            margin: 0;
        }
        .l-text, .l-textarea
        {
            width: 350px;
        }
        #add_form table tr td
        {
            padding: 8px 0px;
        }
        div#tb {
            margin-bottom: 10px;
            overflow-x: auto;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 10px;
            background: white;
            line-height: 30px;
        }
    </style>
</head>
<body style="padding: 15px 15px 0px 15px; overflow: hidden;">
    <div id="tb" >
        <div >
            名称：<input id="txt_key" style="width: 200px;" class="l-text" type="text" name="txt_key" />
            <div id="btn_search" style="margin-left: 10px; display: inline-block; vertical-align: bottom;">
            </div>
        </div>
    </div>
    <div id="mainGrid" style="margin: 0px; padding: 0px">
    </div>
    <%--添加数据窗口--%>
    <div id="add_div" style="padding: 10px; display: none;">
        <div style="padding: 10px 20px 20px 20px">
            <form id="add_form" method="post">
            <table>
                <tr>
                    <td>
                        类型：
                    </td>
                    <td>
                        <input type="hidden" id="key_hidd" name="key_hidd" value="" />
                        <input class="l-text" id="slct_type" type="text" name="slct_type" maxlength="200" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        值：
                    </td>
                    <td>
                        <input class="l-text l-text-field" id="txt_value" type="text" name="txt_value" maxlength="200" />
                        <%--<textarea id="txt_cs" name="txt_cs" cols="100" rows="2" class="l-textarea"></textarea>--%>
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
            </form>
        </div>
    </div>
    <script type="text/javascript">

        var grid = null;
        var select = null;
    
        $(function () {
           
            $('#btn_search').ligerButton({
                text: '查询',
                icon: '../../images/NewAdd/cx.png'
            });


            select = $("#slct_type").ligerComboBox({
                url: '/Pages/SystemMgr/SysConfig.aspx?t=GetType',
                valueField: 'id',
                textField: 'name',
                autocomplete: true,
                onBeforeSelect: function (value, text) {
                    ConfigTypeValue(value);
                }
            });

            grid = $("#mainGrid").ligerGrid({
                columns: [
                { display: '名称', name: 'CONFIGNAME', minWidth: 150 },
                { display: '值', name: 'CONFIGVALUE', minWidth: 500, render: function (item) {
                    if (parseInt(item.CONFIGID) == 10) {
                        if (parseInt(item.CONFIGVALUE) == 0)
                            return "直连模式";
                        else if (parseInt(item.CONFIGVALUE) == 1)
                            return "路由模式";
                    } else
                        return item.CONFIGVALUE;
                }
                },
                { display: '', name: 'PZBM', width: 1, hide: true }
                ], rownumbers: true, pageSize: 50, pageSizeOptions: [20, 50, 100, 500]
                , width: '100%', height: '100%',       //服务器分页
                url: '/Pages/SystemMgr/SysConfig.aspx?page=1',
                alternatingRow: false, fixedCellHeight: false, usePager: true, heightDiff: -16,
                parms: { t: "ListBind",
                    key: $("#txt_key").val()
                }, toolbar: { items: [
                { text: '增加', click: addDown, img: '../../images/NewAdd/add.png' },
               // { line: true },
                {text: '修改', click: editData, img: '../../images/NewAdd/xg.png' },
               // { line: true },
                {text: '删除', click: deleteData, img: '../../images/NewAdd/sc.png' }
                ]
                }, onSuccess: function (data) {
                    if (data.t) {
                        $.ligerDialog.error(data.v);
                    }
                }
            });
            $("#pageloading").hide();
        });

        //提交保持数据
        function submitForm() {
            var isUp = false;
            var jdata = $('#add_form').serializeArray();
            if ($.trim($("#key_hidd").val()) == "")
                jdata[jdata.length] = { name: "t", value: "AddData" };
            else {
                jdata[jdata.length] = { name: "t", value: "UpData" };
                isUp = true;
            }
            $.ajax({
                type: "POST",
                url: "/Pages/SystemMgr/SysConfig.aspx",
                data: jdata,
                dataType: 'json',
                timeout: 10000,
                cache: false,
                beforeSend: function () {
                },
                error: function (xhr) {
                    $.ligerDialog.error('网络连接错误');
                    return false;
                },
                success: function (data) {
                    if (data.t == "win") {
                        $("#add_form")[0].reset();
                        $.ligerDialog.hide();
                        grid.reload();
                        $.ligerDialog.success(data.v);
                    } else {
                        $.ligerDialog.error(data.v);
                    }
                }
            });
        }


        //添加按钮
        function addDown() {
            $('#key_hidd').val('');
            $("#add_form")[0].reset();
            select.setEnabled(true);
            $.ligerDialog.open({ title: '增加配置资料', target: $('#add_div'), width: 570,
                buttons: [{ text: '确定', onclick: function (item, dialog) {
                    submitForm();
                }, cls: 'l-dialog-btn-highlight'
                },
                    { text: '取消', onclick: function (item, dialog) {
                        $("#add_form")[0].reset();
                        dialog.hidden();
                    }
                    }], isResize: true
            });
        }
        //修改
        function editData() {

           var dc = $("#txt_value").ligerComboBox({ data: [{ text: '直连模式', id: '0' }, { text: '路由模式', id: '1'}], valueFieldID: "txt_value_val" });

            var cksld = grid.getSelectedRow();
            if (cksld != null) {
                $.ajax({
                    type: "POST",
                    url: '/Pages/SystemMgr/SysConfig.aspx',
                    data: { t: "GetModel", id: cksld.PZBM, cs: cksld.CONFIGNAME },
                    dataType: 'json',
                    timeout: 5000,
                    cache: false,
                    beforeSend: function () {
                        // return $("#add_form").form('enableValidation').form('validate');
                    },
                    error: function (xhr) {
                        $.ligerDialog.error('网络连接错误');
                        return false;
                    },
                    success: function (data) {
                        if (data.t) {
                            $.ligerDialog.error(data.v);
                        } else {

                            $("#key_hidd").val(data.PZBM);
                            select.setValue(data.CONFIGID);

                            select.setDisabled(true);
                            ConfigTypeValue(data.CONFIGID, data.CONFIGVALUE);                            

                            $.ligerDialog.open({ title: '编辑系统配置', target: $('#add_div'), width: 570,
                                buttons: [{ text: '确定', onclick: function (item, dialog) {
                                    submitForm();
                                }, cls: 'l-dialog-btn-highlight'
                                }, { text: '取消', onclick: function (item, dialog) {
                                    $("#add_form")[0].reset();
                                    dialog.hidden();
                                }
                                }], isResize: true
                            });
                            // console.log(JSON.stringify(data));
                        }
                    }
                });
            }
            else
                $.ligerDialog.warn('请先选择一个需要编辑的配置信息');
        }
        //删除
        function deleteData() {
            var arrck = grid.getSelectedRow();
            if (arrck) {
                var ar = new Array();
                ar[0] = { name: "id", value: arrck.PZBM };
                ar[1] = { name: "cs", value: arrck.CONFIGNAME };
                ar[2] = { name: "t", value: "DelData" };
                $.ligerDialog.confirm('确定是否删除?', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: '/Pages/SystemMgr/SysConfig.aspx',
                            data: ar,
                            dataType: 'json',
                            timeout: 5000,
                            cache: false,
                            beforeSend: function () { },
                            error: function (xhr) {
                                $.ligerDialog.error('网络连接错误');
                                return false;
                            },
                            success: function (data) {
                                if (data.t == "win") {
                                    var prowdata = grid.getSelectedRow();
                                    grid.deleteRow(prowdata);
                                    $.ligerDialog.success(data.v);
                                } else
                                    $.ligerDialog.error(data.v);
                            }
                        });
                    }
                });
            } else
                $.ligerDialog.warn('请先选择一个需要删除的单位');
        }

        function ConfigTypeValue(id, value) {
            var ar = new Array();
            ar[0] = { name: "t", value: "ConfigTypeValue" };
            ar[1] = { name: "id", value: id };
            $.ajax({
                type: "POST",
                url: '/Pages/SystemMgr/SysConfig.aspx',
                data: ar,
                dataType: 'json',
                timeout: 5000,
                cache: false,
                beforeSend: function () { },
                error: function (xhr) {
                    $.ligerDialog.error('网络连接错误');
                    return false;
                },
                success: function (data) {
                    if (data.t == "win") {
                        var input = "<input class=\"l-text\" id=\"txt_value\" type=\"text\" name=\"txt_value\" maxlength=\"200\" />";
                        $("#txt_value").closest("td").html(input);
                        $("#txt_value").closest("td").next().html(data.k);
                        if (data.v == "date")
                            $("#txt_value").ligerDateEditor({ showTime: true, labelAlign: 'left', initValue: value });
                        else if (data.v == "number")
                            $("#txt_value").ligerTextBox({ nullText: "不能为空", number: true, value: value });
                        else if (data.v == "select") {                            
                            $("#txt_value").ligerComboBox({initValue:value, data: [{ text: '直连模式', id: '0' }, { text: '路由模式', id: '1'}], valueFieldID: "txt_value_val" });
                        }
                        else
                            $("#txt_value").ligerTextBox({ nullText: "不能为空", value: value });
                        $("#txt_value").focus();
                    } else
                        $.ligerDialog.error(data.v);
                }
            });
        }

        $(document).ready(function () {

            //点击搜索按钮
            $("#btn_search").click(function () {
                if (grid.options.page > 1) {
                    gridSetParm();
                    grid.changePage("first"); //重置到第一页         
                } else {
                    grid.loadServerData({
                        t: "ListBind",
                        key: $("#txt_key").val(),
                        page: 1, pagesize: grid.options.pageSize
                    });
                }
            });

        });

        function gridSetParm() {
            grid.setParm("key", $("#txt_key").val());
        }
    </script>
</body>
  <script src="/LigerUI/lib/LigerUI/JScript1.js" type="text/javascript"></script>
</html>
