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
import 'package:vendor/orderbean/productbean.dart';
import 'package:vendor/orderbean/subcatbean.dart';

class ItemsPageRest extends StatefulWidget {
  @override
  _ItemsPageRestState createState() => _ItemsPageRestState();
}

class _ItemsPageRestState extends State<ItemsPageRest>
    with SingleTickerProviderStateMixin {
  List<DropdownMenuItem<VarientList>> listDrop = [];
  List<RestProductArray> productList = [];
  int selected = null;
  dynamic curency;
  List<CategoryRestList> subCatList = [];
  List<Tab> tabs = <Tab>[];
  TabController tabController;

  var value = 0;

  dynamic isFetch = false;
  dynamic isDelete = false;

  @override
  void initState() {
    getSubCategory();
    super.initState();
  }

  void getSubCategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      curency = pref.getString('curency');
    });
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
            List<Tab> tabss = <Tab>[];
            setState(() {
              for (CategoryRestList li in catList) {
                tabss.add(Tab(
                  text: '${li.cat_name}',
                ));
              }
              tabs.clear();
              tabs = tabss;
              tabController = TabController(length: tabs.length, vsync: this);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  productListM(
                      subCatList[tabController.index].resturant_cat_id);
                }
              });
              subCatList = List.from(catList);
            });
            productListM(subCatList[0].resturant_cat_id);
          }
        }
      }
    }).catchError((e) => print(e));
  }

  void productListM(catid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
      curency = pref.getString('curency');
      productList.clear();
    });
    var vendorId = pref.getInt('vendor_id');
    var client = http.Client();
    var storeProduct = resturant_product;
    client.post(storeProduct, body: {
      'vendor_id': '${vendorId}',
      'subcat_id': '${catid}'
    }).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        if (value.body.toString() ==
            "[{\"order_details\":\"no orders found\"}]") {
        } else {
          var jsonData = jsonDecode(value.body) as List;
          List<RestProductArray> listBean =
              jsonData.map((e) => RestProductArray.fromJson(e)).toList();
          if (listBean.length > 0) {
            setState(() {
              productList = List.from(listBean);
            });
          }
        }
      }
      setState(() {
        isFetch = false;
      });
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // loadData();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: CustomAppBar(
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Text(
                  'My Products',
                  style: TextStyle(color: kMainTextColor),
                )),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: kMainColor,
                  ),
                  onPressed: () {
                    productListM(
                        subCatList[tabController.index].resturant_cat_id);
                  }),
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: tabs,
              isScrollable: true,
              labelColor: kMainColor,
              unselectedLabelColor: kLightTextColor,
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: tabController,
              children: tabs.map((tab) {
                return (productList != null && productList.length > 0)
                    ? ListView.separated(
                        itemCount: productList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (productList[index].varient_details !=
                                          null &&
                                      productList[index]
                                              .varient_details
                                              .length >
                                          0) {
                                    Navigator.pushNamed(
                                        context, PageRoutes.editItemRest,
                                        arguments: {
                                          'selectedItem': productList[index],
                                          'currency': curency,
                                          'catid':
                                              subCatList[tabController.index]
                                                  .resturant_cat_id,
                                        }).then((value) {
                                      productListM(
                                          subCatList[tabController.index]
                                              .resturant_cat_id);
                                    });
                                  } else {
                                    Toast.show(
                                        "No varaient available for this product.",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.CENTER);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0,
                                              top: 30.0,
                                              right: 14.0),
                                          child: (productList != null &&
                                                  productList.length > 0)
                                              ? Image.network(
                                                  '${imageBaseUrl}${productList[index].product_image}',
//                                scale: 2.5,
                                                  height: 93.3,
                                                  width: 93.3,
                                                )
                                              : Image(
                                                  image: AssetImage(
                                                      'images/logos/logo_user.png'),
                                                  height: 93.3,
                                                  width: 93.3,
                                                ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                          productList[index]
                                                              .product_name,
                                                          style:
                                                              bottomNavigationTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                    SizedBox(
                                                      height: 8.0,
                                                    ),
                                                    Text(
                                                        '$curency ${(productList[index].varient_details != null && productList[index].varient_details.length > 0) ? productList[index].varient_details[productList[index].selectedItem].price : 0}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showAlertDialog(
                                                      context,
                                                      (productList[index]
                                                                      .varient_details !=
                                                                  null &&
                                                              productList[index]
                                                                      .varient_details
                                                                      .length >
                                                                  0)
                                                          ? productList[index]
                                                              .varient_details[
                                                                  productList[
                                                                          index]
                                                                      .selectedItem]
                                                              .variant_id
                                                          : productList[index]
                                                              .product_id,
                                                      (productList[index]
                                                                      .varient_details !=
                                                                  null &&
                                                              productList[index]
                                                                      .varient_details
                                                                      .length >
                                                                  0)
                                                          ? true
                                                          : false);
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: kMainColor,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      left: 120,
                                      bottom: 5,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 30.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          decoration: BoxDecoration(
                                            color: kCardBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: (productList[index]
                                                          .varient_details !=
                                                      null &&
                                                  productList[index]
                                                          .varient_details
                                                          .length >
                                                      0)
                                              ? DropdownButton<RestProdVarient>(
                                                  underline: Container(
                                                    height: 0.0,
                                                    color: kCardBackgroundColor,
                                                  ),
                                                  value: productList[index]
                                                          .varient_details[
                                                      productList[index]
                                                          .selectedItem],
                                                  items: productList[index]
                                                      .varient_details
                                                      .map((e) {
                                                    return DropdownMenuItem<
                                                        RestProdVarient>(
                                                      child: Text(
                                                        '${e.quantity} ${e.unit}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                      value: e,
                                                    );
                                                  }).toList(),
                                                  onChanged: (vale) {
                                                    setState(() {
                                                      int indexd =
                                                          productList[index]
                                                              .varient_details
                                                              .indexOf(vale);
                                                      if (indexd != -1) {
                                                        productList[index]
                                                                .selectedItem =
                                                            indexd;
                                                      }
                                                    });
                                                  })
                                              : Text(''),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    right: 10, left: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            PageRoutes.addVaraintItemRest,
                                            arguments: {
                                              'productId':
                                                  productList[index].product_id,
                                              'currency': curency,
                                              'product_name': productList[index]
                                                  .product_name,
                                              'catid': subCatList[
                                                      tabController.index]
                                                  .resturant_cat_id
                                            }).then((value) {
                                          productListM(
                                              subCatList[tabController.index]
                                                  .resturant_cat_id);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                        margin: EdgeInsets.only(
                                            left: 5.0, right: 10),
                                        decoration: BoxDecoration(
                                            color: kMainColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Text(
                                          'Add Variant',
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: kWhiteColor),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            PageRoutes.addItemaddonrest,
                                            arguments: {
                                              'productId':
                                                  productList[index].product_id,
                                              'currency': curency,
                                              'vendor_id':
                                                  productList[index].vendor_id
                                            }).then((value) {
                                          productListM(
                                              subCatList[tabController.index]
                                                  .resturant_cat_id);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                        margin: EdgeInsets.only(
                                            left: 5.0, right: 10),
                                        decoration: BoxDecoration(
                                            color: kMainColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Text(
                                          'Add Addon',
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: kWhiteColor),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PageRoutes.updateitemrest,
                                            arguments: {
                                              'productId':
                                                  productList[index].product_id,
                                              'description': productList[index]
                                                  .description,
                                              'product_name': productList[index]
                                                  .product_name,
                                              'product_image':
                                                  productList[index]
                                                      .product_image,
                                              'subcat_id': subCatList[
                                                      tabController.index]
                                                  .resturant_cat_id,
                                              'currency': curency
                                            }).then((value) {
                                          productListM(
                                              subCatList[tabController.index]
                                                  .resturant_cat_id);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                        margin: EdgeInsets.only(
                                            left: 5.0, right: 10),
                                        decoration: BoxDecoration(
                                            color: kMainColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Text(
                                          'Update product',
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: kWhiteColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: (productList[index].addons != null &&
                                        productList[index].addons.length > 0)
                                    ? true
                                    : false,
                                child: (productList[index].addons != null &&
                                        productList[index].addons.length > 0)
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            right: 20, left: 20, top: 20),
                                        child: ListView.separated(
                                          itemBuilder: (context, indi) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    PageRoutes.updaterestaddon,
                                                    arguments: {
                                                      'addonid':
                                                          productList[index]
                                                              .addons[indi]
                                                              .addon_id,
                                                      'currency': curency,
                                                      'addon_price':
                                                          productList[index]
                                                              .addons[indi]
                                                              .addon_price,
                                                      'addon_name':
                                                          productList[index]
                                                              .addons[indi]
                                                              .addon_name
                                                    }).then((value) {
                                                  productListM(subCatList[
                                                          tabController.index]
                                                      .resturant_cat_id);
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                          productList[index]
                                                              .addons[indi]
                                                              .addon_name,
                                                          style:
                                                              bottomNavigationTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15)),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                          '$curency ${productList[index].addons[indi].addon_price}',
                                                          style:
                                                              bottomNavigationTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15))
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showAlertDialogAddOn(
                                                          context,
                                                          productList[index]
                                                              .addons[indi]
                                                              .addon_id);
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: kMainColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount:
                                              productList[index].addons.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          separatorBuilder: (context, indo) {
                                            return Divider(
                                              color: kCardBackgroundColor,
                                              thickness: 2,
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ),
                              (index == (productList.length - 1))
                                  ? Container(
                                      color: Colors.transparent,
                                      height: 80,
                                    )
                                  : Divider(
                                      color: Colors.transparent,
                                      thickness: 0.2,
                                    )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          );
                        },
                      )
                    : isFetch
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                CupertinoActivityIndicator(
                                  radius: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Fetching products please wait....',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: kMainColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'No Data available for this category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: kMainColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
              }).toList(),
            ),
            Visibility(
              visible: isDelete,
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: MediaQuery.of(context).size.height - 110,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(253, 254, 254, 0.3),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, PageRoutes.addItemRest)
              .then((value) {
            productListM(subCatList[tabController.index].resturant_cat_id);
          }),
          tooltip: 'ADD PRODUCT',
          child: Icon(
            Icons.add,
            size: 15.7,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void hitDeleteButton(BuildContext context, product_id, isVaraint) {
    setState(() {
      isDelete = true;
    });
    var client = http.Client();
    var storeProduct;
    if (isVaraint) {
      storeProduct = resturant_deletevariant;
    } else {
      storeProduct = resturant_deleteproduct;
    }
    client.post(storeProduct, body: {
      (isVaraint) ? 'variant_id' : 'product_id': '${product_id}'
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          Toast.show(jsonData['message'], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
          productListM(subCatList[tabController.index].resturant_cat_id);
        } else {
          Toast.show('Something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
      }
      setState(() {
        isDelete = false;
      });
    }).catchError((e) {
      Toast.show('Something went wrong!', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
      setState(() {
        isDelete = false;
      });
      print(e);
    });
  }

  showAlertDialog(BuildContext context, product_id, isVaraint) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        hitDeleteButton(context, product_id, isVaraint);
      },
      child: Material(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'Yes',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'No',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text("Alert"),
      content: Text("Are you sure to want delete product."),
      actions: [clear, no],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void hitDeleteButtonAddOn(BuildContext context, addon_id) {
    setState(() {
      isDelete = true;
    });
    var client = http.Client();
    var storeProduct = resturant_deleteaddon;
    client.post(storeProduct, body: {'addon_id': '${addon_id}'}).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          Toast.show(jsonData['message'], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
          productListM(subCatList[tabController.index].resturant_cat_id);
        } else {
          Toast.show('Something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
      }
      setState(() {
        isDelete = false;
      });
    }).catchError((e) {
      Toast.show('Something went wrong!', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
      setState(() {
        isDelete = false;
      });
      print(e);
    });
  }

  showAlertDialogAddOn(BuildContext context, addon_id) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        hitDeleteButtonAddOn(context, addon_id);
      },
      child: Material(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'Yes',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'No',
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text("Alert"),
      content: Text("Are you sure to want delete Addon."),
      actions: [clear, no],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
