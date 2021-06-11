import 'dart:convert';

import 'package:elive/controllers/apiController.dart';
import 'package:elive/controllers/localNotificationController.dart';
import 'package:elive/screens/payment_screen.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/models/booking.dart';
import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/models/promo.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CheckOutScreen extends StatefulWidget {
  final names, total, desc;

  const CheckOutScreen({Key key, this.names, this.total, this.desc})
      : super(key: key);
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  Map<String, int> names;
  double total;
  List<String> services = ["Home", "Saloon"];
  List<String> saloonTimes = [
    "Not Set",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
  ];
  String saloonTimeSelected = "Not Set";
  var bookings;
  String serviceSelected = "Saloon";
  String _date = 'Not Set';
  String _time = "Not Set";
  bool promoBool = false;
  double promoPrice = 0.0;
  DateTime date = DateTime.now();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  var smtpServer;
  final promo = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    names = widget.names;
    total = widget.total;
    smtpServer = gmail(username, password);
    controller.setOnNotificationReceive(onNotificationReceive);
    controller.setOnNotificationClick(onNotificationClick);
    getBookings();
  }

  getBookings() async {
    bookings = await ApiController.getBookings();
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("CheckOut"),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              "assets/images/bg.jpeg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Text(
                      "Select Services",
                      style: headerText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.red,
                        ),
                        iconSize: 42,
                        value: serviceSelected,
                        focusColor: Colors.red,
                        items: services.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$value',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            serviceSelected = _;
                            print(serviceSelected);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                if (serviceSelected == 'Home')
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, top: 0, bottom: 10),
                    child: Text(
                      'Please be informed, on selecting the Home Service, additional '
                      '70 AED will be added in total cart value',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      List<String> newList = [
                        "Not Set",
                        "09:00 AM",
                        "10:00 AM",
                        "11:00 AM",
                        "12:00 PM",
                        "01:00 PM",
                        "02:00 PM",
                        "03:00 PM",
                        "04:00 PM",
                        "05:00 PM",
                        "06:00 PM",
                        "07:00 PM",
                        "08:00 PM",
                      ];
                      var copyList = newList;
                      date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2030, 1, 1)) ??
                          DateTime.now();
                      showDialog(context: context, builder: (c) => loader());

                      bool contains = false;
                      for (var book in bookings.records) {
                        var bookTime = book.time.split(":")[0] +
                            ":" +
                            book.time.split(":")[1];
                        if (book.date.contains(date.toString().split(' ')[0])) {
                          for (int i = 0; i < newList.length; i++) {
                            if (newList[i].contains(bookTime)) {
                              setState(() {
                                newList.removeAt(i);
                              });
                            }
                          }
                          contains = true;
                        }
                      }
                      if (!contains) {
                        setState(() {
                          newList = copyList;
                        });
                      }

                      selectedDate = date;
                      setState(() {
                        _date = date.toString().split(' ')[0];
                        saloonTimes = newList;
                        saloonTimeSelected = "Not Set";
                        _time = "Not Set";
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " $_date",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      " $_time",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              width: 150,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                iconSize: 42,
                                value: saloonTimeSelected,
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                items: saloonTimes.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '$value',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (_) {
                                  setState(() {
                                    _time = _;
                                    saloonTimeSelected = _;
                                    print(saloonTimeSelected);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Add Promo",
                      style: headerText,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: TextField(
                    controller: promo,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () async {
                            showDialog(
                                context: context, builder: (_) => loader());
                            Promo pro = await ApiController.getPromos();
                            bool applied = false;
                            for (var p in pro.records) {
                              if (p.name == promo.text) {
                                setState(() {
                                  promoPrice =
                                      ((total / 100) * int.parse(p.discount));
                                  promoBool = true;
                                  applied = true;
                                });
                                break;
                              }
                            }
                            if (applied) {
                              Navigator.pop(context);
                              showToast("Applied", Colors.green);
                            } else {
                              Navigator.pop(context);
                              showToast("Wrong Promo", Colors.red);
                            }
                          },
                          child: Icon(
                            Icons.done,
                          )),
                      hintText: 'Enter Promo',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    onChanged: (val) {
                      // username = val;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          for (var key in names.keys)
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$key',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${names[key]}x',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (serviceSelected == 'Home')
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Additional Charges',
                          style: headerText,
                        ),
                        Text(
                          'AED 70.0',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                if (promoBool)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promo',
                          style: headerText,
                        ),
                        Text(
                          '$promoPrice',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: (serviceSelected == 'Home') ? 0 : 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: headerText,
                      ),
                      if (serviceSelected == 'Saloon')
                        Text(
                          promoBool
                              ? 'AED ${total - promoPrice}'
                              : 'AED $total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      if (serviceSelected == 'Home')
                        Text(
                          promoBool
                              ? 'AED ${total + 70 - promoPrice}'
                              : 'AED ${total + 70}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_time == 'Not Set' || _date == 'Not Set') {
                          showToast("Select date and time", Colors.red);
                        } else {
                          showDialog(
                              context: context, builder: (_) => loader());
                          var pref = await SharedPreferences.getInstance();
                          print("PREFS $pref");
                          String str = pref.getString(SPS.user.toString());
                          print("USER STR $str");
                          MyUser user = MyUser.fromJson(json.decode(str));
                          print("USER $user");
                          if (user.email == "" || user.email == null) {
                            Navigator.pop(context);
                            showToast(
                                "Kindly add your email from profile settings",
                                Colors.red);
                          } else {
                            bool avail = true;
                            var nowTime = _time.split(' ')[0];
                            var nowDateStr = _date;
                            // print("CHECKING $nowDateStr $nowTime");
                            BookingList books =
                                await ApiController.getBookings();
                            for (var bookObj in books.records) {
                              if (bookObj.date == nowDateStr) {
                                if (bookObj.time.contains(nowTime))
                                  avail = false;
                              }
                            }
                            if (avail) {
                              showToast("Redirecting", Colors.green);
                              int finalTotal = (promoBool
                                      ? (serviceSelected == 'Home'
                                          ? total - promoPrice + 70
                                          : total - promoPrice)
                                      : (serviceSelected == 'Home'
                                          ? total + 70
                                          : total))
                                  .toInt();
                              double sendingPrice = finalTotal.toDouble();
                              try {
                                var response =
                                    await http.get(Uri.parse(exchangeAPI));
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  double rate = json
                                      .decode(response.body)["conversion_rate"];
                                  sendingPrice = sendingPrice * rate;
                                } else {
                                  showToast(
                                      "Could not get AED to USD conversion rate",
                                      Colors.red);
                                }
                              } catch (e) {
                                showToast(
                                    "Could not get AED to USD conversion rate",
                                    Colors.red);
                                print("RESPONSE ERROR");
                                print(e);
                              }
                              bool payedPrice = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PaymentScreen(
                                            price: sendingPrice,
                                            email: user.email,
                                          )));
                              // bool payedPrice = true;
                              if (payedPrice != null && payedPrice == true) {
                                Booking booking = Booking(
                                    userEmail:
                                        user.email == '' || user.email == null
                                            ? 'someone@gmail.com'
                                            : user.email,
                                    firestoreId: user.uid,
                                    description: widget.desc,
                                    date: _date,
                                    time: _time.split(" ")[0],
                                    service: serviceSelected,
                                    token: user.pushToken,
                                    total: finalTotal);
                                print("BOOKING ${booking.toJson()}");
                                bool book = await ApiController.postBooking(
                                    booking: booking);
                                print("BOOKED $book");
                                if (book != null && book == true) {
                                  await BlocProvider.of<CartCubit>(context)
                                      .emptyCart();
                                  String bookingText =
                                      'Following are selected Services\n'
                                      '${widget.desc}\n'
                                      'Total charges: $total\n\n'
                                      'Thank you !!';

                                  final message = Message()
                                    ..from = Address(username, 'Elive')
                                    ..recipients.add(user.email)
                                    ..subject = 'Booking Confirmed'
                                    ..text = '$bookingText'
                                    ..html = "<h1>Support</h1>\n<p>Hey! ${user.email} you have "
                                        "a booking on $_date at $_time with following details</p>\n"
                                        "<p><h3>Following are selected Services</h3>\n</p>"
                                        "<p>${widget.desc}\n</p>"
                                        "<p><h3>Total charges: $total</h3>\n\n</p>"
                                        "<p>Thank you !!</p>";
                                  try {
                                    final sendReport =
                                        await send(message, smtpServer);
                                    //print('Message sent: ' + sendReport.toString());
                                    showToast("Email Sent", Colors.green);
                                    print("@EMAIL SENT");
                                  } on MailerException catch (e) {
                                    //print('Message not sent.');
                                    for (var p in e.problems) {
                                      //print('Problem: ${p.code}: ${p.msg}');
                                    }
                                  }

                                  if (_time.contains("AM")) {
                                    var str = _time.split(" ")[0];
                                    List<String> t = str.split(":");
                                    int hour = int.parse(t[0]);
                                    int min = int.parse(t[1]);
                                    var schedule = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        hour - 1,
                                        min);
                                    print("NOTIFICATION TIME $schedule");
                                    await controller.showScheduleNotification(
                                        'Booking Reminder',
                                        'You have a booking on $_date at $_time',
                                        dateTime: schedule);
                                  } else {
                                    if (_time.contains("12")) {
                                      var str = _time.split(" ")[0];
                                      List<String> t = str.split(":");
                                      int hour = int.parse(t[0]);
                                      int min = int.parse(t[1]);
                                      var schedule = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          12,
                                          min);
                                      print("NOTIFICATION TIME $schedule");
                                      await controller.showScheduleNotification(
                                          'Booking Reminder',
                                          'You have a booking on $_date at $_time',
                                          dateTime: schedule);
                                    } else {
                                      var str = _time.split(" ")[0];
                                      List<String> t = str.split(":");
                                      int hour = int.parse(t[0]) + 12;
                                      int min = int.parse(t[1]);
                                      var schedule = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          hour - 1,
                                          min);
                                      print("NOTIFICATION TIME $schedule");
                                      await controller.showScheduleNotification(
                                          'Booking Reminder',
                                          'You have a booking on $_date at $_time',
                                          dateTime: schedule);
                                    }
                                  }
                                  // print("EMPTY CART");
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                  showToast("Booked", Colors.green);
                                  showToast(
                                      "Awaiting Confirmation", Colors.green);
                                } else {
                                  Navigator.pop(context);
                                  showToast("Not Booked", Colors.red);
                                }
                              } else {
                                showToast("Payment Failed", Colors.red);
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                              showToast("Time not available", Colors.red);
                            }
                          }
                        }
                      },
                      child: Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //
      //   },
      // ),
    );
  }
}
