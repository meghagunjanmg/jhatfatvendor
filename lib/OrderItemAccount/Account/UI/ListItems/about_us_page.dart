import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/baseurl/baseurl.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutUsPageState();
  }
}

class AboutUsPageState extends State<AboutUsPage> {
  dynamic htmlString = '';

  @override
  void initState() {
    super.initState();
    getTnc();
  }

  void getTnc() async {
    var client = http.Client();
    var url = aboutus;
    client.get(url).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && jsonDecode(value.body)['status'] == "1") {
        var jsonData = jsonDecode(value.body);
        var dataList = jsonData['data'] as List;
        setState(() {
          htmlString = dataList[0]['termcondition'];
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainColor),
        titleSpacing: 0.0,
        title: Text('About Us', style: Theme.of(context).textTheme.bodyText1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: kCardBackgroundColor,
                child: Image(
                  image: AssetImage("images/logos/logo_store.png"),
                  centerSlice: Rect.largest,
                  fit: BoxFit.fill,
                  height: 220,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '\n${htmlString}',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
