import 'package:elive/controllers/apiController.dart';
import 'package:elive/controllers/cartController.dart';
import 'package:elive/controllers/notificationController.dart';
import 'package:elive/screens/itemsScreen.dart';
import 'package:elive/screens/profileScreen.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryCubit.dart';
import 'package:elive/stateMangement/category_bloc/categoryState.dart';
import 'package:elive/stateMangement/user_bloc/userLogInCubit.dart';
import 'package:elive/stateMangement/user_bloc/userState.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setUser());
    List<String> images = [
      'assets/images/saloon.jpg',
      'assets/images/saloon.jpg',
      'assets/images/saloon.jpg',
    ];
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
                    "assets/images/bg.png",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Saloon",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: Swiper(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                elevation: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/hairstyle.jpg',
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                ),
                              );
                            },
                            itemCount: 3,
                            viewportFraction: 0.65,
                            scale: 0.80,
                          ),
                        ),
                      ),
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
                        height: 150,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Elive Beauty Spot',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                'Saloon near Burj Khalifa, Centaurys Road',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Contact: 96686947583',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
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
}
