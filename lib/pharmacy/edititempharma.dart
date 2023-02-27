import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/productbean.dart';

class EditItemPharma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    RestProductArray productBean = dataLis['selectedItem'];
    dynamic currency = dataLis['currency'];
    dynamic catid = dataLis['catid'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text('Update Product',
            style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: EditPharma(productBean, currency, catid),
    );
  }
}

class EditPharma extends StatefulWidget {
  RestProductArray productBean;
  dynamic currency;
  dynamic catid;

  EditPharma(this.productBean, this.currency, this.catid);

  @override
  State<StatefulWidget> createState() {
    return EditPharmaState(productBean, currency, catid);
  }
}

class EditPharmaState extends State<EditPharma> {
  RestProductArray productBean;
  dynamic currency;
  dynamic catid;
  TextEditingController productQuantityC = TextEditingController();
  TextEditingController productUnitC = TextEditingController();
  TextEditingController productMrpC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();

  EditPharmaState(productBean, currency, catid) {
    this.productBean = productBean;
    this.currency = currency;
    this.catid = catid;
    productPriceC.text =
        '${this.productBean.varient_details[this.productBean.selectedItem].price}';
    productMrpC.text =
        '${this.productBean.varient_details[this.productBean.selectedItem].strick_price}';
    productQuantityC.text =
        '${this.productBean.varient_details[this.productBean.selectedItem].quantity}';
    productUnitC.text =
        '${this.productBean.varient_details[this.productBean.selectedItem].unit}';
  }

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
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'ITEM MRP',
                      hint: 'Enter Mrp',
                      controller: productMrpC,
                      keyboardType: TextInputType.number,
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'QUANTITY eg-(1, 5, 10, 250)',
                      hint: 'Enter Quantity eg-(1, 5, 10, 250)',
                      controller: productQuantityC,
                      keyboardType: TextInputType.number,
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'UNIT Eg-(Gram, Kg, Pcs, Kilo)',
                      controller: productUnitC,
                      hint: 'Enter Unit Eg-(Gram, Kg, Pcs, Kilo)',
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
            text: "Update Product",
            onTap: () {
              showProgressDialog('Updating please wait...', pr);
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

  void newHitService(ProgressDialog pr, BuildContext contexts) async {
    pr.show();
    if (productMrpC.text.isNotEmpty &&
        productPriceC.text.isNotEmpty &&
        productUnitC.text.isNotEmpty &&
        productQuantityC.text.isNotEmpty) {
      var storeEditUrl = pharmacy_updatevariant;
      var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
      request.fields["vendor_id"] = '${productBean.vendor_id}';
      request.fields["varient_id"] =
          '${productBean.varient_details[productBean.selectedItem].variant_id}';
      request.fields["strick_price"] = '${productMrpC.text}';
      request.fields["price"] = '${productPriceC.text}';
      request.fields["unit"] = '${productUnitC.text}';
      request.fields["quantity"] = '${productQuantityC.text}';
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          pr.hide();
          if (jsonData['status'] == "1") {
            Toast.show('Product updated successfully!', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            productPriceC.clear();
            productMrpC.clear();
            productQuantityC.clear();
            productUnitC.clear();
            Navigator.of(context).pop();
          } else {
            Toast.show('Something went wrong!', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        });
      }).catchError((e) {
        pr.hide();
        print(e);
        Toast.show('Something went wrong!', contexts,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      });
    } else {
      pr.hide();
      Toast.show('Enter product details!', contexts,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
}
