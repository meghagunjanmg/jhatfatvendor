import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/todayorderbean.dart';

class OrderPage extends StatefulWidget {

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'NEW ORDERS'),
    Tab(text: 'COMPLETED ORDERS'),
  ];
  TabController tabController;
  List<TodayOrderDetails> orederList = [];

  bool isFetch = true;
  bool isRun = false;

  dynamic curency;

  dynamic status = 0;

  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    getSharedPref();
    WidgetsBinding.instance.addObserver(this);

    hitStatusServiced();
    getTodayOrders();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print(tabController.index);
        setState(() {
          isFetch = true;
          if (orederList != null) {
            orederList.clear();
          }
          orederList = null;
        });
        if (tabController.index == 0) {
          getTodayOrders();
        } else if (tabController.index == 1) {
          getCompleteOrders();
        }
      }
    });
  }

  void hitStatusServiced() async {
    setState(() {
      isRun = true;
    });
    preferences = await SharedPreferences.getInstance();
    var vendorId = preferences.getInt('vendor_id');
    print('${status} - ${vendorId}');
    var client = http.Client();
    var statusUrl = store_current_status;
    client.post(statusUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      setState(() {
        isRun = false;
      });
      if (value.statusCode == 200 && value.body != null) {
        var jsonData = jsonDecode(value.body);
        print('${jsonData.toString()}');
        if (jsonData['status'] == 1) {
          var sats = jsonData['data'][0];
          print('----  --${sats.toString()}');
          var sat = sats['online_status'];
          print('${sat}');
          if (sat == "on" || sat == "On" || sat == "ON") {
            preferences.setInt('duty', 1);
            setState(() {
              status = 1;
            });
          } else if (sat == "off" || sat == "Off" || sat == "OFF") {
            preferences.setInt('duty', 0);
            setState(() {
              status = 0;
            });
          }
        }
        Toast.show(jsonData['message'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isRun = false;
      });
    });
  }

  void getSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('duty')) {
      setState(() {
        print('${preferences.getInt('duty')}');
        setState(() {
          status = preferences.getInt('duty');
        });
      });
    }
  }
  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print("REFRESH");
          hitStatusServiced();
          if (tabController.index == 0) {
            getTodayOrders();
          } else if (tabController.index == 1) {
            getCompleteOrders();
          }
        }
        break;
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
      // TODO: Handle this case
        break;
      case AppLifecycleState.detached:
      // TODO: Handle this case.
        WidgetsBinding.instance.removeObserver(this);

        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    getSharedPref();
    return DefaultTabController(
      length: tabs.length,
      child:
      Scaffold(
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            centerTitle: false,
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              isRun
                  ? CupertinoActivityIndicator(
                      radius: 15,
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: (status == 1) ? kRed : kGreen)),
                  color: (status == 1) ? kRed : kGreen,
                  onPressed: () {
                    if (!isRun) {
                      hitStatusService();
                    }
                  },
                  child: Text(
                    '${status == 1 ? 'Go Offline' : 'Go Online'}',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.7,
                        letterSpacing: 0.06),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: TabBar(
                controller: tabController,
                tabs: tabs,
                isScrollable: true,
                labelColor: kMainColor,
                unselectedLabelColor: kLightTextColor,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
              ),
            ),
          ),
        ),
        body:
        TabBarView(
          controller: tabController,
          children: tabs.map((Tab tab) {
            return
              (orederList != null && orederList.length > 0)
                ?
              RefreshIndicator(
                  child:
                  ListView.builder(
                    itemCount: orederList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Divider(
                              color: kCardBackgroundColor,
                              thickness: 8.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (orederList[index].paymentMethod == null ||
                                    orederList[index].paymentStatus == null ||
                                    orederList[index].orderStatus ==
                                        "Cancel" ||
                                    orederList[index].orderStatus ==
                                        "Cancelled") {
                                } else {
                                  Navigator.pushNamed(
                                      context, PageRoutes.orderInfoPage,
                                      arguments: {
                                        'orderdetails': orederList[index],
                                        'curency': curency,
                                      }).then((value) {
                                    // print('${tabController.index}');
                                    int indi = tabController.index;
                                    if (indi == 0) {
                                      setState(() {
                                        isFetch = true;
                                        if (orederList != null) {
                                          orederList.clear();
                                        }
                                        orederList = null;
                                      });
                                      getTodayOrders();
                                    } else if (indi == 1) {
                                      setState(() {
                                        isFetch = true;
                                        if (orederList != null) {
                                          orederList.clear();
                                        }
                                        orederList = null;
                                      });
                                      getCompleteOrders();
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                child: ListTile(
                                  leading: Image.asset(
                                    'images/user.png',
                                    scale: 2.5,
                                    width: 33.7,
                                    height: 42.3,
                                  ),
                                  title: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            '${orederList[index].userName}\n\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontSize: 13.3,
                                                letterSpacing: 0.07),
                                      ),
                                      TextSpan(
                                        text:
                                            '${orederList[index].deliveryDate}' " "'${orederList[index].timeSlot}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 11.7,
                                                letterSpacing: 0.06,
                                                fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                  trailing: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            '${curency} ${orederList[index].remainingPrice}\n\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontSize: 13.3,
                                                letterSpacing: 0.07),
                                      ),
                                      TextSpan(
                                        text:
                                            '${orederList[index].paymentMethod}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 11.7,
                                                letterSpacing: 0.06,
                                                fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: kCardBackgroundColor,
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                      'Order num #${orederList[index].cartId}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              fontSize: 11.7,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                              color: Color(0xff393939))),
                                  Spacer(),
                                  Text(
                                      '${(orederList[index].total_items != null && orederList[index].total_items > 0) ? orederList[index].total_items : 0} Items',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              fontSize: 11.7,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                              color: Color(0xff393939))),

                                  Spacer(),

                                  Text('${orederList[index].orderStatus}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              color: Color(0xffffa025),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.7,
                                              letterSpacing: 0.06)),
                                ],
                              ),
                            ),
                            Divider(
                              color: kCardBackgroundColor,
                              thickness: 8.0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onRefresh: () {
              return Future.delayed(
                  Duration(seconds: 1),
                      () {
                        getSharedPref();
                        hitStatusServiced();
                        if (tabController.index == 0) {
                          getTodayOrders();
                        } else if (tabController.index == 1) {
                          getCompleteOrders();
                        }
                  }
              );
            },
              )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isFetch ? CircularProgressIndicator() : Container(),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            isFetch
                                ? 'Fetching data please wait'
                                : (tabController.index == 0)
                                    ? 'No Orders for Today'
                                    : 'No Completed Orders',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
          }).toList(),
        ),
      ),
    );
  }

  void hitStatusService() async {
    setState(() {
      isRun = true;
    });
    preferences = await SharedPreferences.getInstance();
    var vendorId = preferences.getInt('vendor_id');
    dynamic statuss = preferences.getInt('duty');
    if (preferences.containsKey('duty')) {
      statuss = preferences.getInt('duty');
    } else {
      statuss = status;
    }

    print("STATUS "+  '${statuss} - ${status} - ${vendorId}');
    var client = http.Client();
    var statusUrl = store_status;
    client.post(statusUrl, body: {
      'vendor_id': '${vendorId}',
      'status': (statuss == 1) ? 'off' : 'on'
    }).then((value) {
      setState(() {
        isRun = false;
      });
      if (value.statusCode == 200 && value.body != null) {
        var jsonData = jsonDecode(value.body);
        print('${jsonData.toString()}');
        if (jsonData['status'] == "1") {
          print('----  --${jsonData['status']}');
          // var sats = jsonData['data'][0];
          // print('----  --${sats.toString()}');
          var sat = jsonData['Status'];
          print('----  --${sat}');
          if (sat == "on" || sat == "On" || sat == "ON") {
            preferences.setInt('duty', 1);
            setState(() {
              status = 1;
            });
          } else if (sat == "off" || sat == "Off" || sat == "OFF") {
            preferences.setInt('duty', 0);
            setState(() {
              status = 0;
            });
          }
          // if(jsonData['Status'] == "on" || jsonData['Status'] == "On" || jsonData['Status'] == "ON"){
          //   preferences.setInt('duty', 1);
          // }else if(jsonData['Status'] == "off" || jsonData['Status'] == "Off" || jsonData['Status'] == "OFF"){
          //   preferences.setInt('duty', 0);
          // }
        } else {
          preferences.setInt('duty', statuss);
        }
        Toast.show(jsonData['message'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        setState(() {
          isRun = false;
          status = preferences.getInt('duty');
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isRun = false;
      });
    });
  }

  void getTodayOrders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      curency = pref.getString('curency');
    });
    orederList = [];
    var vendorId = pref.getInt('vendor_id');
    print('vendor_id ${vendorId}');
    var client = http.Client();
    var todayOrderUrl = store_today_order;
    client
        .post(todayOrderUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      print("TODAYS "+value.statusCode.toString()+ " "+value.body.toString());

      if (value.statusCode == 200) {
        if (value.body
                .toString()
                .contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body
                .toString()
                .contains("[{\"no_order\":\"no orders found\"}]")) {
          setState(() {
            orederList.clear();
            isFetch = false;
          });
        }

        else
        {
          var jsonData = jsonDecode(value.body) as List;
          List<TodayOrderDetails> oreder =
              jsonData.map((e) => TodayOrderDetails.fromJson(e)).toList();
          print("TODAYS "+'${oreder.toString()}');
          if (oreder != null && oreder.length > 0) {
            setState(() {
              isFetch = false;
              orederList = List.from(oreder);
            });
          } else {
            setState(() {
              orederList.clear();
              isFetch = false;
            });
          }
        }
      }
      else {
        setState(() {
          orederList.clear();
          isFetch = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print("ERRORS "+e.toString());
    });
  }

  void getCompleteOrders() async {
    orederList = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    var todayOrderUrl = store_complete_order;
    client
        .post(todayOrderUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        if (value.body
                .toString()
                .contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body
                .toString()
                .contains("[{\"no_order\":\"no orders found\"}]")) {
          setState(() {
            orederList.clear();
            isFetch = false;
          });
        } else {
          var jsonData = jsonDecode(value.body) as List;
          List<TodayOrderDetails> oreder =
              jsonData.map((e) => TodayOrderDetails.fromJson(e)).toList();
          print('${oreder.toString()}');
          if (oreder != null && oreder.length > 0) {
            setState(() {
              isFetch = false;
              orederList = List.from(oreder);
            });
          } else {
            setState(() {
              orederList.clear();
              isFetch = false;
            });
          }
        }
      } else {
        setState(() {
          orederList.clear();
          isFetch = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }
}
