import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/Themes/colors.dart';

//app theme
final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: kMainColor,
  bottomAppBarColor: kWhiteColor,
  dividerColor: Color(0x1f000000),
  disabledColor: kDisabledColor,
  buttonColor: kMainColor,
  cursorColor: kMainColor,
  indicatorColor: kMainColor,
  accentColor: kMainColor,
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    height: 33,
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        side: BorderSide(color: kMainColor)),
    alignedDropdown: false,
    buttonColor: kMainColor,
    disabledColor: kDisabledColor,
  ),
  appBarTheme: AppBarTheme(
    color: kTransparentColor,
    elevation: 0.0,
  ),
  //text theme which contains all text styles
  textTheme: GoogleFonts.openSansTextTheme().copyWith(
    //text style of 'Delivering almost everything' at phone_number page
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.3,
    ),

    //text style of 'Everything.' at phone_number page
    bodyText2: TextStyle(
      fontSize: 18.3,
      letterSpacing: 1.0,
      color: kDisabledColor,
    ),

    //text style of button at phone_number page
    button: TextStyle(
      fontSize: 13.3,
      color: kWhiteColor,
    ),

    //text style of 'Got Delivered' at home page
    headline4: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16.7,
    ),

    //text style of we'll send verification code at register page
    headline6: TextStyle(
      color: kLightTextColor,
      fontSize: 13.3,
    ),

    //text style of 'everything you need' at home page
    headline5: TextStyle(
      color: kDisabledColor,
      fontSize: 20.0,
      letterSpacing: 0.5,
    ),

    //text entry text style
    caption: TextStyle(
      color: Colors.black,
      fontSize: 13.3,
    ),

    //text style of titles of card at home page
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
    subtitle2: TextStyle(
      color: kLightTextColor,
      fontSize: 15.0,
    ),
  ),
);

//text style of continue bottom bar
final TextStyle bottomBarTextStyle =
    TextStyle(fontSize: 15.0, color: kWhiteColor, fontWeight: FontWeight.w500);

//text style of text input and account page list
final TextStyle inputTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
);

//text style of bottom navigation bar
final TextStyle bottomNavigationTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  letterSpacing: 0.5,
  fontWeight: FontWeight.w600,
);

final TextStyle listTitleTextStyle = TextStyle(
  fontSize: 16.7,
  fontWeight: FontWeight.bold,
  color: kMainColor,
);

final TextStyle orderMapAppBarTextStyle = TextStyle(
  fontSize: 13.3,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

TextStyle headingStyle = TextStyle(
  fontSize: 18.0,
  color: kMainTextColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
);

TextStyle priceStyle = TextStyle(
  fontSize: 18.0,
  color: kMainColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
);

TextStyle whiteSubHeadingStyle = TextStyle(
  fontSize: 14.0,
  color: kWhiteColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.normal,
);

TextStyle wbuttonWhiteTextStyle = TextStyle(
  fontSize: 16.0,
  color: kWhiteColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
);

TextStyle appbarSubHeadingStyle = TextStyle(
  color: kWhiteColor,
  fontSize: 13.0,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
);

TextStyle whiteHeadingStyle = TextStyle(
  fontSize: 22.0,
  color: kWhiteColor,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w500,
);
