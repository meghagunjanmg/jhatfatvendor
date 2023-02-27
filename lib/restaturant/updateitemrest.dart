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
import 'package:vendor/orderbean/subcatbean.dart';

class UpdateItemRest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    dynamic productId = dataLis['productId'];
    dynamic description = dataLis['description'];
    dynamic product_name = dataLis['product_name'];
    dynamic product_image = dataLis['product_image'];
    dynamic subcat_id = dataLis['subcat_id'];
    dynamic currency = dataLis['currency'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text('Update Product',
            style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: UpdateRest(productId, description, product_name, product_image,
          subcat_id, currency),
    );
  }
}

class UpdateRest extends StatefulWidget {
  final dynamic productId;
  final dynamic description;
  final dynamic product_name;
  final dynamic product_image;
  final dynamic subcat_id;
  final dynamic currency;

  UpdateRest(this.productId, this.description, this.product_name,
      this.product_image, this.subcat_id, this.currency);

  @override
  State<StatefulWidget> createState() {
    return UpdateRestState();
  }
}

class UpdateRestState extends State<UpdateRest> {
  ProductBean productBean;
  dynamic currency;
  CategoryRestList subCatString;
  List<CategoryRestList> subCatList = [];
  File _image;
  final picker = ImagePicker();
  TextEditingController productNameC = TextEditingController();
  TextEditingController productDespC = TextEditingController();

  AddRestState() {
    subCatString = CategoryRestList('', '', '', '');
    subCatList.add(subCatString);
  }

  @override
  void initState() {
    productNameC.text = widget.product_name;
    productDespC.text = widget.description;
    getSubCategory();
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

  void getSubCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    var todayOrderUrl = resturant_category;
    client
        .post(todayOrderUrl, body: {'vendor_id': '${vendorId}'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsonList = jsonData['data'] as List;
          List<CategoryRestList> catList =
              jsonList.map((e) => CategoryRestList.fromJson(e)).toList();
          if (catList.length > 0) {
            setState(() {
              subCatList.clear();
              subCatList = List.from(catList);
              subCatString = subCatList[0];
            });
          }
        }
      }
    }).catchError((e) => print(e));
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
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "ITEM IMAGE",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                              color: kHintColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 99.0,
                            width: 99.0,
                            color: kCardBackgroundColor,
                            child: _image != null
                                ? Image.file(_image)
                                : (widget.product_image != null)
                                    ? Image.network(
                                        '${imageBaseUrl}${widget.product_image}')
                                    : Image.asset('images/user.png'),
                          ),
                          SizedBox(width: 30.0),
                          Icon(
                            Icons.camera_alt,
                            color: kMainColor,
                            size: 19.0,
                          ),
                          SizedBox(width: 14.3),
                          Text("Upload Photo",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: kMainColor)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.3,
                    )
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
                        'ITEM INFO',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'ITEM TITLE',
                      hint: 'Enter Item Name',
                      controller: productNameC,
                    ),
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
                            'ITEM CATEGORY',
                            style: TextStyle(fontSize: 13, color: kHintColor),
                          ),
                          DropdownButton<CategoryRestList>(
                            isExpanded: true,
                            value: subCatString,
                            underline: Container(
                              height: 1.0,
                              color: kMainTextColor,
                            ),
                            items: subCatList.map((values) {
                              return DropdownMenuItem<CategoryRestList>(
                                value: values,
                                child: Text(values.cat_name),
                              );
                            }).toList(),
                            onChanged: (area) {
                              setState(() {
                                subCatString = area;
                              });
                            },
                          )
                        ],
                      ),
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
                        'ITEM Description',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'ITEM Description',
                      hint: 'Enter Item Description',
                      controller: productDespC,
                    ),
                    SizedBox(
                      height: 5,
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
              showProgressDialog('Updating Product\nPlease wait...', pr);
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
    if (productNameC.text.isNotEmpty && productDespC.text.isNotEmpty) {
      pr.show();
      String fid = '';
      if (_image != null) {
        fid = _image.path.split('/').last;
      }

      var storeEditUrl = resturant_updatenewproduct;
      var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
      request.fields["product_id"] = '${widget.productId}';
      request.fields["subcat_id"] = '${subCatString.resturant_cat_id}';
      request.fields["product_name"] = '${productNameC.text}';
      request.fields["description"] = '${productDespC.text}';
      if (_image != null) {
        http.MultipartFile.fromPath("product_image", _image.path, filename: fid)
            .then((pic) {
          request.files.add(pic);
          request.send().then((values) {
            values.stream.toBytes().then((value) {
              var responseString = String.fromCharCodes(value);
              var jsonData = jsonDecode(responseString);
              if (jsonData['status'] == "1") {
                Toast.show('Product Updated', context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                productNameC.clear();
                productDespC.clear();
                setState(() {
                  _image = null;
                });
                Navigator.of(context).pop();
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
        }).catchError((e1) {
          print(e1);
          Toast.show('Something went wrong!', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          pr.hide();
        });
      } else {
        request.fields["product_image"] = '';
        request.send().then((values) {
          values.stream.toBytes().then((value) {
            var responseString = String.fromCharCodes(value);
            var jsonData = jsonDecode(responseString);
            if (jsonData['status'] == "1") {
              Toast.show('Product Updated', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              productNameC.clear();
              productDespC.clear();
              setState(() {
                _image = null;
              });
              Navigator.of(context).pop();
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
      }
    } else {
      Toast.show('Add product detail!', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      pr.hide();
    }
  }
}
