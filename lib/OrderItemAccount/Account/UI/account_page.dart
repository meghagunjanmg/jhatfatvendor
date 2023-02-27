import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Auth/login_navigator.dart';
import 'package:vendor/Components/list_tile.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: Theme.of(context).textTheme.bodyText1),
        centerTitle: true,
      ),
      body: Account(),
    );
  }
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String number;
  dynamic storeId;
  dynamic storeName;
  dynamic storeOwnerName;
  dynamic storeNumber;
  dynamic vendorLoc;
  dynamic storeImage;
  dynamic uiType;
  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    getStoreDetails();
    super.initState();
  }

  void getStoreDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      storeId = pref.getInt("vendor_id");
      storeName = pref.getString("vendor_name");
      storeOwnerName = pref.getString("owner");
      storeNumber = pref.getString("vendor_phone");
      vendorLoc = pref.getString("vendor_loc");
      storeImage = pref.getString("vendor_logo");
      uiType = pref.getString("ui_type");
    });
  }

  @override
  Widget build(BuildContext context)  {
    return ListView(
      children: <Widget>[
        StoreDetails(storeId, storeName, storeOwnerName, storeNumber, vendorLoc,
            storeImage),
        Divider(
          color: kCardBackgroundColor,
          thickness: 8.0,
        ),
        (uiType != null && uiType == "2") ?
    BuildListTile(
    image: 'images/account/ic_menu_tncact.png',
    text: 'Categories',
    onTap: () => Navigator.pushNamed(context, PageRoutes.restcatsubcat),
    )
    :
            Container(),
    (uiType != null && uiType == "1") ?
    BuildListTile(
    image: 'images/account/ic_menu_tncact.png',
    text: 'Categories and subcategories',
    onTap: () => Navigator.pushNamed(context, PageRoutes.catsubcat),
    )
        :
    Container(),

        BuildListTile(
            image: 'images/account/ic_menu_tncact.png',
            text: 'Terms & Conditions',
            onTap: () => Navigator.pushNamed(context, PageRoutes.tncPage)),
        BuildListTile(
            image: 'images/account/ic_menu_supportact.png',
            text: 'Support',
            onTap: () => Navigator.pushNamed(context, PageRoutes.supportPage,
                arguments: number)),
        BuildListTile(
          image: 'images/account/ic_menu_aboutact.png',
          text: 'About us',
          onTap: () => Navigator.pushNamed(context, PageRoutes.aboutUsPage),
        ),
        BuildListTile(
          image: 'images/account/ic_menu_aboutact.png',
          text: 'Commission',
          onTap: () => Navigator.pushNamed(context, PageRoutes.commission),
        ),

        Column(
          children: <Widget>[
            BuildListTile(
                image: 'images/account/ic_menu_insight.png',
                text: 'Order History',
                onTap: () async {
                  await SharedPreferences.getInstance().then((value) {
                    uiType = value.getString("ui_type");
                    if (uiType != null && uiType == "2") {
                      Navigator.pushNamed(context, PageRoutes.insightpagerest);
                    }
                    if (uiType != null && uiType == "3") {
                      Navigator.pushNamed(
                          context, PageRoutes.insightpagepharma);
                    }
                    if (uiType != null && uiType == "4") {
                      Navigator.pushNamed(
                          context, PageRoutes.insightpageparcel);
                    } else if (uiType != null && uiType == "1") {
                      Navigator.pushNamed(context, PageRoutes.insightPage);
                    }
                  });
                }),
            LogoutTile(),
          ],
        ),
      ],
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildListTile(
      image: 'images/account/ic_menu_logoutact.png',
      text: 'Logout',
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Logging out'),
                content: Text('Are you sure?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    textColor: kMainColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: kTransparentColor)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                      child: Text('Yes'),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: kTransparentColor)),
                      textColor: kMainColor,
                      onPressed: () async {
                        // Phoenix.rebirth(context);
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear().then((value) {
                          if (value) {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginNavigator();
                            }), (Route<dynamic> route) => false);
                          }
                        });
                      })
                ],
              );
            });
      },
    );
  }
}

class StoreDetails extends StatefulWidget {
  final dynamic storeId;
  final dynamic storeName;
  final dynamic storeOwnerName;
  final dynamic storeNumber;
  final dynamic vendorLoc;
  final dynamic storeImage;

  StoreDetails(this.storeId, this.storeName, this.storeOwnerName,
      this.storeNumber, this.vendorLoc, this.storeImage);

  @override
  State<StatefulWidget> createState() {
    return StoreDetailsState();
  }
}

class StoreDetailsState extends State<StoreDetails> {
  dynamic storeImg;

  @override
  void initState() {
    storeImg = widget.storeImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 98.0,
            width: 98.0,
            child: (storeImg != null)
                ? Image.network('${imageBaseUrl}${storeImg}')
                : Image.asset('images/layer_1.png'),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${widget.storeName}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15.0, fontWeight: FontWeight.w500)),
                SizedBox(height: 8.0),
                Text('${widget.vendorLoc}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Color(0xff4a4b48), fontSize: 13.3)),
                GestureDetector(
                    child: Text(
                      '\n' + 'Store Profile',
                      style: TextStyle(
                          color: kMainColor,
                          fontSize: 13.3,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, PageRoutes.storeProfile)
                            .then((value) async {
                          SharedPreferences profilePref =
                              await SharedPreferences.getInstance();
                          setState(() {
                            storeImg = profilePref.getString("vendor_logo");
                          });
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
