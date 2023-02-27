import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/vendororderlist.dart';

class CommissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text('Commission Order List',
            style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: CommissionPageT(),
    );
  }
}

class CommissionPageT extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommissionPageTState();
  }
}

class CommissionPageTState extends State<CommissionPageT> {
  List<VendorOrderList> orederList = [];

  bool isFetch = true;
  bool isSet = false;

  dynamic curency;

  @override
  void initState() {
    getTodayOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (orederList != null && orederList.length > 0)
        ? Stack(
            children: [
              ListView.builder(
                itemCount: orederList.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        Divider(
                          color: kCardBackgroundColor,
                          thickness: 8.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                  'images/user.png',
                                  width: 33.7,
                                  height: 42.3,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text:
                                          '${orederList[index].user_name}\n\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: 13.3,
                                              letterSpacing: 0.07),
                                    ),
                                    TextSpan(
                                        text:
                                            'Order - #${orederList[index].cart_id}\n\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .copyWith(
                                                fontSize: 12.3,
                                                letterSpacing: 0.07)),
                                    TextSpan(
                                      text:
                                          'Order Amount - ${curency} ${orederList[index].total_price}\n\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: 12.3,
                                              letterSpacing: 0.07),
                                    ),
                                    TextSpan(
                                      text:
                                          'Commission - ${curency} ${orederList[index].comission_price}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                              fontSize: 12.3,
                                              letterSpacing: 0.07),
                                    ),
                                  ]),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${(orederList[index].status == "1" || orederList[index].status == "Pending") ? 'In process' : orederList[index].status}\n\n',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .copyWith(
                                                  fontSize: 11.7,
                                                  letterSpacing: 0.06,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                    ),
                                    Visibility(
                                      visible: (orederList[index].status ==
                                                  "pending" ||
                                              orederList[index].status ==
                                                  "Pending")
                                          ? true
                                          : false,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(color: kGreen)),
                                          color: kGreen,
                                          onPressed: () {
                                            raiseClaim(index,
                                                orederList[index].cart_id);
                                          },
                                          child: Text(
                                            'Claim',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    color: kWhiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11.7,
                                                    letterSpacing: 0.06),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: kCardBackgroundColor,
                          thickness: 1.0,
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
              Visibility(
                visible: isSet,
                child: GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 80,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(253, 254, 254, 0.3),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isFetch ? CircularProgressIndicator() : Container(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    isFetch
                        ? 'Fetching data please wait'
                        : 'No orders history found!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
  }

  void getTodayOrders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      curency = pref.getString('curency');
    });
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    var todayOrderUrl = vendor_order_list;
    client
        .post(todayOrderUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      if (value.statusCode == 200) {
        var jsonDatas = jsonDecode(value.body);
        if (jsonDatas['status'] == "1") {
          var jsonData = jsonDatas['data'] as List;
          List<VendorOrderList> oreder =
              jsonData.map((e) => VendorOrderList.fromJson(e)).toList();
          if (oreder != null && oreder.length > 0) {
            setState(() {
              isFetch = false;
              orederList.clear();
              orederList = oreder;
            });
          } else {
            setState(() {
              isFetch = false;
              orederList.clear();
              orederList = null;
            });
          }
        } else {
          setState(() {
            isFetch = false;
          });
        }
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }

  void raiseClaim(int index, cartId) async {
    setState(() {
      isSet = true;
    });
    var client = http.Client();
    var todayOrderUrl = send_request;
    client.post(todayOrderUrl, body: {'cart_id': '${cartId}'}).then((value) {
      if (value.statusCode == 200) {
        var jsonDatas = jsonDecode(value.body);
        if (jsonDatas['status'] == "1") {
          setState(() {
            orederList[index].status = "1";
          });
          Toast.show(jsonDatas['message'], context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        } else {
          Toast.show(jsonDatas['message'], context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        }
      }
      setState(() {
        isSet = false;
      });
    }).catchError((e) {
      Toast.show('Something went wrong!..', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      setState(() {
        isSet = false;
      });
      print(e);
    });
  }
}
