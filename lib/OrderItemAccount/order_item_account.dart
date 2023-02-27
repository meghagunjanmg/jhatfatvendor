import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor/OrderItemAccount/Account/UI/account_page.dart';
import 'package:vendor/OrderItemAccount/Order/UI/order_page.dart';
import 'package:vendor/Pages/items.dart';
import 'package:vendor/UI/animated_bottom_bar.dart';
import 'package:vendor/baseurl/baseurl.dart';

class OrderItemAccount extends StatefulWidget {
  @override
  _OrderItemAccountState createState() => _OrderItemAccountState();
}

class _OrderItemAccountState extends State<OrderItemAccount> {
  int _currentIndex = 0;

  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    getCurrency();
    super.initState();
  }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('gomarket');
      double newVersion = double.parse(
          remoteConfig.getString('gomarket').trim().replaceAll(".", ""));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(APP_STORE_URL),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(PLAY_STORE_URL),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getCurrency() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var currencyUrl = currency;
    var client = http.Client();
    client.get(currencyUrl).then((value) {
      print('${value.body}');
      var jsonData = jsonDecode(value.body);
      if (value.statusCode == 200 && jsonData['status'] == "1") {
        print('${jsonData['data'][0]['currency_sign']}');
        preferences.setString(
            'curency', '${jsonData['data'][0]['currency_sign']}');
      }
    }).catchError((e) {
      print(e);
    });
  }

  final List<BarItem> barItems = [
    BarItem(
      text: 'Order',
      image: bottomIconOrder,
    ),
    BarItem(
      text: 'Product',
      image: bottomIconItem,
    ),
    BarItem(
      text: 'Account',
      image: bottomIconAccount,
    ),
  ];

  final List<Widget> _children = [
    OrderPage(),
    ItemsPage(),
    AccountPage(),
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static String bottomIconItem = 'images/footermenu/ic_item.png';

  static String bottomIconOrder = 'images/footermenu/ic_orders.png';

  static String bottomIconAccount = 'images/footermenu/ic_profile.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: AnimatedBottomBar(
          barItems: barItems,
          onBarTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
