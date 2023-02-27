import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/parcel/parcelbean/citybean.dart';

class AddChargesStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    dynamic vendor_id = dataLis['vendor_id'];
    dynamic currency = dataLis['currency'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text('Add Charge', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: AddCharges(vendor_id, currency),
    );
  }
}

class AddCharges extends StatefulWidget {
  final dynamic vendor_id;
  final dynamic currency;

  AddCharges(this.vendor_id, this.currency);

  @override
  State<StatefulWidget> createState() {
    return AddChargesState();
  }
}

class AddChargesState extends State<AddCharges> {
  TextEditingController productNameC = TextEditingController();
  TextEditingController productQuantityC = TextEditingController();
  List<City> cityList = [];
  City subCity;
  bool isFetch = false;

  @override
  void initState() {
    getCityList();
    super.initState();
  }

  void getCityList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              Divider(
                color: kCardBackgroundColor,
                thickness: 6.7,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'City List',
                            style: TextStyle(fontSize: 13, color: kHintColor),
                          ),
                          DropdownButton<City>(
                            isExpanded: true,
                            value: subCity,
                            underline: Container(
                              height: 1.0,
                              color: kMainTextColor,
                            ),
                            items: cityList.map((values) {
                              return DropdownMenuItem<City>(
                                value: values,
                                child: Text(values.city_name),
                              );
                            }).toList(),
                            onChanged: (area) {
                              setState(() {
                                subCity = area;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Charges Price & Description',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'CHARGE PRICE',
                      hint: 'Enter charges Price',
                      controller: productNameC,
                      keyboardType: TextInputType.number,
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'CHARGE DESCRIPTION',
                      hint: 'Enter Description',
                      controller: productQuantityC,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomBar(
            text: "Add City Charge",
            onTap: () {
              if (!isFetch) {
                showProgressDialog('Adding city charge\nPlease wait...', pr);
                newHitService(pr, context);
              }
            },
          ),
        )
      ],
    );
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

  void newHitService(ProgressDialog pr, contexts) async {
    if (productNameC.text.isNotEmpty && productQuantityC.text.isNotEmpty) {
      SharedPreferences profilePref = await SharedPreferences.getInstance();
      var storeId = profilePref.getInt("vendor_id");
      pr.show();
      var client = http.Client();
      var urlhit = parcel_addcharges;
      client.post(urlhit, body: {
        'city_id': '${subCity.city_id}',
        'charges': '${productNameC.text}',
        'description': '${productQuantityC.text}',
        'vendor_id': '${storeId}',
      }).then((value) {
        print('${value.body}');
        if (value.statusCode == 200) {
          var jsonData = jsonDecode(value.body);
          if (jsonData['status'] == "1") {
            Toast.show('Charge Added...', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            productNameC.clear();
            productQuantityC.clear();
          } else {
            Toast.show('Something went wrong!', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        }
        pr.hide();
      }).catchError((e) {
        pr.hide();
        Toast.show('Something went wrong!', contexts,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      });
    } else {
      pr.hide();
      Toast.show('Enter product detail\'s!', contexts,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
}
