import 'dart:convert';

import 'package:elive/controllers/authController.dart';
import 'package:elive/screens/bottomNavBar.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
            SizedBox(
              height: 20,
            ),
            Container(
              width: 120,
              height: 40,
              child: ElevatedButton(
                  onPressed: () async {
                    if (name.text.length >= 3) {
                      await auth.verifyPhone(number: phone.text);
                    } else {
                      //  NAME ELSE
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                        phoneVerificationID: auth.phoneVerificationID,
                        name: name.text);
                    if (user == null) {
                      Navigator.pop(context);
                      showToast("Please try again", Colors.red);
                    } else {
                      await preferences.setString(sharedPrefs.user.toString(),
                          json.encode(user.toJson()));
                      await preferences.setBool(
                          sharedPrefs.loggedIn.toString(), true);
                      await preferences.setBool(
                          sharedPrefs.phoneLogIn.toString(), true);
                      Navigator.pop(context);
                      showToast("User Created Successfully", Colors.green);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) => UserCubit(),
                                  child: BottomNavBar())),
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
    );
  }
}
