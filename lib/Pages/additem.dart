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
import 'package:vendor/orderbean/categorybean.dart';
import 'package:vendor/orderbean/productbean.dart';
import 'package:vendor/orderbean/subcartbean.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
            Text('Add Product', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: Add(),
    );
  }
}

class Add extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddState();
  }
}

class AddState extends State<Add> {
  ProductBean productBean;
  dynamic currency;
  SubCategoryList subCatString;
  List<SubCategoryList> subCatList = [];
  CategoryList catString;
  List<CategoryList> catList = [];
  File _image;
  final picker = ImagePicker();
  TextEditingController productNameC = TextEditingController();
  TextEditingController productQuantityC = TextEditingController();
  TextEditingController productUnitC = TextEditingController();
  TextEditingController productMrpC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();
  TextEditingController productDespC = TextEditingController();
  TextEditingController productStoreC = TextEditingController();

  AddState() {
    catString = CategoryList('', '', '', '', '', '', '', '');
    catList.add(catString);
    subCatString = SubCategoryList('', '', '', '', '', '');
    subCatList.add(subCatString);
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  void getCategoryList() async {
    SharedPreferences profilePref = await SharedPreferences.getInstance();
    var storeId = profilePref.getInt("vendor_id");
    var catUrl = store_category;
    var client = http.Client();
    client.post(catUrl, body: {'vendor_id': '${storeId}'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        var jsonList = jsonData['data'] as List;
        List<CategoryList> catbean =
            jsonList.map((e) => CategoryList.fromJson(e)).toList();
        if (catbean.length > 0) {
          catList.clear();
          setState(() {
            catString = catbean[0];
            catList = List.from(catbean);
          });
          getSubCategoryList(catList[0].category_id);
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  void getSubCategoryList(catId) async {
    SharedPreferences profilePref = await SharedPreferences.getInstance();
    var storeId = profilePref.getInt("vendor_id");
    var catUrl = store_subcategory;
    var client = http.Client();
    client.post(catUrl, body: {'vendor_id': '${storeId}','category_id': '${catId}'}).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        var jsonList = jsonData['data'] as List;
        List<SubCategoryList> catbean =
            jsonList.map((e) => SubCategoryList.fromJson(e)).toList();
        if (catbean.length > 0) {
          subCatList.clear();
          setState(() {
            subCatString = catbean[0];
            subCatList = List.from(catbean);
          });
        }
      }
    }).catchError((e) {
      print(e);
    });
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

  Future imageSelector(BuildContext context, String pickerType) async {
    File imageFile = null;
    ImagePicker picker = new ImagePicker();
    switch (pickerType) {
      case "gallery":

      /// GALLERY IMAGE PICKER
        imageFile = (await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 90));
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = (await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90));
        break;
    }

    if (imageFile != null) {
      setState(() {
        _image = imageFile;
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });

    } else {
      print("You have not taken image");
    }
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
                      imageSelector(context,'camera');
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
                          DropdownButton<CategoryList>(
                            isExpanded: true,
                            value: catString,
                            underline: Container(
                              height: 1.0,
                              color: kMainTextColor,
                            ),
                            items: catList.map((values) {
                              return DropdownMenuItem<CategoryList>(
                                value: values,
                                child: Text(values.category_name),
                              );
                            }).toList(),
                            onChanged: (area) {
                              setState(() {
                                catString = area;
                              });
                              getSubCategoryList(area.category_id);
                            },
                          )
                        ],
                      ),
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
                            'ITEM SUB-CATEGORY',
                            style: TextStyle(fontSize: 13, color: kHintColor),
                          ),
                          DropdownButton<SubCategoryList>(
                            value: subCatString,
                            isExpanded: true,
                            underline: Container(
                              height: 1.0,
                              color: kMainTextColor,
                            ),
                            items: subCatList.map((values) {
                              return DropdownMenuItem<SubCategoryList>(
                                value: values,
                                child: Text(values.subcat_name),
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
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'STOCK',
                      controller: productStoreC,
                      hint: 'Enter Stock',
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
            text: "Add Product",
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

      SharedPreferences profilePref = await SharedPreferences.getInstance();
      var storeId = profilePref.getInt("vendor_id");
      pr.show();
      var storeEditUrl = store_addnewproduct;
      var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
      request.fields["vendor_id"] = '${storeId}';
      request.fields["subcat_id"] = '${subCatString.subcat_id}';
      request.fields["product_name"] = '${productNameC.text}';
      request.fields["strick_price"] = '${productMrpC.text}';
      request.fields["price"] = '${productPriceC.text}';
      request.fields["stock"] = '${productStoreC.text}';
      request.fields["unit"] = '${productUnitC.text}';
      request.fields["quantity"] = '${productQuantityC.text}';
      request.fields["description"] = '${productDespC.text}';

      if(_image!=null) {
        request.files.add(
            await http.MultipartFile.fromPath('product_image', _image.path));
        print("ADD PRODUCT: "+request.files.toString());


        request.send().then((values) {
          values.stream.toBytes().then((value) {
            print("ADD PRODUCT: "+request.toString());

            var responseString = String.fromCharCodes(value);
            print("ADD PRODUCT: "+responseString.toString());

            var jsonData = jsonDecode(responseString);
            var message = jsonData['message'];

            if (jsonData['status'] == "1") {
              Toast.show('Product Added', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              productNameC.clear();
              productDespC.clear();
              productPriceC.clear();
              productMrpC.clear();
              productQuantityC.clear();
              productUnitC.clear();
              productStoreC.clear();
              setState(() {
                _image = null;
              });
            } else {
              pr.hide();
              print("ADD PRODUCT: "+message.toString());
              Toast.show(message, context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            }
          });

          Toast.show(values.toString(), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          pr.hide();
        }).catchError((e) {
          print(e);
          print("ADD PRODUCT: "+e.toString());

          Toast.show("e"+e.toString(), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          pr.hide();
        });
      }
      else{
        request.send().then((values) {
          values.stream.toBytes().then((value) {
            print("ADD PRODUCT: "+value.toString());

            var responseString = String.fromCharCodes(value);
            print("ADD PRODUCT: "+responseString.toString());

            var jsonData = jsonDecode(responseString);
            var message = jsonData['message'];

            if (jsonData['status'] == "1") {
              Toast.show('Product Added', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              productNameC.clear();
              productDespC.clear();
              productPriceC.clear();
              productMrpC.clear();
              productQuantityC.clear();
              productUnitC.clear();
              productStoreC.clear();
              setState(() {
                _image = null;
              });
            } else {
              pr.hide();
              print("ADD PRODUCT: "+message.toString());
              Toast.show(message, context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            }
          });

          Toast.show(values.toString(), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          pr.hide();
        }).catchError((e) {
          print(e);
          print("ADD PRODUCT: "+e.toString());

          Toast.show("e"+e.toString(), context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          pr.hide();
        });
      }

  }
}
