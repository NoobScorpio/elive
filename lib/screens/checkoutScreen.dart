import 'dart:convert';

import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/models/booking.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/models/promo.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String serviceSelected = "Saloon";
  String _date = 'Not Set';
  String _time = "Not Set";
  bool promoBool = false;
  double promoPrice = 0.0;
  DateTime date = DateTime.now();
  final promo = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    names = widget.names;
    total = widget.total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("CheckOut"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2030, 1, 1));

                  setState(() {
                    _date = date.toString().split(' ')[0];
                  });
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
                onPressed: () async {
                  TimeOfDay time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  TimeOfDay nowTime = TimeOfDay.now();
                  DateTime nowDate = DateTime.now();
                  bool past = false;
                  if (nowDate.year == date.year &&
                      nowDate.month == date.month &&
                      nowDate.day == date.day) {
                    if (time.hour < nowTime.hour) {
                      past = true;
                    } else if (time.hour == nowDate.hour) {
                      if (time.minute < nowDate.minute) past = true;
                    }
                  }
                  if (!past) {
                    _time = "${time.hour}:${time.minute}";
                    setState(() {});
                  } else {
                    {
                      showToast("Time cannot be past time", Colors.red);
                      setState(() {
                        _time = "Not Set";
                      });
                    }
                  }
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: promo,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () async {
                        showDialog(context: context, builder: (_) => loader());
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$key',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${names[key]}x',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Petrol Charges',
                      style: headerText,
                    ),
                    Text(
                      '70.0',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            if (promoBool)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promo',
                      style: headerText,
                    ),
                    Text(
                      '$promoPrice',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      promoBool ? '${total - promoPrice}' : '${total}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  if (serviceSelected == 'Home')
                    Text(
                      promoBool
                          ? '${total + 70 - promoPrice}'
                          : '${total + 70}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      showDialog(context: context, builder: (_) => loader());
                      var pref = await SharedPreferences.getInstance();
                      print("PREFS $pref");
                      String str = pref.getString(SPS.user.toString());
                      print("USER STR $str");
                      MyUser user = MyUser.fromJson(json.decode(str));
                      print("USER $user");
                      Booking booking = Booking(
                          userEmail: user.email,
                          firestoreId: user.uid,
                          description: widget.desc,
                          date: _date,
                          time: _time,
                          service: serviceSelected,
                          total: (promoBool
                                  ? (serviceSelected == 'Home'
                                      ? total - promoPrice + 70
                                      : total - promoPrice)
                                  : (serviceSelected == 'Home'
                                      ? total + 70
                                      : total))
                              .toInt());
                      print("BOOKING ${booking.toJson()}");
                      bool book =
                          await ApiController.postBooking(booking: booking);
                      print("BOOKED $book");
                      if (book) {
                        await BlocProvider.of<CartCubit>(context).emptyCart();
                        // Navigator.pop(context);
                        await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              final feed = TextEditingController();
                              return AlertDialog(
                                title: Text("Give Feedback"),
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      TextField(
                                        maxLines: 5,
                                        controller: feed,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          hintText: 'Enter FeedBack',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                        onChanged: (val) {
                                          // username = val;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  InkWell(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) => loader());
                                        var bool =
                                            await ApiController.postFeedback(
                                                email: user.email,
                                                feedback: feed.text);
                                        if (bool) {
                                          Navigator.pop(context);
                                          showToast("Thanks for the feedback",
                                              Colors.green);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Send",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ],
                              );
                            });

                        print("EMPTY CART");
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                        showToast("Booked", Colors.green);
                      } else {
                        Navigator.pop(context);
                        showToast("Not Booked", Colors.red);
                      }
                    }
                  },
                  child: Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
