import 'dart:convert';

import 'package:elive/controllers/databaseController.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Authenticate {
  final fbLogin = FacebookLogin();
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Database db = Database();
  String phoneVerificationID;

  Future signInFB() async {
    final FacebookLoginResult result =
        await fbLogin.logIn(permissions: [FacebookPermission.email]);
    print("@FB LOGIN $result");
    final String token = result.accessToken.token;
    final response = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final profile = jsonDecode(response.body);
    print(profile);
    return profile;
  }

  Future signOut(context) async {
    await init();
    await preferences.setBool(sharedPrefs.emailLogIn.toString(), false);
    await preferences.setBool(sharedPrefs.googleLogIn.toString(), false);
    await preferences.setBool(sharedPrefs.phoneLogIn.toString(), false);
    await preferences.setBool(sharedPrefs.loggedIn.toString(), false);
    await preferences.setString(sharedPrefs.user.toString(), "");
    // await BlocProvider.of<UserCubit>(context).logOut();
    await auth.signOut();
  }

  Future<MyUser> signUpWithPhoneCredentials(
      {code, phoneVerificationID, name}) async {
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: phoneVerificationID, smsCode: code);

      final UserCredential authCred = await auth.signInWithCredential(cred);
      final user = authCred.user;
      if (authCred?.user != null) {
        bool find = await db.userAvailable(user.uid);
        if (find) {
          showToast("User already created", Colors.red);
        } else {
          MyUser myUser = MyUser(
              uid: user.uid,
              name: name,
              email: "",
              phone: user.phoneNumber,
              password: "",
              photoUrl: user.photoURL ?? "");
          bool stored = await db.createUser(user: myUser);
          if (stored) {
            return myUser;
          } else {
            return null;
          }
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print("PHONE SIGN UP ERROR $e");
      return null;
    }
  }

  Future<MyUser> signInWithPhoneCredentials({code}) async {
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: phoneVerificationID, smsCode: code);

      final UserCredential authCred = await auth.signInWithCredential(cred);
      final user = authCred.user;
      if (authCred?.user != null) {
        bool find = await db.userAvailable(user.uid);
        if (find) {
          MyUser myUser = await db.getUser(user: user);
          return myUser;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("PHONE SIGN IN ERROR $e");
      return null;
    }
  }

  Future verifyPhone({String number}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+$number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // signInWithPhoneCredentials(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("${e.message}");
        showToast("${e.message}", Colors.red);
      },
      codeSent: (String verificationId, int resendToken) async {
        this.phoneVerificationID = verificationId;
        showToast("Verification code sent", Colors.green);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<MyUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResults = await auth.signInWithCredential(credential);
      final user = authResults.user;

      bool find = await db.userAvailable(user.uid);
      MyUser myUser = MyUser(
          uid: user.uid,
          name: user.displayName,
          email: user.email,
          phone: "",
          password: "",
          photoUrl: user.photoURL ?? "");
      if (!find) {
        print("User not available");
        bool stored = await db.createUser(user: myUser);
        if (stored) {
          return myUser;
        } else {
          return null;
        }
      } else {
        print("User  available");
        return myUser;
      }
    } catch (e) {
      print("SIGN IN WITH GOOGLE EXEPTION $e");
      return null;
    }
  }

  Future signInWithEmail({email, password}) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email.trim().trimRight().trimLeft(), password: password);
      User user = result.user;
      MyUser saved = await db.getUser(user: user);
      if (saved == null) {
        return null;
      } else
        return saved;
    } on FirebaseAuthException catch (e) {
      print("SIGN IN WITH EMAIL EXCEPTION $e");
      showToast(e.message, Colors.red);
      return null;
    }
  }

  Future signUpWithEmail({name, email, password}) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email.trim().trimRight().trimLeft(), password: password);
      User user = result.user;
      MyUser myUser = MyUser(
          uid: user.uid,
          name: name,
          email: email,
          phone: "",
          password: password,
          photoUrl: "");
      bool saved = await db.createUser(user: myUser);
      if (saved) {
        return myUser;
      } else
        return null;
    } on FirebaseAuthException catch (e) {
      print("SIGN UP WITH EMAIL EXCEPTION $e");
      showToast(e.message, Colors.red);
      return null;
    }
  }
}
