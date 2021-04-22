import 'dart:convert';

import 'package:elive/controllers/authController.dart';
import 'package:elive/controllers/notificationController.dart';
import 'package:elive/screens/bottomNavBar.dart';
import 'package:elive/stateMangement/category_bloc/categoryCubit.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPhoneScreen extends StatefulWidget {
  @override
  _SignUpPhoneScreenState createState() => _SignUpPhoneScreenState();
}

class _SignUpPhoneScreenState extends State<SignUpPhoneScreen> {
  final Authenticate auth = Authenticate();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController code = TextEditingController();
  DateTime date = DateTime.now();
  String stockDate = "(YYYY-MM-DD)";
  String dob;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dob = stockDate;
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
      body: Stack(
        children: [
          Opacity(
            opacity: 0.07,
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
                Header(title: "Phone Sign Up"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back))),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 42,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/logo.jpeg'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Elive Beauty Saloon",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: name,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Full Name',
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
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: phone,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: Text(
                                          "Please enter complete number. For example, "
                                          "if you are from Dubai enter number like "
                                          "+971xxxxxxxx"),
                                    ));
                          },
                          child: Icon(Icons.info_outline)),
                      hintText: 'Enter Phone No.',
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
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Date of birth: $dob",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                              onTap: () async {
                                var selected = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2030, 1, 1));

                                if (selected != null) {
                                  date = selected;
                                  setState(() {
                                    dob = date.toString().split(' ')[0];
                                  });
                                }
                              },
                              child: Icon(
                                Icons.calendar_today_sharp,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (name.text.length >= 3) {
                          showToast("Sending code", Colors.blue);
                          if (dob != '') {
                            await auth.verifyPhone(number: phone.text);
                          } else {
                            //  DOB ELSE

                            showToast("Select birth date", Colors.blue);
                          }
                        } else {
                          //  NAME ELSE
                          showToast(
                              "Name have at least 3 characters", Colors.blue);
                        }
                      },
                      child: Text(
                        'Send Code',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: code,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Code',
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => loader());
                        MyUser user = await auth.signUpWithPhoneCredentials(
                            code: code.text,
                            dob: dob,
                            phoneVerificationID: auth.phoneVerificationID,
                            name: name.text);
                        if (user == null) {
                          Navigator.pop(context);
                          showToast("Please try again", Colors.red);
                        } else {
                          await preferences.setString(
                              SPS.user.toString(), json.encode(user.toJson()));
                          await preferences.setBool(
                              SPS.loggedIn.toString(), true);
                          await preferences.setBool(
                              SPS.phoneLogIn.toString(), true);
                          Navigator.pop(context);
                          showToast("User Created Successfully", Colors.green);
                          List<String> dobList = dob.split("-");
                          await controller.showScheduleNotification(
                              'Happy Birthday',
                              'Elive Wishes you a very happy birthday',
                              dateTime: DateTime(
                                int.parse(dobList[0]),
                                int.parse(dobList[1]),
                                int.parse(dobList[2]),
                              ));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<UserCubit>(
                                          create: (context) => UserCubit(),
                                        ),
                                        BlocProvider<CategoryCubit>(
                                            create: (context) =>
                                                CategoryCubit()),
                                      ], child: BottomNavBar())),
                              (route) => false);
                        }
                      },
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an Account? Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
