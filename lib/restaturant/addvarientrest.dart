import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/productbean.dart';

class AddVaraintRestItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    dynamic productId = dataLis['productId'];
    dynamic currency = dataLis['currency'];
    dynamic catid = dataLis['catid'];
    dynamic product_name = dataLis['product_name'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text('Add Product Variant',
            style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: AddRestVaraint(productId, currency, catid, product_name),
    );
  }
}

class AddRestVaraint extends StatefulWidget {
  final dynamic productId;
  final dynamic currency;
  final dynamic catid;

  final dynamic product_name;

  AddRestVaraint(this.productId, this.currency, this.catid, this.product_name);

  @override
  State<StatefulWidget> createState() {
    return AddVaraintRestState();
  }
}

class AddVaraintRestState extends State<AddRestVaraint> {
  ProductBean productBean;
  dynamic currency;
  File _image;
  final picker = ImagePicker();
  TextEditingController productNameC = TextEditingController();
  TextEditingController productQuantityC = TextEditingController();
  TextEditingController productUnitC = TextEditingController();
  TextEditingController productMrpC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    picker.getImage(source: ImageSource.gallery).then((pickedFile) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }).catchError((e) => print(e));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
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
            text: "Add product variant",
            onTap: () {
              showProgressDialog('Adding product variant\nPlease wait...', pr);
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
      SharedPreferences profilePref = await SharedPreferences.getInstance();
      var storeId = profilePref.getInt("vendor_id");
      pr.show();
      var storeEditUrl = resturant_addnewvariant;
      var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
      request.fields["vendor_id"] = '${storeId}';
      request.fields["product_id"] = '${widget.productId}';
      request.fields["strick_price"] = '${productMrpC.text}';
      request.fields["price"] = '${productPriceC.text}';
      request.fields["unit"] = '${productUnitC.text}';
      request.fields["quantity"] = '${productQuantityC.text}';
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          print('${responseString}');
          var jsonData = jsonDecode(responseString);
          pr.hide();
          if (jsonData['status'] == "1") {
            Toast.show('Product variant added', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            productPriceC.clear();
            productMrpC.clear();
            productQuantityC.clear();
            productUnitC.clear();
            setState(() {
              _image = null;
            });
            Navigator.of(context).pop();
          } else {
            Toast.show('Something went wrong!', contexts,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        });
      }).catchError((e) {
        print(e);
        Toast.show('Something went wrong!', contexts,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      });
    }
}
