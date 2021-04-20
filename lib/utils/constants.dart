import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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

const baseURL = 'https://elivebeautyspot.in/admin/api/package';
const imageURL = 'https://elivebeautyspot.in/admin/upload/imagenamehere';
enum sharedPrefs {
  firstOpen,
  loggedIn,
  googleLogIn,
  phoneLogIn,
  emailLogIn,
  user
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
        // CachedNetworkImage(
        //   imageUrl: image,
        //   imageBuilder: (context, image) => Container(
        //     width: special == null ? width * 0.422 : width * 0.9,
        //     height: special == null ? 175 : 145,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //       image: DecorationImage(image: image, fit: BoxFit.cover),
        //     ),
        //   ),
        //   progressIndicatorBuilder: (context, img, progress) => Container(
        //     width: special == null ? width * 0.422 : width * 0.9,
        //     height: special == null ? 175 : 145,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //     ),
        //     child: Container(
        //       height: 50,
        //       width: 50,
        //       child: Center(
        //         child: CircularProgressIndicator(
        //           value: progress.progress,
        //         ),
        //       ),
        //     ),
        //   ),
        //   errorWidget: (context, img, err) => Container(
        //     width: special == null ? width * 0.422 : width * 0.9,
        //     height: special == null ? 175 : 145,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //     ),
        //     child: Center(
        //       child: Icon(
        //         Icons.error_outline,
        //         color: Colors.red,
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          width: special == null ? width * 0.422 : width * 0.9,
          height: special == null ? 175 : 145,
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
        Container(
          width: special == null ? width * 0.422 : width * 0.9,
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
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future loginUserState(context) async {
  String userStr = preferences.getString(sharedPrefs.user.toString());
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
