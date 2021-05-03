import 'package:cached_network_image/cached_network_image.dart';
import 'package:elive/controllers/apiController.dart';
import 'package:elive/controllers/cartController.dart';
import 'package:elive/controllers/localNotificationController.dart';
import 'package:elive/controllers/pushNotificationController.dart';
import 'package:elive/screens/itemsScreen.dart';
import 'package:elive/screens/profileScreen.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryState.dart';
import 'package:elive/stateMangement/slider_bloc/sliderCubit.dart';
import 'package:elive/stateMangement/slider_bloc/sliderState.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/stateMangement/user_bloc/userState.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<String> services = ["Home", "Saloon"];
  String serviceSelected = "Home";
  setUser() async {
    await init();
    await loginUserState(context);
    await BlocProvider.of<CategoryCubit>(context).getCategory();
    await BlocProvider.of<SliderCubit>(context).getImages();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return loading
        ? loader()
        : Scaffold(
            // backgroundColor: Colors.black,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: double.maxFinite,
                      //   height: 60,
                      //   color: Colors.black,
                      // ),
                      Stack(
                        children: [
                          Container(
                            height: 200,
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 160,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 60),
                              child: BlocBuilder<UserCubit, UserState>(
                                builder: (context, state) {
                                  if (state is UserInitialState) {
                                    return Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    );
                                  } else if (state is UserLoadingState) {
                                    return Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    );
                                  } else if (state is UserLoadedState) {
                                    if (state.user == null) {
                                      return Text(
                                        "Loading...",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      );
                                    } else {
                                      //TODO: CHANGE LOCATION IF PROBLEM OCCUR
                                      PushNotificationController()
                                          .registerNotification();
                                      try {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => BlocProvider(
                                                              create: (context) =>
                                                                  UserCubit(),
                                                              child:
                                                                  ProfileScreen())));
                                                },
                                                child: state.user.photoUrl == ''
                                                    ? Icon(
                                                        Icons.person_pin,
                                                        color: getPrimaryColor(
                                                            context),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            getPrimaryColor(
                                                                context),
                                                        radius: 20,
                                                        child: CircleAvatar(
                                                          radius: 19,
                                                          backgroundImage:
                                                              NetworkImage(state
                                                                  .user
                                                                  .photoUrl),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Hello, ${state.user.name}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  "Book what you love",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } catch (e) {
                                        print(e);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Could not load"),
                                        );
                                      }
                                    }
                                  } else if (state is UserErrorState) {
                                    return Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    );
                                  } else {
                                    return Text(
                                      "User not loaded",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: getPrimaryColor(context),
                              radius: 42,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage('assets/images/logo.jpeg'),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          "Services Available",
                          style: headerText,
                        ),
                      ),

                      BlocBuilder<SliderCubit, SliderState>(
                          builder: (context, state) {
                        if (state is SliderInitialState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else if (state is SliderLoadingState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else if (state is SliderLoadedState) {
                          if (state.images == null) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                child: Swiper(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String img = '$imageURL' +
                                        '/' +
                                        '${state.images.records[index].image}';
                                    return CachedNetworkImage(
                                      imageUrl: img,
                                      imageBuilder: (context, image) => Card(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        elevation: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                                image: NetworkImage(img),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, img, progress) => Card(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        elevation: 6,
                                        child: Container(
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, img, err) => Card(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        elevation: 6,
                                        child: Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                    Card(
                                      color: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      elevation: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '$imageURL' +
                                                    '/' +
                                                    '${state.images.records[index].image}',
                                              ),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: state.images.records.length,
                                  viewportFraction: 0.65,
                                  scale: 0.80,
                                ),
                              ),
                            );
                          }
                        } else if (state is SliderErrorState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else {
                          return Text(
                            "Slider not loaded",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          "Popular Categories",
                          style: headerText,
                        ),
                      ),
                      BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                        if (state is CategoryInitialState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else if (state is CategoryLoadingState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else if (state is CategoryLoadedState) {
                          if (state.category == null) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            );
                          } else {
                            List<Widget> widgets = [];

                            for (int i = 0;
                                i < state.category.records.length;
                                i++) {
                              widgets.add(InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              BlocProvider<CartCubit>(
                                                create: (context) => CartCubit(
                                                    cartRepository:
                                                        CartRepositoryImpl()),
                                                child: ItemsScreen(
                                                  width: width,
                                                  cid: int.parse(state.category
                                                      .records[i].packageId),
                                                  category: state.category
                                                      .records[i].pname,
                                                  image: "$imageURL" +
                                                      "/" +
                                                      "${state.category.records[i].packagePic}",
                                                ),
                                              )));
                                },
                                child: getCard(
                                    title: "${state.category.records[i].pname}",
                                    image: "$imageURL" +
                                        "/" +
                                        "${state.category.records[i].packagePic}",
                                    width: width),
                              ));
                              print(state.category.records[i].packagePic);
                            }
                            print("HEIGHT $height WIDTH $width");
                            return GridView.builder(
                              itemCount: widgets.length,
                              padding: const EdgeInsets.all(15),
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: width < 390
                                    ? (height < 750 ? 2 / 2.85 : 2 / 2.9)
                                    : 2 / 2.525,
                              ),
                              itemBuilder: (context, index) => widgets[index],
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            );
                          }
                        } else if (state is CategoryErrorState) {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        } else {
                          return Text(
                            "User not loaded",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          );
                        }
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 260,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          AssetImage('assets/images/logo.jpeg'),
                                    ),
                                  ),
                                  Text(
                                    'Elive Beauty Spot',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '+966-86947583',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Mobile | United Arab Emirates',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: IconButton(
                                            color: Colors.white,
                                            icon: Icon(Icons.call),
                                            onPressed: () {
                                              _launchURL("tel:+96686947583");
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                            color: Colors.white,
                                            icon: Icon(Icons.message),
                                            onPressed: () {
                                              _launchURL(
                                                  "sms:+96686947583?body=How can we be of service? ");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: FaIcon(
                                        FontAwesomeIcons.facebook,
                                        size: 35,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () {
                                        _launchURL("https://facebook.com/");
                                      },
                                    ),
                                    SizedBox(width: 5.0),
                                    IconButton(
                                      color: Colors.white,
                                      icon: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        size: 36,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _launchURL("https://www.instagram.com");
                                      },
                                    ),
                                    SizedBox(width: 5.0),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: FaIcon(
                                          FontAwesomeIcons.tiktok,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _launchURL("https://www.tiktok.com/");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "All rights reserved",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Copyrights © 2021",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  _launchURL(link) async {
    try {
      if (await canLaunch(link)) {
        await launch(link);
      }
    } catch (e) {
      // print(e);
      // print('Could not launch $link');
    }
  }
}
