import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';

class AddItemAddOnRest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    dynamic productID = dataLis['productId'];
    dynamic vendor_id = dataLis['vendor_id'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
            Text('Add Product', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: AddAddOnRest(productID, vendor_id),
    );
  }
}

class AddAddOnRest extends StatefulWidget {
  final dynamic productID;
  final dynamic vendor_id;

  AddAddOnRest(this.productID, this.vendor_id);

  @override
  State<StatefulWidget> createState() {
    return AddRestAddState();
  }
}

class AddRestAddState extends State<AddAddOnRest> {
  dynamic currency;
  TextEditingController productNameC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();

  @override
  void initState() {
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
                thickness: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Addon Info',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'ADDON TITLE',
                      hint: 'Enter Addon Name',
                      controller: productNameC,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 8.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ITEM PRICE & UNIT',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'ITEM PRICE',
                      hint: 'Enter Price',
                      controller: productPriceC,
                      keyboardType: TextInputType.number,
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
            text: "Add Addon",
            onTap: () {
              showProgressDialog('Adding Product\nPlease wait...', pr);
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

  void newHitService(ProgressDialog pr, BuildContext context) async {
    if (productPriceC.text.isNotEmpty && productNameC.text.isNotEmpty) {
      pr.show();
      var storeEditUrl = resturant_addaddons;
      var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
      request.fields["vendor_id"] = '${widget.vendor_id}';
      request.fields["product_id"] = '${widget.productID}';
      request.fields["addon_name"] = '${productNameC.text}';
      request.fields["addon_price"] = '${productPriceC.text}';
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          print('${responseString}');
          var jsonData = jsonDecode(responseString);
          if (jsonData['status'] == "1") {
            Toast.show('Product Added', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            productNameC.clear();
            productPriceC.clear();
          } else {
            Toast.show('Something went wrong!', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        });
        pr.hide();
      }).catchError((e) {
        print(e);
        Toast.show('Something went wrong!', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      });
    } else {
      Toast.show('Add product detail!', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      pr.hide();
    }
  }
}
