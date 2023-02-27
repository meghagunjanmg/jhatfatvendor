import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/parcel/parcelbean/todayorderparcel.dart';

class InsightPageParcel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
            Text('Order History', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
        actions: <Widget>[
          // Row(
          //   children: <Widget>[
          //     Text(
          //       'TODAY',
          //       style: Theme.of(context).textTheme.headline4.copyWith(
          //           fontSize: 15.0, letterSpacing: 1.5, color: kMainColor),
          //     ),
          //     SizedBox(
          //       width: 16.0,
          //     ),
          //     // Icon(
          //     //   Icons.keyboard_arrow_down,
          //     //   color: kMainColor,
          //     // ),
          //     // SizedBox(
          //     //   width: 20.0,
          //     // )
          //   ],
          // )
        ],
      ),
      body: InsightParcel(),
    );
  }
}

class InsightParcel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InsightStateParcel();
  }
}

class InsightStateParcel extends State<InsightParcel> {
  List<TodayOrderParcel> orederList = [];

  bool isFetch = true;

  dynamic curency;

  @override
  void initState() {
    getTodayOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (orederList != null && orederList.length > 0)
        ?
    ListView.builder(
      itemCount: orederList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            child: Column(
              children: [
                Divider(
                  color: kCardBackgroundColor,
                  thickness: 8.0,
                ),
                Padding(
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
                          '${orederList[index].pickup_date}',
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
                          '${curency} ${(double.parse('${orederList[index].distance}') > 1) ? (double.parse('${orederList[index].charges}') * double.parse('${orederList[index].distance}')) : double.parse('${orederList[index].charges}')}\n\n',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(
                              fontSize: 13.3,
                              letterSpacing: 0.07),
                        ),
                        TextSpan(
                          text:
                          '${orederList[index].payment_method}',
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
                Divider(
                  color: kCardBackgroundColor,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 5, top: 5, bottom: 5),
                        child: Text('Pickup Address',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.06,
                                color: kMainColor)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_city,
                            size: 30,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Text(
                                ' ${orederList[index].source_add}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    fontSize: 11.7,
                                    fontWeight:
                                    FontWeight.w500,
                                    letterSpacing: 0.06,
                                    color:
                                    Color(0xff393939))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 5, top: 5, bottom: 5),
                        child: Text('Destination Address',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.06,
                                color: kMainColor)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_city,
                            size: 30,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Text(
                                '${orederList[index].destination_add}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                    fontSize: 11.7,
                                    fontWeight:
                                    FontWeight.w500,
                                    letterSpacing: 0.06,
                                    color:
                                    Color(0xff393939))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: kCardBackgroundColor,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text(
                          'Order num #${orederList[index].cart_id}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              fontSize: 11.7,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.06,
                              color: Color(0xff393939))),
                      Spacer(),
                      Text('1 Parcel',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(
                              fontSize: 11.7,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.06,
                              color: Color(0xff393939))),
                      Spacer(),
                      Text('${orederList[index].order_status}',
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
          ),
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
    var todayOrderUrl = parcel_complete_order;
    client
        .post(todayOrderUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      if (value.statusCode == 200) {
        if (value.body
                .toString()
                .contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body
                .toString()
                .contains("[{\"no_order\":\"no orders found\"}]")) {
          print('${value.body}');
          setState(() {
            isFetch = false;
            orederList.clear();
            orederList = null;
          });
        } else {
          var jsonData = jsonDecode(value.body) as List;
          List<TodayOrderParcel> oreder =
              jsonData.map((e) => TodayOrderParcel.fromJson(e)).toList();
          print('${oreder.toString()}');
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
        }
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }
}
