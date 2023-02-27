import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Auth/login_navigator.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/OrderItemAccount/order_item_account.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/Themes/style.dart';
import 'package:vendor/parcel/parcelmainpage.dart';
import 'package:vendor/pharmacy/order_item_account_pharma.dart';
import 'package:vendor/restaturant/order_item_account_rest.dart';

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setFirebase();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = prefs.getBool('islogin');
  dynamic ui_type = prefs.getString('ui_type');
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kMainColor.withOpacity(0.5),
  ));
  if (ui_type != null && ui_type == "2") {
    runApp(Phoenix(
        child: (result != null && result)
            ? GoMarketMangerHomeRest()
            : GoMarketManger()));
  } else if (ui_type != null && ui_type == "3") {
    runApp(Phoenix(
        child: (result != null && result)
            ? GoMarketMangerHomePharma()
            : GoMarketManger()));
  } else if (ui_type != null && ui_type == "4") {
    runApp(Phoenix(
        child: (result != null && result)
            ? GoMarketMangerHomeParcel()
            : GoMarketManger()));
  } else {
    runApp(Phoenix(
        child: (result != null && result)
            ? GoMarketMangerHome()
            : GoMarketManger()));
  }
}

// if (Platform.isIOS) iosPermission(firebaseMessaging);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void setFirebase() async {
  FirebaseMessaging messaging = FirebaseMessaging();
  iosPermission(messaging);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      AndroidInitializationSettings('logo_user');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  messaging.getToken().then((value) {
    debugPrint('token: ' + value);
  });

  messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(
            flutterLocalNotificationsPlugin,
            '${message['notification']['title']}',
            '${message['notification']['body']}');
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        main();
      },
      onResume: (Map<String, dynamic> message) async {
          main();
      });
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  _showNotification(
      flutterLocalNotificationsPlugin,
      '${title}',
      '${body}');
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    dynamic title,
    dynamic body) async {

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('1232', 'Notify', 'Notify On Shopping',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(presentSound: false);
  IOSNotificationDetails iosDetail = IOSNotificationDetails(presentAlert: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, '${title}', '${body}', platformChannelSpecifics,
      payload: 'item x');
}

Future selectNotification(String payload) async {
  if (payload != null) {
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  _showNotification(
      flutterLocalNotificationsPlugin,
      '${message['notification']['title']}',
      '${message['notification']['body']}');
}

void iosPermission(firebaseMessaging) {
  firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true));
  firebaseMessaging.onIosSettingsRegistered.listen((event) {
    print('${event.provisional}');
  });
}

class GoMarketManger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('hi'),
      ],
      theme: appTheme,
      home: LoginNavigator(),
      routes: PageRoutes().routes(),
    );
  }
}

class GoMarketMangerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('hi'),
      ],
      theme: appTheme,
      home: OrderItemAccount(),
      routes: PageRoutes().routes(),
    );
  }
}


class GoMarketMangerHomeRest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('hi'),
      ],
      theme: appTheme,
      home: OrderItemAccountRest(),
      routes: PageRoutes().routes(),
    );
  }
}

class GoMarketMangerHomeParcel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('hi'),
      ],
      theme: appTheme,
      home: OrderParcelItemAccount(),
      routes: PageRoutes().routes(),
    );
  }
}

class GoMarketMangerHomePharma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('hi'),
      ],
      theme: appTheme,
      home: OrderItemAccountPharma(),
      routes: PageRoutes().routes(),
    );
  }
}
