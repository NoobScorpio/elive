import 'package:elive/utils/bookingCard.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: "My Bookings"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Following are you booking details",
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            BookingCard(),
            BookingCard(),
            BookingCard(),
            BookingCard(),
          ],
        ),
      ),
    );
  }
}
