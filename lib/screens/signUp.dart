import 'dart:convert';

import 'package:elive/controllers/authController.dart';
import 'package:elive/screens/bottomNavBar.dart';
import 'package:elive/screens/signUpPhone.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Authenticate auth = Authenticate();
  final nameCont = TextEditingController();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: "Sign Up"),
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
                controller: nameCont,
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
                controller: emailCont,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
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
                controller: passwordCont,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
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
            InkWell(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => loader());
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)'
                    r'|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]'
                    r'{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp emailRegex = new RegExp(pattern);
                if (emailRegex
                    .hasMatch(emailCont.text.toString().trim().toLowerCase())) {
                  if (passwordCont.text.length >= 6) {
                    if (nameCont.text.length >= 3) {
                      MyUser user = await auth.signUpWithEmail(
                          email: emailCont.text.toString(),
                          name: nameCont.text.toString(),
                          password: passwordCont.text.toString());

                      if (user == null) {
                        Navigator.pop(context);
                        showToast("Please try again", Colors.red);
                      } else {
                        await preferences.setString(sharedPrefs.user.toString(),
                            json.encode(user.toJson()));
                        await preferences.setBool(
                            sharedPrefs.loggedIn.toString(), true);
                        await preferences.setBool(
                            sharedPrefs.emailLogIn.toString(), true);
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
                    } else {
                      //  NAME ELSE
                      Navigator.pop(context);
                      showToast("Name should have at least 3 characters",
                          Colors.black);
                    }
                  } else {
                    //  PASS ELSE
                    Navigator.pop(context);
                    showToast("Password should have at least 6 characters",
                        Colors.black);
                  }
                } else {
                  //  EMAIL ELSE
                  Navigator.pop(context);
                  showToast("Enter a valid Email", Colors.black);
                }
              },
              child: Container(
                width: 240,
                height: 50,
                child: Card(
                    elevation: 5,
                    // color: Color(0xFF4267B2),
                    color: getPrimaryColor(context),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SignUpPhoneScreen()));
              },
              child: Container(
                width: 240,
                height: 50,
                child: Card(
                    elevation: 5,
                    // color: Color(0xFF4267B2),
                    color: Colors.black,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sign Up with Phone',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
              ),
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
