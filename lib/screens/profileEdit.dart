import 'dart:convert';
import 'dart:io';

import 'package:elive/controllers/databaseController.dart';
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
  final dob = TextEditingController();
  MyUser user;
  setUser() async {
    await init();
    name.text = user.name;
    pass.text = user.password;
    dob.text = user.dob;
    await loginUserState(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
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
      body: SingleChildScrollView(
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
                                  ? AssetImage('assets/images/face.jpg')
                                  : NetworkImage(state.user.photoUrl),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context, builder: (_) => loader());
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
                                      bucket: 'gs://elive-bfc34.appspot.com');
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
                                  _uploadTask.then((TaskSnapshot taskSnapshot) {
                                    taskSnapshot.ref
                                        .getDownloadURL()
                                        .then((value) async {
                                      user.photoUrl = value;

                                      await init();
                                      preferences.setString(SPS.user.toString(),
                                          json.encode(user.toJson()));
                                      await Database().updateUser(user: user);
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
                                    context: context, builder: (_) => loader());
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
                        controller: dob,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context, builder: (_) => loader());
                                if (dob.text != "Not Set") {
                                  user.dob = dob.text;
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
                          hintText: 'DOB (YYYY-MM-DDs)',
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
    );
  }
}
