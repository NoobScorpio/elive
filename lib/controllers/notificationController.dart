import 'dart:io';
import 'package:elive/controllers/databaseController.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();
  NotificationController.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }
  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification =
              ReceiveNotification(id, title, body, payload);
          didReceiveLocalNotificationSubject.add(notification);
        });
    initSetting = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  Database db = Database();
  void registerNotification({user}) async {
    await init();

    // var token = await firebaseMessaging.getToken();
    // print("@TOKEN $token");
    // await db.userCollection.doc(user.uid).update({'pushToken': token});
    // await firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: true,
    //   provisional: true,
    //   sound: true,
    // );
    // await firebaseMessaging.setForegroundNotificationPresentationOptions(
    //     alert: true, badge: true, sound: true);
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   showNotification(message);
    // });
    // configLocalNotification();
  }

  setOnNotificationClick(Function onNotificationClick) {
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  setOnNotificationReceive(Function onNotificationReceive) async {
    didReceiveLocalNotificationSubject.listen((value) {
      onNotificationReceive(value);
    });
  }

  Future<void> showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'ID',
      'NAME',
      'DESCRIPTION',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, "Test", "body", platformChannelSpecifics, payload: "Payload");
  }

  Future<void> showScheduleNotification(title, body, {dateTime}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'ID',
      'NAME',
      'DESCRIPTION',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0, "$title", "$body", dateTime, platformChannelSpecifics,
        payload: "Payload");
  }
}

NotificationController controller = NotificationController.init();

class ReceiveNotification {
  final int id;
  final String title, body, payload;

  ReceiveNotification(this.id, this.title, this.body, this.payload);
}
