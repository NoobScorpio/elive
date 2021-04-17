import 'package:elive/screens/bookingScreen.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 21,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.edit, color: getPrimaryColor(context))),
                ),
              ),
            ),
            CircleAvatar(
              radius: 51,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/face.jpg'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Amanda Fernandous",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => BookingScreen()));
                  },
                  child: ListTile(
                    title: Text("My Bookings"),
                    leading: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: Text("Customer Support"),
                  leading: Icon(
                    Icons.message_outlined,
                    color: Colors.black,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: Text("Sign Out"),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
