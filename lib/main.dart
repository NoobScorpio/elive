import 'package:elive/controllers/cartController.dart';
import 'package:elive/screens/bottomNavBar.dart';
import 'package:elive/screens/homeScreen.dart';
import 'package:elive/screens/onboard.dart';
import 'package:elive/screens/signin.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryCubit.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elive',
      theme: ThemeData(
        textTheme: GoogleFonts.karlaTextTheme(),
        primarySwatch: Colors.red,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<UserCubit>(create: (context) => UserCubit()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
        BlocProvider<CartCubit>(
            create: (context) =>
                CartCubit(cartRepository: CartRepositoryImpl())),
      ], child: MyHomePage(title: 'Elive')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title}) : super();
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool first = true, loggedIn = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setBool();
  }

  setBool() async {
    await init();
    bool firstLog = preferences.getBool(SPS.firstOpen.toString());
    if (firstLog == null || firstLog == true) {
      first = true;
    } else {
      first = false;
    }
    bool log = preferences.getBool(SPS.loggedIn.toString());
    if (log == null || log == false) {
      loggedIn = false;
    } else {
      loggedIn = true;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? loader()
          : (first
              ? OnBoardScreen()
              : (loggedIn ? BottomNavBar() : SignInScreen())),
    );
  }
}
