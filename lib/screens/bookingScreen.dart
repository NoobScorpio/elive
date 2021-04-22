import 'dart:convert';

import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/utils/bookingCard.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key key}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isLoading = true;
  List<Widget> bookWidgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBookings();
  }

  setBookings() async {
    await init();
    BookingList bookings = await ApiController.getBookings();
    String usrString = preferences.getString(SPS.user.toString());
    MyUser user = MyUser.fromJson(json.decode(usrString));
    String bookingText = "You have no bookings";
    bookWidgets.add(Header(title: "My Bookings"));

    for (var book in bookings.records) {
      if (book.userEmail == user.email) {
        bookingText = "Following are you booking details";
        bookWidgets.add(BookingCard(
          id: book.id,
          price: book.total,
          time: book.time,
          date: book.date,
        ));
      }
    }
    bookWidgets.insert(
        1,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "$bookingText",
                style: TextStyle(fontSize: 16),
              )),
        ));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Image.asset(
              "assets/images/bg.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                if (isLoading)
                  Column(
                    children: [
                      Header(title: "My Bookings"),
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: loader(),
                      ),
                    ],
                  ),
                if (!isLoading) Column(children: bookWidgets)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
