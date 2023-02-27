import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/custom_appbar.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/restaurantbean/todayorderrest.dart';
import 'package:vendor/orderbean/vendorboy.dart';

class OrderInfoPharma extends StatefulWidget {
  @override
  _OrderInfoPharmaState createState() => _OrderInfoPharmaState();
}

class _OrderInfoPharmaState extends State<OrderInfoPharma> {
  TodayOrderRestaurant orderDetails;
  dynamic curency;

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    final Map<String, Object> dataObject =
        ModalRoute.of(context).settings.arguments;
    setState(() {
      orderDetails = dataObject['orderdetails'];
      curency = dataObject['curency'];
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(144.0),
        child: CustomAppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: kMainColor,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          titleWidget: Text(
            'Order Id #${orderDetails.cart_id}',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 13.3, letterSpacing: 0.07),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Hero(
              tag: 'Customer',
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: Image.asset(
                    'images/user.png',
                    scale: 2.5,
                    height: 42.3,
                    width: 33.7,
                  ),
                  title: Text(
                    '${orderDetails.user_name}',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontSize: 13.3, letterSpacing: 0.07),
                  ),
                  subtitle: Text(
                    '${orderDetails.delivery_date} | ${orderDetails.time_slot}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 11.7, letterSpacing: 0.06),
                  ),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: kMainColor,
                            size: 18.0,
                          ),
                          onPressed: () {
                            if (orderDetails.user_number != null &&
                                orderDetails.user_number.toString().length >
                                    9) {
                              _launchURL("tel://${orderDetails.user_number}");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            primary: true,
            children: <Widget>[
              Divider(
                color: kCardBackgroundColor,
                thickness: 8.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text('ITEM(S)',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Color(0xffadadad), fontWeight: FontWeight.bold)),
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: ListView.builder(
                    itemCount: orderDetails.order_details.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              '${orderDetails.order_details[index].product_name}\n${orderDetails.order_details[index].description}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              '${orderDetails.order_details[index].quantity} ${orderDetails.order_details[index].unit} x ${orderDetails.order_details[index].qty}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            trailing: Text(
                              '${curency} ${orderDetails.order_details[index].price}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 1.0,
                          ),
                        ],
                      );
                    }),
              ),
              Visibility(
                visible: (orderDetails.addons != null &&
                        orderDetails.addons.length > 0)
                    ? true
                    : false,
                child: Column(
                  children: [
                    Divider(
                      color: kCardBackgroundColor,
                      thickness: 8.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text('ADDON(S)',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Color(0xffadadad),
                              fontWeight: FontWeight.bold)),
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: ListView.builder(
                          itemCount: orderDetails.addons.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    '${orderDetails.addons[index].product_name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    '${orderDetails.addons[index].addon_name}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  trailing: Text(
                                    '${curency} ${orderDetails.addons[index].addon_price}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Divider(
                                  color: kCardBackgroundColor,
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 8.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text('PAYMENT INFO',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: kDisabledColor, fontWeight: FontWeight.bold)),
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sub Total',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        '${curency} ${orderDetails.price_without_delivery}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 1.0,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Service Fee',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        '${curency} ${orderDetails.delivery_charge}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 1.0,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total order price',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${curency} ${orderDetails.total_price}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 1.0,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Remaming Amount',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${curency} ${orderDetails.remaining_price}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 1.0,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${orderDetails.payment_method}',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ]),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 1.0,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Payment Status',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${orderDetails.payment_status}',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ]),
              ),
              SizedBox(
                height: 7.0,
              ),
              Container(
                height: 180.0,
                color: kCardBackgroundColor,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  color: kWhiteColor,
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22.0,
                      backgroundImage: AssetImage('images/profile.png'),
                    ),
                    title: Text(
                      '${orderDetails.delivery_boy_name != null ? orderDetails.delivery_boy_name : 'Not Assigned Yet'}',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Delivery Partner Assigned',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 11.7, letterSpacing: 0.06),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.call,
                        color: kMainColor,
                        size: 17.0,
                      ),
                      onPressed: () {
                        if (orderDetails.delivery_boy_num != null &&
                            orderDetails.delivery_boy_num.toString().length >
                                9) {
                          _launchURL("tel://${orderDetails.delivery_boy_num}");
                        }
                      },
                    ),
                  ),
                ),
                BottomBar(
                    text:
                        '${orderDetails.delivery_boy_name != null ? orderDetails.delivery_boy_name : 'Not Assigned Yet'}',
                    onTap: () {
                      if (orderDetails.order_status == "pending" ||
                          orderDetails.order_status == "Pending") {
                        hitFindDriver(context, pr);
                      } else {
                        Toast.show('Already assign to delivery boy', context,
                            duration: Toast.LENGTH_SHORT);
                      }
                      // Navigator.pop(context);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  showDialogList(
      context, List<DeliveryBoyList> list, lat, lng, ProgressDialog pr) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 500,
              color: kWhiteColor,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      showProgressDialog('Please wait assiging driver', pr);
                      pr.show();
                      hitAssignOrder(
                          context,
                          pr,
                          list[index].delivery_boy_id,
                          list[index].delivery_boy_name,
                          list[index].delivery_boy_phone);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Boy - ${list[index].delivery_boy_name} (${list[index].delivery_boy_status})\nPhone - ${list[index].delivery_boy_phone}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kMainTextColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 6,
                    color: kCardBackgroundColor,
                  );
                },
                itemCount: list.length,
              ),
            ),
          );
        });
  }

  showProgressDialog(String text, ProgressDialog pr) {
    pr.style(
        message: '${text}',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  }

  void hitFindDriver(context, ProgressDialog pr) async {
    showProgressDialog('Please wait finding delivery boy', pr);
    pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    var assignUrl = store_delivery_boy;
    client.post(assignUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      pr.hide();
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsond = jsonData['data'] as List;
          List<DeliveryBoyList> delList =
              jsond.map((e) => DeliveryBoyList.fromJson(e)).toList();
          if (delList != null && delList.length > 0) {
            showDialogList(
                context, delList, pref.getString('lat'), pref.get('lng'), pr);
          } else {
            Toast.show('Add delivery boy', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          }
        } else {
          Toast.show('Add delivery boy', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  void hitAssignOrder(context, ProgressDialog pr, dBoyId, delivery_boy_name,
      delivery_phone) async {
    var client = http.Client();
    var assignUrl = assigned_store_order;
    client.post(assignUrl, body: {
      'delivery_boy_id': '${dBoyId}',
      'order_id': '${orderDetails.order_id}'
    }).then((value) {
      pr.hide();
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          setState(() {
            orderDetails.delivery_boy_name = delivery_boy_name;
            orderDetails.delivery_boy_num = delivery_phone;
          });
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        }
      }
    }).catchError((e) {
      print(e);
      pr.hide();
    });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
