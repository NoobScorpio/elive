import 'package:elive/controllers/localNotificationController.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.setOnNotificationReceive(onNotificationReceive);
    controller.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(ReceiveNotification noti) {
    print("NOTIFICATION ID: ${noti.id}");
  }

  onNotificationClick(String payload) {
    print("PAYLOAD $payload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              // await controller.showScheduleNotification();
            },
            child: Container(
                color: Colors.red,
                height: 50,
                width: 100,
                child: Center(child: Text("SEND NOTIFICATION")))),
      ),
    );
  }
}
