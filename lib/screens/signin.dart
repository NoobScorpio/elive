import 'dart:convert';

import 'package:elive/controllers/authController.dart';
import 'package:elive/controllers/cartController.dart';
import 'package:elive/screens/bottomNavBar.dart';
import 'package:elive/screens/signUp.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryCubit.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/slider_bloc/sliderCubit.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Authenticate auth = Authenticate();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Header(title: "Sign In"),
                SizedBox(
                  height: 30,
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
                    controller: email,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextField(
                    controller: password,
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
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () {
                        var resetEmail = '';
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Reset Password"),
                                  content: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      hintText: 'Enter email',
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    onChanged: (val) {
                                      resetEmail = val.toString();
                                    },
                                  ),
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (_) => loader());
                                        bool reset =
                                            await auth.sendPasswordResetEmail(
                                                email: resetEmail);
                                        if (reset) {
                                          showToast("Email sent", Colors.green);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Send",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
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
                        .hasMatch(email.text.toString().trim().toLowerCase())) {
                      if (password.text.length >= 6) {
                        MyUser user = await auth.signInWithEmail(
                            email: email.text.toLowerCase(),
                            password: password.text);
                        if (user == null) {
                          showToast("Please try again", Colors.red);
                          Navigator.pop(context);
                        } else {
                          await preferences.setString(
                              SPS.user.toString(), json.encode(user.toJson()));
                          await preferences.setBool(
                              SPS.loggedIn.toString(), true);
                          await preferences.setBool(
                              SPS.emailLogIn.toString(), true);
                          Navigator.pop(context);
                          showToast("Success", Colors.green);
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
                                        BlocProvider<SliderCubit>(
                                            create: (context) => SliderCubit()),
                                        BlocProvider<CartCubit>(
                                            create: (context) => CartCubit(
                                                cartRepository:
                                                    CartRepositoryImpl())),
                                      ], child: BottomNavBar())),
                              (route) => false);
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
                            'Sign In',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => loader());
                    MyUser user = await auth.signInWithGoogle();
                    if (user == null) {
                      Navigator.pop(context);
                      showToast("Please try again", Colors.red);
                    } else {
                      await preferences.setString(
                          SPS.user.toString(), json.encode(user.toJson()));
                      await preferences.setBool(SPS.loggedIn.toString(), true);
                      await preferences.setBool(
                          SPS.googleLogIn.toString(), true);

                      Navigator.pop(context);
                      showToast("Success", Colors.green);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(providers: [
                                    BlocProvider<UserCubit>(
                                      create: (context) => UserCubit(),
                                    ),
                                    BlocProvider<CategoryCubit>(
                                        create: (context) => CategoryCubit()),
                                    BlocProvider<SliderCubit>(
                                        create: (context) => SliderCubit()),
                                    BlocProvider<CartCubit>(
                                        create: (context) => CartCubit(
                                            cartRepository:
                                                CartRepositoryImpl())),
                                  ], child: BottomNavBar())),
                          (route) => false);
                    }
                  },
                  child: Container(
                    width: 240,
                    height: 50,
                    child: Card(
                        elevation: 5,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/google.png'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Sign in with Phone"),
                              content: Container(
                                height: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                          "Note: Sign up with this number before "
                                          "signing in"),
                                    ),
                                    TextField(
                                      controller: phone,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        prefixIcon: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        content: Text(
                                                            "Please enter complete number. For example, "
                                                            "if you are from Dubai enter number like "
                                                            "971xxxxxxxx"),
                                                      ));
                                            },
                                            child: Icon(Icons.info_outline)),
                                        suffixIcon: InkWell(
                                            onTap: () async {
                                              showToast(
                                                  "Sending code", Colors.blue);
                                              await auth.verifyPhone(
                                                  number: phone.text);
                                            },
                                            child: Icon(Icons.send)),
                                        hintText: 'Enter Phone No.',
                                        border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      onChanged: (val) {
                                        // username = val;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: code,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Code',
                                        border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
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
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (_) => loader());
                                    MyUser user =
                                        await auth.signInWithPhoneCredentials(
                                      code: code.text.toString(),
                                    );
                                    if (user == null) {
                                      Navigator.pop(context);
                                      showToast("Please try again", Colors.red);
                                    } else {
                                      await preferences.setString(
                                          SPS.user.toString(),
                                          json.encode(user.toJson()));
                                      await preferences.setBool(
                                          SPS.loggedIn.toString(), true);
                                      await preferences.setBool(
                                          SPS.phoneLogIn.toString(), true);
                                      Navigator.pop(context);
                                      showToast("Success", Colors.green);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  MultiBlocProvider(providers: [
                                                    BlocProvider<UserCubit>(
                                                      create: (context) =>
                                                          UserCubit(),
                                                    ),
                                                    BlocProvider<CategoryCubit>(
                                                        create: (context) =>
                                                            CategoryCubit()),
                                                    BlocProvider<SliderCubit>(
                                                        create: (context) =>
                                                            SliderCubit()),
                                                    BlocProvider<CartCubit>(
                                                        create: (context) =>
                                                            CartCubit(
                                                                cartRepository:
                                                                    CartRepositoryImpl())),
                                                  ], child: BottomNavBar())),
                                          (route) => false);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ));
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
                                'Sign in with Phone',
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Or'),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()));
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
