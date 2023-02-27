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
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/categorybean.dart';
import 'package:vendor/orderbean/productbean.dart';
import 'package:vendor/orderbean/subcartbean.dart';

class EditCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    CategoryList Category = dataLis['selectedItem'];


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
        Text('Edit Category', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: Add(Category),
    );
  }
}

class Add extends StatefulWidget {
  CategoryList category;
  Add(this.category);
  @override
  State<StatefulWidget> createState() {
    return AddState(category);
  }
}

class AddState extends State<Add> {
  CategoryList category;
  dynamic currency;
  SubCategoryList subCatString;
  List<SubCategoryList> subCatList = [];
  CategoryList catString;
  List<CategoryList> catList = [];
  File _image;
  final picker = ImagePicker();
  TextEditingController category_name = TextEditingController();
  TextEditingController productQuantityC = TextEditingController();
  TextEditingController productUnitC = TextEditingController();
  TextEditingController productMrpC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();
  TextEditingController productDespC = TextEditingController();
  TextEditingController productStoreC = TextEditingController();

  AddState(this.category) {
    catString = CategoryList('', '', '', '', '', '', '', '');
    catList.add(catString);
    subCatString = SubCategoryList('', '', '', '', '', '');
    subCatList.add(subCatString);
  }

  @override
  void initState() {
    getCategoryList();
    setState(() {
      category_name.text = category.category_name.toString();
    });
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
    var catUrl = store_subcategory;
    var client = http.Client();
    client.post(catUrl, body: {'category_id': '${catId}'}).then((value) {
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
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "IMAGE",
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
                                : Image.network(imageBaseUrl+category.category_image),
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
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'Category',
                      hint: 'Enter Category Name',
                      controller: category_name,
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
            text: "Edit Category",
            onTap: () {
              showProgressDialog('Adding Category\nPlease wait...', pr);
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

    var request = http.MultipartRequest("POST", Uri.parse(store_editcategory));
    request.fields["vendor_id"] = '${storeId}';
    request.fields["category_id"] = category.category_id.toString();
    request.fields["cat_name"] = '${category_name.text}';
    if(_image!=null) {
      request.files.add(
          await http.MultipartFile.fromPath('category_image', _image.path));
      print("ADD PRODUCT: "+request.files.toString());
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          var message = jsonData['message'];
          if (jsonData['status'] == "1") {
            Toast.show('Added', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            category_name.clear();
            setState(() {
              _image = null;
            });
            Navigator.popAndPushNamed(context, PageRoutes.catsubcat);
          } else {
            pr.hide();
            Toast.show(message, context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        });

        Toast.show(values.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      }).catchError((e) {
        print(e);
        Toast.show("e"+e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      });
    }
    else{
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          var message = jsonData['message'];
          if (jsonData['status'] == "1") {
            Toast.show('Added', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            category_name.clear();
            setState(() {
              _image = null;
            });
            Navigator.popAndPushNamed(context, PageRoutes.catsubcat);
          } else {
            pr.hide();
            Toast.show(message, context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
        });

        Toast.show(values.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      }).catchError((e) {
        print(e);
        Toast.show("e"+e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        pr.hide();
      });
    }

  }
}
