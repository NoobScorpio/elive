import 'dart:convert';

import 'package:elive/controllers/apiController.dart';
import 'package:elive/controllers/databaseController.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationController {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Database db = Database();
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'ID',
    'NAME',
    'DESC',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  void registerNotification() async {
    await init();
    var userStr = preferences.getString(SPS.user.toString());
    MyUser user = MyUser.fromJson(json.decode(userStr));
    if (user.pushToken == null || user.pushToken == '') {
      var token = await firebaseMessaging.getToken();
      await db.userCollection.doc(user.uid).update({'pushToken': token});
      user.pushToken = token;
      await ApiController.setUserToken(user: user);
      await preferences.setString(
          SPS.user.toString(), json.encode(user.toJson()));
    }
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    await configLocalNotification();
  }

  Future configLocalNotification() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onDidReceiveLocalNotification);
  }

  void showNotification(RemoteMessage message) async {
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification.title,
      message.notification.body,
      platformChannelSpecifics,
    );
  }

  Future onDidReceiveLocalNotification(String payload) async {
    var newPay = jsonDecode(payload);
  }
}
