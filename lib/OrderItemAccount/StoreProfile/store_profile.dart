import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vendor/Components/bottom_bar.dart';
import 'package:vendor/Components/entry_field.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';

class ProfilePage extends StatelessWidget {
  static const String id = 'register_page';
  final String phoneNumber;

  ProfilePage({this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 16.7, color: kMainTextColor),
        ),
      ),

      //this column contains 3 textFields and a bottom bar
      body: RegisterForm(phoneNumber),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String phoneNumber;

  RegisterForm(this.phoneNumber);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController storeNameC = TextEditingController();
  TextEditingController storeNumberC = TextEditingController();
  TextEditingController storeCategoryC = TextEditingController();
  TextEditingController storeEmailC = TextEditingController();
  TextEditingController storeAddressC = TextEditingController();
  TextEditingController storeOpenC = TextEditingController();
  TextEditingController storecloseC = TextEditingController();
  File _image;
  final picker = ImagePicker();
  dynamic storeId;
  dynamic storeName;
  dynamic storeCategory = 'no value';
  dynamic storeNumber;
  dynamic storeEmailAddress;
  dynamic storeAddress;
  dynamic openTiming;
  dynamic closeTiming;
  dynamic storeImage;
  dynamic ownerName;

  String _date = "Not set";
  String _time = "Not set";

  @override
  void initState() {
    getShareProfileValue();
    super.initState();
  }

  _imgFromCamera(ProgressDialog pr) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    if (_image != null) {
      showProgressDialog('Updating please wait...', pr);
      hitServicePic(pr);
    }
  }

  _imgFromGallery(ProgressDialog pr) async {
    picker.getImage(source: ImageSource.gallery).then((pickedFile) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
      if (_image != null) {
        showProgressDialog('Updating please wait...', pr);
        hitServicePic(pr);
      }
    }).catchError((e) => print(e));
  }

  void _showPicker(context, ProgressDialog pr) {
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
                        _imgFromGallery(pr);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(pr);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getShareProfileValue() async {
    SharedPreferences profilePref = await SharedPreferences.getInstance();
    setState(() {
      storeId = profilePref.getInt("vendor_id");
      storeName = profilePref.getString("vendor_name");
      storeImage = profilePref.getString("vendor_logo");
      storeNumber = profilePref.getString("vendor_phone");
      storeEmailAddress = profilePref.getString("vendor_email");
      ownerName = profilePref.getString("owner");
      openTiming = profilePref.getString("opening_time");
      closeTiming = profilePref.getString("closing_time");
      storeAddress = profilePref.getString("vendor_loc");
      storeNameC.text = storeName;
      storeNumberC.text = storeNumber;
      storeCategoryC.text = storeCategory;
      storeEmailC.text = storeEmailAddress;
      storeAddressC.text = storeAddress;
      _date = openTiming;
      _time = closeTiming;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Divider(
            color: kCardBackgroundColor,
            thickness: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "FEATURE IMAGE",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.67,
                            color: kHintColor),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 99.0,
                        width: 99.0,
                        child: _image != null
                            ? Image.file(_image)
                            : (storeImage != null)
                                ? Image.network(imageBaseUrl + storeImage)
                                : Image.asset('images/layer_1.png'),
                      ),
                      SizedBox(width: 30.0),
                      Icon(
                        Icons.camera_alt,
                        color: kMainColor,
                        size: 19.0,
                      ),
                      SizedBox(width: 14.3),
                      GestureDetector(
                        onTap: () {
                          _showPicker(context, pr);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text("Upload Photo",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: kMainColor)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.3,
                  )
                ],
              ),
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
                    'STORE INFO',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                //name textField
                EntryField(
                  controller: storeNameC,
                  textCapitalization: TextCapitalization.words,
                  label: 'STORE NAME',
                  // initialValue: '${storeName}',
                ),
                //phone textField
                EntryField(
                  controller: storeNumberC,
                  label: 'MOBILE NUMBER',
                  // initialValue: '${storeNumber}',
                  readOnly: true,
                ),
                //email textField
                EntryField(
                  controller: storeEmailC,
                  textCapitalization: TextCapitalization.none,
                  label: 'EMAIL ADDRESS',
                  readOnly: true,
                  // initialValue: '${storeEmailAddress}',
                  keyboardType: TextInputType.emailAddress,
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
                    'ADDRESS',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                //address textField
                EntryField(
                  controller: storeAddressC,
                  textCapitalization: TextCapitalization.words,
                  label: 'STORE ADDRESS',
                  image: 'images/ic_pickup pointact.png',
                  // initialValue: '${storeAddress}',
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
                    'STORE TIMINGS',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true, onConfirm: (date) {
                              print('confirm $date');
                              _date = '${date.hour} : ${date.minute}';
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 52.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            size: 18.0,
                                            color: kMainColor,
                                          ),
                                          Text(
                                            " $_date",
                                            style: TextStyle(
                                                color: kMainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Opening Time",
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true, onConfirm: (time) {
                              print('confirm $time');
                              _time = '${time.hour} : ${time.minute}';
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 52.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time,
                                            size: 18.0,
                                            color: kMainColor,
                                          ),
                                          Text(
                                            " $_time",
                                            style: TextStyle(
                                                color: kMainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Closing Time",
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: kGreen)),
                            color: kGreen,
                            onPressed: () {
                              // Navigator.popAndPushNamed(context, PageRoutes.offlinePage)
                              showProgressDialog('Updating please wait...', pr);
                              hitService(pr);
                            },
                            child: Text(
                              'Update Store Timing',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.7,
                                      letterSpacing: 0.06),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //continue button bar
          Visibility(
            visible: false,
            child: BottomBar(text: "UPDATE INFO", onTap: () {}),
          )
        ],
      ),
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

  void hitService(ProgressDialog pr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pr.show();
    var store_timmingd = store_timming;
    var client = http.Client();
    client.post(store_timmingd, body: {
      'vendor_id': '${storeId}',
      'opening_time': '${_date}',
      'closing_time': '${_time}',
    }).then((value) {
      print('${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          Toast.show('Time updated successfully!', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          prefs.setString("opening_time", '${_date}');
          prefs.setString("closing_time", '${_time}');
        } else {
          Toast.show('Something went wrong!', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      } else {
        Toast.show('Something went wrong!', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      pr.hide();
    }).catchError((e) {
      pr.hide();
    });
  }

  void hitServicePic(ProgressDialog pr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pr.show();
    String fid = _image.path.split('/').last;
    ;
    var storeEditUrl = storeprofile_edit;
    var request = http.MultipartRequest("POST", Uri.parse(storeEditUrl));
    request.fields["store_id"] = '${storeId}';
    http.MultipartFile.fromPath("vendor_image", _image.path, filename: fid)
        .then((pic) {
      request.files.add(pic);
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          if (jsonData['status'] == "1") {
            var jsonDatad = jsonData['data'];
            prefs.setString("vendor_logo", '${jsonDatad['vendor_logo']}');
            Toast.show('Image updated successfully....!', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
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
  }
}
