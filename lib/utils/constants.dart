import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/models/cart.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

MaterialColor getPrimaryColor(context) {
  return Colors.red;
}

String username = 'elivebeautyspotdubai@gmail.com';
String password = 'elivebeautyspot@123';
const baseURL = 'https://elivebeautyspot.in/admin/api/package';
const imageURL = 'https://elivebeautyspot.in/admin/upload';
const exchangeKey = "ffa2d673409fbab701b15504";
const exchangeAPI =
    'https://v6.exchangerate-api.com/v6/$exchangeKey/pair/AED/USD';
enum SPS {
  firstOpen,
  loggedIn,
  googleLogIn,
  phoneLogIn,
  emailLogIn,
  user,
  promo
}
SharedPreferences preferences;
Future init() async {
  preferences = await SharedPreferences.getInstance();
}

const headerText =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87);

const cardText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87);

Widget getCard({title, image, height, width, special}) {
  return Card(
    color: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    elevation: 6,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: image,
          imageBuilder: (context, image) => Container(
            width: width * 0.45,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              image: DecorationImage(image: image, fit: BoxFit.cover),
            ),
          ),
          progressIndicatorBuilder: (context, img, progress) => Container(
            width: width * 0.422,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Container(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
            ),
          ),
          errorWidget: (context, img, err) => Container(
            width: width * 0.422,
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            ),
          ),
        ),
        // Container(
        //   width:  width * 0.422 : width * 0.9,
        //   height:  175 : 145,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //   ),
        //   child: Center(
        //     child: Icon(
        //       Icons.error_outline,
        //       color: Colors.red,
        //     ),
        //   ),
        // ),
        Container(
          width: width * 0.422,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        )
      ],
    ),
  );
}

Widget getServiceCard({title, image, height, width}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    elevation: 3,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 0.422,
          height: 125,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: width * 0.422,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        )
      ],
    ),
  );
}

void showToast(String msg, Color color) {
  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future loginUserState(context) async {
  String userStr = preferences.getString(SPS.user.toString());
  if (userStr == null) {
    await BlocProvider.of<UserCubit>(context).loginUser(null);
  } else {
    MyUser user = MyUser.fromJson(json.decode(userStr));
    await BlocProvider.of<UserCubit>(context).loginUser(user);
  }
}

Widget loader() {
  return Center(
    child: Container(
      height: 100,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        color: Colors.black,
      ),
    ),
  );
}

Future setScheduleNotificationForBirthDay(dob, controller) async {
  List<String> dobList = dob.split("-");
  int year = int.parse(dobList[0]);
  int month = int.parse(dobList[1]);
  int day = int.parse(dobList[2]);
  DateTime schedule;
  if (month <= DateTime.now().month) {
    if (day <= DateTime.now().day) {
      schedule = DateTime(
        DateTime.now().year + 1,
        month,
        day,
      );
    } else {
      schedule = DateTime(
        DateTime.now().year,
        month,
        day,
      );
    }
  } else {
    schedule = DateTime(
      DateTime.now().year,
      month,
      day,
    );
  }
  await controller.showScheduleNotification(
      'Happy Birthday', 'Elive Wishes you a very happy birthday',
      dateTime: schedule);
  showToast("Saved", Colors.green);
}

Widget itemsCard(context,
    {image, itemName, itemPrice, packageId, itemId, widgetImage, time}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 15,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(image),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemName,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Time required: ' + (time == "" ? "N/A" : time),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'AED: ' + itemPrice,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    CartItem cartItem = CartItem();
                    cartItem.qty = 1;
                    cartItem.name = itemName;
                    cartItem.pid = int.parse(packageId);
                    cartItem.id = int.parse(itemId);
                    cartItem.price = itemPrice;
                    cartItem.pName = itemName;
                    cartItem.img = widgetImage;
                    bool added = await BlocProvider.of<CartCubit>(context)
                        .removeItem(itemName, qty: 1);
                    if (added) {
                      {
                        showToast("Service Removed", Colors.red);
                      }
                    } else
                      showToast('Could not remove from cart', Colors.red);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Center(
                            child: Text(
                          '-',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 40,
                    width: 0.75,
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    CartItem cartItem = CartItem();
                    cartItem.qty = 1;
                    cartItem.name = itemName;
                    cartItem.pid = int.parse(packageId);
                    cartItem.id = int.parse(itemId);
                    cartItem.price = itemPrice;
                    cartItem.pName = itemName;
                    cartItem.img = widgetImage;
                    bool added = await BlocProvider.of<CartCubit>(context)
                        .addItem(cartItem);
                    if (added) {
                      {
                        showToast("Service Added", Colors.green);
                      }
                    } else
                      showToast('Could not add to cart', Colors.red);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Center(child: Text('+'))),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
