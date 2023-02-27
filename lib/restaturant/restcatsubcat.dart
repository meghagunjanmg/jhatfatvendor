import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/custom_appbar.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/Themes/style.dart';
import 'package:vendor/baseurl/baseurl.dart';
import 'package:vendor/orderbean/categorybean.dart';
import 'package:vendor/orderbean/productbean.dart';
import 'package:vendor/orderbean/subcatbean.dart';

class Restcatsubcat extends StatefulWidget {
  @override
  _catsubcatState createState() => _catsubcatState();
}

class _catsubcatState extends State<Restcatsubcat>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<SubcategoryList> subCatList = [];
  List<CategoryRestList> catcList = [];
  TextEditingController _textFieldController = TextEditingController();
  String valueText;
  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);

    getCategory();
    getsubCatList();
    super.initState();
  }

  void getCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    client
        .post(rest_category, body: {'vendor_id': '${vendorId}'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsonList = jsonData['data'] as List;
          List<CategoryRestList> catList =
          jsonList.map((e) => CategoryRestList.fromJson(e)).toList();
          if (catList.length > 0) {
            setState(() {
              catcList.clear();
              catcList = catList;
            });
          }
        }
      }
    }).catchError((e) => print(e));
  }

  void getsubCatList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();

    client.post(store_subcategory, body: {
      'vendor_id': '${vendorId}',
    }).then((value) {
      print("SUBCAT "'${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsonList = jsonData['data'] as List;
          List<SubcategoryList> subcat =
          jsonList.map((e) => SubcategoryList.fromJson(e)).toList();
          if (subcat.length > 0) {
            setState(() {
              subCatList.clear();
              subCatList = subcat;
            });
          }
        }
      }
    }).catchError((e) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:         PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child:Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                      color: Colors.white,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'Category',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottom:PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Container(),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child:           Column(
                        children: [
                          Expanded(
                              child:
                              ListView.separated(
                                itemCount: catcList.length,
                                itemBuilder: (context, index) {
                                  return
                                    Card (
                                        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                                        color: Colors.white,
                                        shadowColor: Colors.blueGrey,
                                        elevation: 10,
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(catcList[index].cat_name,style:Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith()),
                                            Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [    IconButton(icon:Icon(Icons.edit), onPressed: (){
                                                  Navigator.popAndPushNamed(
                                                      context, PageRoutes.restEditCategory,
                                                      arguments: {
                                                        'selectedItem': catcList[index]
                                                      }).then((value) {
                                                    getsubCatList();
                                                    getCategory();
                                                  });
                                                }),
                                                  IconButton(icon:Icon(Icons.remove_circle), onPressed: (){
                                                    // set up the AlertDialog
                                                    AlertDialog alert = AlertDialog(
                                                      title: Text("Read Carefully"),
                                                      content: Text("Deleting the category will also delete subcategories and products inside the category."),
                                                      actions: [
                                                        TextButton(onPressed:(){
                                                          deleteCat(catcList[index].resturant_cat_id);
                                                        }, child: Text("Delete"))
                                                      ],
                                                    );
                                                    // show the dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return alert;
                                                      },
                                                    );
                                                  }),
                                                ])
                                          ],
                                        ));
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 5,
                                  );
                                },
                              )
                          ),
                          Padding(padding: EdgeInsets.all(10),
                            child:   RaisedButton(
                              child: Text(
                                'Add Category',
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                              color: kMainColor,
                              highlightColor: kMainColor,
                              focusColor: kMainColor,
                              splashColor: kMainColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.popAndPushNamed(context, PageRoutes.restAddCategory).then((value) {
                                  getCategory();
                                  getsubCatList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteCat(category_id) async {
    var client = http.Client();
    client
        .post(rest_deletecategory, body: {'category_id': category_id.toString()}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          getCategory();
          getsubCatList();
          Navigator.pop(context);
        }
      }
    }).catchError((e) => print(e));
  }

}
