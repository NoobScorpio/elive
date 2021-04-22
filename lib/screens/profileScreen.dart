import 'package:elive/controllers/apiController.dart';
import 'package:elive/controllers/authController.dart';
import 'package:elive/screens/bookingScreen.dart';
import 'package:elive/screens/profileEdit.dart';
import 'package:elive/screens/signin.dart';
import 'package:elive/screens/supportScreen.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/stateMangement/user_bloc/userState.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool emailLogin = false,
      googleLogin = false,
      phoneLogin = false,
      isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setBool();
    setUser();
  }

  setUser() async {
    await init();
    await loginUserState(context);
  }

  setBool() async {
    await init();
    bool email = preferences.getBool(SPS.emailLogIn.toString());
    bool google = preferences.getBool(SPS.googleLogIn.toString());
    bool phone = preferences.getBool(SPS.phoneLogIn.toString());
    if (email == null || email == false) {
      emailLogin = false;
    } else
      emailLogin = true;
    if (google == null || google == false) {
      googleLogin = false;
    } else
      googleLogin = true;
    if (phone == null || phone == false) {
      phoneLogin = false;
    } else
      phoneLogin = true;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loader()
        : Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
              title: Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    "assets/images/bg.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserInitialState) {
                        return loader();
                      } else if (state is UserLoadingState) {
                        return loader();
                      } else if (state is UserLoadedState) {
                        if (state.user == null) {
                          return loader();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.black,
                                          gradient: LinearGradient(colors: [
                                            Colors.red,
                                            Colors.black
                                          ], tileMode: TileMode.repeated)),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            print(
                                                "USER BEFORE EDIT ${state.user}");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        BlocProvider(
                                                          create: (context) =>
                                                              UserCubit(),
                                                          child: EditProfile(
                                                              phoneLogin:
                                                                  phoneLogin,
                                                              googleLogin:
                                                                  googleLogin,
                                                              emailLogin:
                                                                  emailLogin,
                                                              user: state.user),
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              radius: 21,
                                              child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 20,
                                                  child: Icon(Icons.edit,
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 35.0),
                                      child: Container(
                                        height: 102,
                                        width: 102,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.black,
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                state.user.photoUrl == ""
                                                    ? AssetImage(
                                                        'assets/images/face.jpg')
                                                    : NetworkImage(
                                                        state.user.photoUrl),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${state.user.name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Account",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "ID",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text("${state.user.uid}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              if (googleLogin || emailLogin)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.send,
                                            size: 20,
                                            color: Colors.teal,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Email",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("${state.user.email}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              if (phoneLogin)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            size: 20,
                                            color: Colors.teal,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Phone",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("${state.user.phone}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.celebration,
                                          size: 20,
                                          color: Colors.pink,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "DOB",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text("${state.user.dob ?? "N/A"}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 8.0, vertical: 2),
                              //   child: InkWell(
                              //     onTap: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (_) => BookingScreen()));
                              //     },
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Row(
                              //           children: [
                              //             Icon(
                              //               Icons.calendar_today,
                              //               size: 20,
                              //               color: Colors.blueAccent,
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: Text(
                              //                 "Bookings",
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 18,
                              //                     fontWeight: FontWeight.w400),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         Row(
                              //           children: [
                              //             Text("View",
                              //                 style: TextStyle(
                              //                     color: Colors.grey,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500)),
                              //             Padding(
                              //               padding: const EdgeInsets.only(
                              //                   left: 8.0),
                              //               child: Icon(
                              //                 Icons.arrow_forward_ios,
                              //                 color: Colors.grey,
                              //                 size: 15,
                              //               ),
                              //             )
                              //           ],
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Divider(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: InkWell(
                                  onTap: () async {
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
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter FeedBack',
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
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
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                              InkWell(
                                                  onTap: () async {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            loader());
                                                    var bool =
                                                        await ApiController
                                                            .postFeedback(
                                                                email: state
                                                                    .user.email,
                                                                feedback:
                                                                    feed.text);
                                                    if (bool) {
                                                      Navigator.pop(context);
                                                      showToast(
                                                          "Thanks for the feedback",
                                                          Colors.green);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Send",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                            ],
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.feedback_outlined,
                                        size: 20,
                                        color: Colors.blueAccent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Give Feedback",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SupportScreen()));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.chat_outlined,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Customer Support",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (_) => loader());
                                    var auth = Authenticate();
                                    await auth.signOut(context);
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignInScreen()),
                                        (route) => false);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Sign Out",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (state is UserErrorState) {
                        return loader();
                      } else {
                        return loader();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
