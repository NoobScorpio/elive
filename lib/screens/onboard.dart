import 'package:elive/screens/bottomNavBar.dart';
import 'package:elive/screens/signin.dart';
import 'package:elive/utils/constants.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnBoardScreenState createState() => new _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  //Create a list of PageModel to be set on the onBoarding Screens.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBool();
  }

  setBool() async {
    await init();
    await preferences.setBool(sharedPrefs.firstOpen.toString(), false);
  }

  @override
  Widget build(BuildContext context) {
    final pageList = [
      PageModel(
          color: Colors.black,
          heroImagePath: 'assets/images/sign-in.png',
          title: Text('Sign up / Sign in',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text('SignUp or SignIn to Elive to get Started\n\nSwipe next',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          icon: Icon(Icons.person_add_alt)),
      PageModel(
          color: Colors.black,
          heroImagePath: 'assets/images/lipstick.png',
          title: Text('Book Services',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 34.0,
              )),
          body: Text(
              'Book multiple saloon services at home or in saloon\n\nSwipe next',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
          icon: Icon(Icons.workspaces_outline)),
      PageModel(
        color: Colors.black,
        heroImagePath: 'assets/images/debit-card.png',
        title: Text('Online Payments',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('Pay for all services through your cards',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        icon: Icon(
          Icons.payment,
        ),
      ),
    ];
    return Scaffold(
      //Pass pageList and the mainPage route.
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        skipButtonColor: Colors.black,
        doneButtonBackgroundColor: Colors.black,
        pageList: pageList,
        onDoneButtonPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => SignInScreen())),
        onSkipButtonPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => SignInScreen())),
      ),
    );
  }
}
