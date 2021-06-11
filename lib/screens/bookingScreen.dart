import 'dart:convert';

import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/booking_bloc/bookingCubit.dart';
import 'package:elive/stateMangement/booking_bloc/bookingState.dart';
import 'package:elive/stateMangement/models/booking.dart';
import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/utils/bookingCard.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key key}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Widget> bookWidgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBookings();
  }

  setBookings() async {
    await init();
    await BlocProvider.of<BookingCubit>(context).getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Image.asset(
              "assets/images/bg.jpeg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
              if (state is BookingInitialState) {
                return loader();
              } else if (state is BookingLoadingState) {
                return loader();
              } else if (state is BookingLoadedState) {
                if (state.bookings == null) {
                  return loader();
                } else {
                  List<Widget> cartItemWidgets = [];
                  if (state.bookings.records == null ||
                      state.bookings.records.length == 0) {
                    cartItemWidgets = [
                      Header(title: "My Bookings"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('You do not have any bookings'),
                      )
                    ];
                  } else {
                    bookWidgets = [];
                    BookingList bookings = state.bookings;
                    String usrString =
                        preferences.getString(SPS.user.toString());
                    MyUser user = MyUser.fromJson(json.decode(usrString));
                    String bookingText = "You have no bookings";
                    bookWidgets.add(Header(title: "My Bookings"));

                    for (int i = bookings.records.length - 1; i >= 0; i--) {
                      var book = bookings.records[i];
                      if (book.firestoreId == user.uid ||
                          book.userEmail == user.email) {
                        bookingText = "Following are you booking details";
                        bookWidgets.add(BookingCard(
                            status: book.status,
                            id: book.id,
                            price: book.total,
                            time: book.time,
                            date: book.date,
                            email: user.email));
                      }
                    }
                    bookWidgets.insert(
                        1,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "$bookingText",
                                style: TextStyle(fontSize: 16),
                              )),
                        ));

                    return Column(children: bookWidgets);
                  }
                  return Scaffold(
                    body: Stack(
                      children: [
                        Opacity(
                          opacity: 0.05,
                          child: Image.asset(
                            "assets/images/bg.jpeg",
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: cartItemWidgets,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (state is BookingErrorState) {
                return loader();
              } else {
                return Text(
                  "User not loaded",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
