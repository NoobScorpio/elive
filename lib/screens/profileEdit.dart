import 'dart:convert';
import 'dart:io';

import 'package:elive/controllers/databaseController.dart';
import 'package:elive/controllers/localNotificationController.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/stateMangement/user_bloc/userState.dart';
import 'package:elive/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';

class EditProfile extends StatefulWidget {
  final bool googleLogin, emailLogin, phoneLogin;
  final MyUser user;
  const EditProfile(
      {Key key, this.googleLogin, this.emailLogin, this.phoneLogin, this.user})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState(
      phoneLogin: phoneLogin,
      googleLogin: googleLogin,
      emailLogin: emailLogin,
      user: user);
}

class _EditProfileState extends State<EditProfile> {
  final bool googleLogin, emailLogin, phoneLogin;
  _EditProfileState(
      {this.googleLogin, this.emailLogin, this.phoneLogin, this.user});
  final name = TextEditingController();
  final pass = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  MyUser user;
  setUser() async {
    await init();
    name.text = user.name;
    pass.text = user.password;
    dob = user.dob == '' || user.dob == null ? stockDate : user.dob;
    await loginUserState(context);
  }

  DateTime date = DateTime.now();
  String stockDate = "(YYYY-MM-DD)";
  String dob;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setUser();
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
          "Profile Edit",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Image.asset(
              "assets/images/bg.jpeg",
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
                          height: 15,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 51,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 49,
                                  backgroundImage: state.user.photoUrl == ""
                                      ? AssetImage('assets/images/avatar.png')
                                      : NetworkImage(state.user.photoUrl),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) => loader());
                                    try {
                                      List<Media> res = await ImagesPicker.pick(
                                        count: 1,
                                        pickType: PickType.image,
                                        cropOpt: CropOption(
                                          aspectRatio: CropAspectRatio.custom,
                                          cropType: CropType
                                              .rect, // currently for android
                                        ),
                                      );
                                      File image = File(res[0].path);
                                      FirebaseStorage _storage;
                                      UploadTask _uploadTask;
                                      _storage = FirebaseStorage.instanceFor(
                                          bucket:
                                              'gs://elive-bfc34.appspot.com');
                                      String fileName = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      setState(() {
                                        _uploadTask = _storage
                                            .ref()
                                            .child('images')
                                            .child(fileName)
                                            .putFile(image);
                                      });
                                      TaskSnapshot ts = _uploadTask.snapshot;
                                      _uploadTask
                                          .then((TaskSnapshot taskSnapshot) {
                                        taskSnapshot.ref
                                            .getDownloadURL()
                                            .then((value) async {
                                          user.photoUrl = value;

                                          await init();
                                          preferences.setString(
                                              SPS.user.toString(),
                                              json.encode(user.toJson()));
                                          await Database()
                                              .updateUser(user: user);
                                          await loginUserState(context);
                                          Navigator.pop(context);
                                          showToast("Saved", Colors.green);
                                        });
                                      });
                                    } catch (e) {
                                      print("IMAGE UPLOAD EXCEPTION $e");
                                      showToast("${e.message}", Colors.green);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: getPrimaryColor(context),
                                    child: CircleAvatar(
                                      radius: 17,
                                      child: Icon(Icons.image),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: name,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) => loader());
                                    if (name.text.length >= 3) {
                                      user.name = name.text;
                                      await init();
                                      preferences.setString(SPS.user.toString(),
                                          json.encode(user.toJson()));
                                      await Database().updateUser(user: user);
                                      await loginUserState(context);

                                      Navigator.pop(context);
                                      showToast("Saved", Colors.green);
                                    } else {
                                      showToast(
                                          "Name should have at least 3 characters",
                                          Colors.red);
                                    }
                                  },
                                  child: Icon(
                                    Icons.save,
                                    color: Colors.black,
                                  )),
                              hintText: 'Enter name',
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
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) => loader());
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)'
                                        r'|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]'
                                        r'{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp emailRegex = new RegExp(pattern);
                                    if (emailRegex.hasMatch(email.text
                                        .toString()
                                        .trim()
                                        .toLowerCase())) {
                                      user.email = email.text;
                                      await init();
                                      preferences.setString(SPS.user.toString(),
                                          json.encode(user.toJson()));
                                      await Database().updateUser(user: user);
                                      await loginUserState(context);

                                      Navigator.pop(context);
                                      showToast("Saved", Colors.green);
                                    } else {
                                      showToast(
                                          "Enter a valid email", Colors.red);
                                    }
                                  },
                                  child: Icon(
                                    Icons.save,
                                    color: Colors.black,
                                  )),
                              hintText: 'Enter email (For payment purpose)',
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
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) => loader());
                                    if (phone.text.length >= 10) {
                                      user.phone = phone.text;
                                      await init();
                                      preferences.setString(SPS.user.toString(),
                                          json.encode(user.toJson()));
                                      await Database().updateUser(user: user);
                                      await loginUserState(context);

                                      Navigator.pop(context);
                                      showToast("Saved", Colors.green);
                                    } else {
                                      showToast(
                                          "Enter valid email", Colors.red);
                                    }
                                  },
                                  child: Icon(
                                    Icons.save,
                                    color: Colors.black,
                                  )),
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
                              hintText: 'Enter phone',
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Date of birth: $dob",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            var selected = await showDatePicker(
                                                context: context,
                                                firstDate:
                                                    DateTime(1968, 01, 01),
                                                initialDate:
                                                    DateTime(2000, 01, 01),
                                                lastDate: DateTime(2030, 1, 1));

                                            if (selected != null) {
                                              date = selected;
                                              setState(() {
                                                dob = date
                                                    .toString()
                                                    .split(' ')[0];
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.calendar_today_sharp,
                                            color: Colors.red,
                                            size: 20,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            showDialog(
                                                context: context,
                                                builder: (_) => loader());
                                            if (dob != stockDate ||
                                                dob != null) {
                                              user.dob = dob;
                                              await init();
                                              preferences.setString(
                                                  SPS.user.toString(),
                                                  json.encode(user.toJson()));
                                              await Database()
                                                  .updateUser(user: user);
                                              await loginUserState(context);

                                              Navigator.pop(context);
                                              await setScheduleNotificationForBirthDay(
                                                  dob, controller);
                                            } else {
                                              showToast(
                                                  "Name should have at least 3 characters",
                                                  Colors.red);
                                            }
                                          },
                                          child: Icon(
                                            Icons.save,
                                            color: Colors.black,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // if (emailLogin)
                        //   Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: TextField(
                        //       controller: pass,
                        //       keyboardType: TextInputType.number,
                        //       cursorColor: Colors.black,
                        //       decoration: InputDecoration(
                        //         suffixIcon: InkWell(
                        //             onTap: () async {
                        //               showDialog(
                        //                   context: context, builder: (_) => loader());
                        //               if (pass.text.length >= 6) {
                        //                 user.password = pass.text;
                        //                 await init();
                        //                 preferences.setString(
                        //                     sharedPrefs.user.toString(),
                        //                     json.encode(user.toJson()));
                        //                 await Database().updateUser(user: user);
                        //                 await loginUserState(context);
                        //
                        //                 Navigator.pop(context);
                        //                 showToast("Saved", Colors.green);
                        //               } else {
                        //                 showToast(
                        //                     "Name should have at least 3 characters",
                        //                     Colors.red);
                        //               }
                        //             },
                        //             child: Icon(
                        //               Icons.save,
                        //               color: Colors.black,
                        //             )),
                        //         hintText: 'Enter Code',
                        //         border: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.grey)),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.black)),
                        //       ),
                        //       onChanged: (val) {
                        //         // username = val;
                        //       },
                        //     ),
                        //   ),
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
