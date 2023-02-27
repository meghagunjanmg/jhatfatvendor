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
import 'package:vendor/parcel/parcelbean/chargelistbean.dart';

class EditChargesStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    ChargeListBean chargeBean = dataLis['chargeBean'];
    dynamic currency = dataLis['currency'];
    dynamic vendor_id = dataLis['vendor_id'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
            Text('Edit Charge', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: EditCharges(chargeBean, vendor_id, currency),
    );
  }
}

class EditCharges extends StatefulWidget {
  final ChargeListBean chargeListBean;
  final dynamic vendor_id;
  final dynamic currency;

  EditCharges(this.chargeListBean, this.vendor_id, this.currency);

  @override
  State<StatefulWidget> createState() {
    return EditChargesState();
  }
}

class EditChargesState extends State<EditCharges> {
  TextEditingController productNameC = TextEditingController();
  TextEditingController productQuantityC = TextEditingController();

  @override
  void initState() {
    productNameC.text = '${widget.chargeListBean.parcel_charge}';
    productQuantityC.text = widget.chargeListBean.charge_description;
    super.initState();
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
            text: "Update Charge",
            onTap: () {
              showProgressDialog('Updating charge\nPlease wait...', pr);
              newHitService(pr, context);
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
      pr.show();
      var client = http.Client();
      var urlhit = parcel_updatecharges;
      client.post(urlhit, body: {
        'city_id': '${widget.chargeListBean.city_id}',
        'charges': '${productNameC.text}',
        'description': '${productQuantityC.text}',
        'charge_id': '${widget.chargeListBean.charge_id}',
      }).then((value) {
        print('${value.body}');
        if (value.statusCode == 200) {
          var jsonData = jsonDecode(value.body);
          if (jsonData['status'] == "1") {
            Toast.show('Current charge Updated..', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            Navigator.of(context).pop();
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
