import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_appbar.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/parcel/parcelbean/chargelistbean.dart';
import 'package:vendor/parcel/parcelbean/citybean.dart';

class ChargeCountryPage extends StatefulWidget {
  @override
  _ChargeCountryPageState createState() => _ChargeCountryPageState();
}

class _ChargeCountryPageState extends State<ChargeCountryPage>
    with SingleTickerProviderStateMixin {
  List<City> cityList = [];
  List<ChargeListBean> chargeBean = [];
  int selected = null;
  dynamic curency;
  List<Tab> tabs = <Tab>[
    Tab(
      text: 'Country',
    ),
    Tab(
      text: 'Charge List',
    )
  ];
  TabController tabController;

  var value = 0;

  dynamic isFetch = false;
  dynamic isDelete = false;
  dynamic vendor_id = '';

  @override
  void initState() {
    getCityList();
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (tabController.index == 0) {
          setState(() {
            cityList.clear();
          });
          getCityList();
        } else if (tabController.index == 1) {
          setState(() {
            chargeBean.clear();
          });
          getChargeList();
        }
      }
    });
  }

  void getCityList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    setState(() {
      curency = pref.getString('curency');
      vendor_id = vendorId;
      isFetch = true;
    });
    var client = http.Client();
    var urlhit = parcel_city;
    client.post(urlhit, body: {'vendor_id': '${vendorId}'}).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsLst = jsonData['data'] as List;
          List<City> cityFetcjList =
              jsLst.map((e) => City.fromJson(e)).toList();
          cityList.clear();
          cityList = List.from(cityFetcjList);
        }
      }
      setState(() {
        isFetch = false;
      });
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }

  void getChargeList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    setState(() {
      isFetch = true;
    });
    var client = http.Client();
    var urlhit = parcel_listcharges;
    client.post(urlhit, body: {'vendor_id': '${vendorId}'}).then((value) {
      if (value.statusCode == 200) {
        print('${value.body}');
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsLst = jsonData['data'] as List;
          List<ChargeListBean> cityFetcjList =
              jsLst.map((e) => ChargeListBean.fromJson(e)).toList();
          chargeBean.clear();
          chargeBean = List.from(cityFetcjList);
        }
      }
      setState(() {
        isFetch = false;
      });
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    // loadData();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: CustomAppBar(
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  'Country/Charge List',
                  style: TextStyle(color: kMainTextColor),
                )),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: kMainColor,
                  ),
                  onPressed: () {}),
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: tabs,
              isScrollable: true,
              labelColor: kMainColor,
              unselectedLabelColor: kLightTextColor,
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 9,
                  child: TabBarView(
                    controller: tabController,
                    children: tabs.map((tab) {
                      return (tabController.index == 0)
                          ? (cityList != null && cityList.length > 0)
                              ? ListView.separated(
                                  itemCount: cityList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                              child: Text(
                                                  '${cityList[index].city_name}')),
                                          IconButton(
                                              icon:
                                                  Icon(Icons.delete, size: 24),
                                              onPressed: () {
                                                // showAlertDialog(context, cityList[index].city_id);
                                              })
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                )
                              : isFetch
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Row(
                                        children: [
                                          CupertinoActivityIndicator(
                                            radius: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Fetching products please wait....',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: kMainColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Text(
                                        'No Data available for this category',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: kMainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                          : (chargeBean != null && chargeBean.length > 0)
                              ? ListView.separated(
                                  itemCount: chargeBean.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PageRoutes.editcharge,
                                            arguments: {
                                              'chargeBean': chargeBean[index],
                                              'currency': curency,
                                              'vendor_id': vendor_id
                                            }).then((value) {
                                          getChargeList();
                                        });
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${chargeBean[index].city_name}'),
                                                  Text(
                                                      '${curency} ${chargeBean[index].parcel_charge}'),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.delete,
                                                    size: 24),
                                                onPressed: () {
                                                  showAlertDialog(
                                                      context,
                                                      chargeBean[index]
                                                          .charge_id);
                                                })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                )
                              : isFetch
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Row(
                                        children: [
                                          CupertinoActivityIndicator(
                                            radius: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Fetching products please wait....',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: kMainColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Text(
                                        'No Data available for this category',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: kMainColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    );
                    }).toList(),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 10.0,
                    ))
              ],
            ),
            Visibility(
              visible: isDelete,
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: MediaQuery.of(context).size.height - 110,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(253, 254, 254, 0.3),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Visibility(
          visible: (tabController != null && tabController.index == 1)
              ? true
              : false,
          child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, PageRoutes.addcharges,
                    arguments: {'vendor_id': vendor_id, 'currency': curency})
                .then((value) {
              if (tabController.index == 0) {
                getCityList();
              } else if (tabController.index == 1) {
                getChargeList();
              }
            }),
            tooltip: 'ADD PRODUCT',
            child: Icon(
              Icons.add,
              size: 15.7,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void hitDeleteButton(BuildContext context, chargeId) {
    setState(() {
      isDelete = true;
    });
    var client = http.Client();
    var storeProduct;
    if (tabController.index == 1) {
      storeProduct = parcel_deletecharges;
    } else {
      storeProduct = parcel_deletecharges;
    }
    final url = Uri.parse(storeProduct);
    client.post(url, body: {'charge_id': '${chargeId}'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          Toast.show(jsonData['message'], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
          if (tabController.index == 1) {
            getChargeList();
          } else if (tabController.index == 0) {
            getCityList();
          }
        } else {
          Toast.show('Something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
      }
      setState(() {
        isDelete = false;
      });
    }).catchError((e) {
      Toast.show('Something went wrong!', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
      setState(() {
        isDelete = false;
      });
      print(e);
    });
  }

  showAlertDialog(BuildContext context, chargeId) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        hitDeleteButton(context, chargeId);
      },
      child: Material(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'Yes',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'No',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text("Alert"),
      content: Text("Are you sure to want delete charge."),
      actions: [clear, no],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
