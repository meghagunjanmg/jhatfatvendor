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
import 'package:vendor/orderbean/subcatbean.dart';

class EditSubCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataLis = ModalRoute.of(context).settings.arguments;
    SubcategoryList Category = dataLis['selectedItem'];


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title:
        Text('Edit Subcategory', style: Theme.of(context).textTheme.bodyText1),
        titleSpacing: 0.0,
      ),
      body: Add(Category),
    );
  }
}

class Add extends StatefulWidget {
  SubcategoryList category;
  Add(this.category);
  @override
  State<StatefulWidget> createState() {
    return AddState(category);
  }
}

class AddState extends State<Add> {
  SubcategoryList category;

  int click=0;
  ProductBean productBean;
  dynamic currency;
  SubCategoryList subCatString;
  List<SubCategoryList> subCatList = [];
  CategoryList catString;
  List<CategoryList> catList = [];
  File _image;
  final picker = ImagePicker();
  TextEditingController subcategoryname = TextEditingController();
  String selectedCat='';

  bool Tabacoo = false;
  bool Id = false;
  bool presciption = false;
  bool isbasket = false;

  AddState(this.category) {
    catString = CategoryList(
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '');
    catList.add(catString);
    subCatString = SubCategoryList('', '', '', '', '', '');
    subCatList.add(subCatString);
  }

  @override
  void initState() {
    super.initState();
    getCategoryList();
    print(category.toString());

    if(category.istabacco==0){
      setState(() {
        Tabacoo = false;
      });
    }
    else{
      setState(() {
        Tabacoo = true;
      });
    }

    if(category.isid==0){
      setState(() {
        Id = false;
      });
    }
    else{
      setState(() {
        Id = true;
      });
    }

    if(category.ispres==0){
      setState(() {
        presciption = false;
      });
    }
    else{
      setState(() {
        presciption = true;
      });
    }

    if(category.isbasket==0){
      setState(() {
        isbasket = false;
      });
    }
    else{
      setState(() {
        isbasket = true;
      });
    }
    setState(() {
      subcategoryname.text = category.subcatName.toString();
    });

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

          catList.forEach((element) {
            if(element.category_id.toString() == category.category_id){
              setState(() {
                catString = element;
              });
            }
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
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
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
                            EntryField(
                              textCapitalization: TextCapitalization.words,
                              label: 'Subcategory ',
                              hint: 'Enter Subcategory Name',
                              controller: subcategoryname,
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
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text("Additional Settings"),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          setState(() {
                            click++;
                          });
                        },  //---> This is how u use it....
                      ),
                    ],
                  ),
                ),
                (click%2!=0)?
                Column(
                  children: [
                    CheckboxListTile(
                      title: Text("Tabacoo product"),
                      value: Tabacoo,
                      onChanged: (newValue) {
                        setState(() {
                          Tabacoo = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    CheckboxListTile(
                      title: Text("Id proof needed"),
                      value: Id,
                      onChanged: (newValue) {
                        setState(() {
                          Id = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    CheckboxListTile(
                      title: Text("Prescription needed"),
                      value: presciption,
                      onChanged: (newValue) {
                        setState(() {
                          presciption = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    CheckboxListTile(
                      title: Text("Available for combo packing"),
                      value: isbasket,
                      onChanged: (newValue) {
                        setState(() {
                          isbasket = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                  ],
                )
                    :
                Column(),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              text: "Edit Subcategory",
              onTap: () {
                showProgressDialog('Adding Subcategory\nPlease wait...', pr);
                newHitService(pr, context);
              },
            ),
          )
        ]);
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
    pr.show();
    var client = http.Client();
    client.post(store_editsubcategory, body: {
      'category_id': '${catString.category_id}',
      'subcat_id': '${category.subcatId}',
      'subcat_name': '${subcategoryname.text}',
      'istabacco':Tabacoo ? "1":"0",
      'isid':Id ? "1":"0",
      'ispres':presciption ? "1":"0",
      'isbasket':isbasket ? "1":"0",

    }).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          print('${value.body}');
          Toast.show('Added', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          Navigator.popAndPushNamed(context, PageRoutes.catsubcat);
        }
        else {
          pr.hide();
          Toast.show(jsonData['message'] , context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        }
      }
    }).catchError(((e) {
      pr.hide();
      print(e.toString());
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }));
  }
}