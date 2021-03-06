import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/pages/common/app_upgrade.dart';
import 'package:flutter_ho/src/pages/common/user_helper.dart';
import 'package:flutter_ho/src/pages/login/login_page.dart';
import 'package:flutter_ho/src/utils/log_utils.dart';
import 'package:flutter_ho/src/utils/navigator_utils.dart';
import 'package:package_info/package_info.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/12/28.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
/// 代码清单
///代码清单
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置中心"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //检查更新功能
          buildCheckVersion(),
          //退出登录
          buildLoginWidget(),
        ],
      ),
    );
  }

  ListTile buildLoginWidget() {
    bool isLogin = UserHepler.getInstance.isLogin;
    return ListTile(
      //显示标题
      title: Text(isLogin ? '退出登录' : "去登录"),
      //右侧按钮
      trailing: Icon(Icons.arrow_forward_ios),
      //左侧箭头
      leading: Icon(Icons.cancel_presentation_sharp),
      //点击事件
      onTap: () {
        if (isLogin) {
          exitFunction();
        } else {
          NavigatorUtils.pushPage(context: context, targPage: LoginPage());
        }
      },
    );
  }

  void exitFunction() async {
    bool isExit = await showCupertinoDialog(
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("温馨提示"),
            content: Container(
              padding: EdgeInsets.all(16),
              child: Text("确定退出吗???"),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text("退出"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
        context: context);

    if (isExit) {
      UserHepler.getInstance.clear();
      Navigator.of(context).pop(true);
    }
  }

  buildCheckVersion() {
    //第二部分检查更新功能
    if (Platform.isAndroid) {
      return ListTile(
        leading: Icon(Icons.web_sharp),
        title: Text("检查更新"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          check();
        },
      );
    } else {
      return Container();
    }
  }

  void check() async {
    //获取当前App的版本信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    LogUtils.e("appName $appName");
    LogUtils.e("packageName $packageName");
    LogUtils.e("version $version");
    LogUtils.e("buildNumber $buildNumber");

    checkAppVersion(context, showToast: true);
  }
}
