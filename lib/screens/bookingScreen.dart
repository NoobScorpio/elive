import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/utils/bookingCard.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final MyUser user;

  const BookingScreen({Key key, this.user}) : super(key: key);
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
    BookingList bookings = await ApiController.getBookings();
    bookWidgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Following are you booking details",
            style: TextStyle(fontSize: 16),
          )),
    ));
    for (var book in bookings.records) {
      if (book.userEmail == widget.user.email) {
        bookWidgets.add(BookingCard(
          id: book.id,
          price: book.total,
          time: book.time,
          date: book.date,
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: loader(),
              ),
            if (!isLoading) Column(children: bookWidgets)
          ],
        ),
      ),
    );
  }
}
