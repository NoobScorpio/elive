import 'package:elive/screens/checkoutScreen.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/cart_bloc/cartState.dart';
import 'package:elive/stateMangement/models/cart.dart';
import 'package:elive/utils/cartItemCard.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  final cartItems;
  final bool item;
  const CartScreen({Key key, this.cartItems, this.item}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems;
  // List<Widget> cartItemWidgets = [];
  bool isLoading = true;

  int qty = 0, price = 0;
  void initState() {
    super.initState();
    cartItems = widget.cartItems;

    getItems();
  }

  getItems() async {
    cartItems = [];
    cartItems = await BlocProvider.of<CartCubit>(context).getItems();
    // setState(() {
    //   isLoading = true;
    // });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Header(title: 'Cart'),
                    if (widget.item != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    SizedBox(
                      height: 150,
                    ),
                    loader()
                  ],
                ),
              ],
            ),
          )
        : BlocBuilder<CartCubit, CartState>(builder: (context, state) {
            if (state is CartInitialState) {
              return Text(
                "Loading...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              );
            } else if (state is CartLoadingState) {
              return Text(
                "Loading...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              );
            } else if (state is CartLoadedState) {
              if (state.cartItems == null) {
                return Text(
                  "Loading...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                );
              } else {
                List<Widget> cartItemWidgets = [];
                if (state.cartItems == null || state.cartItems.length == 0) {
                  cartItemWidgets = [
                    Header(title: "Cart"),
                    if (widget.item != null)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No items in the cart'),
                    )
                  ];
                } else {
                  // List<Widget> cartItemWidgets = [];
                  qty = 0;
                  Map<String, int> names = {};
                  Map<String, int> prices = {};
                  for (var item in state.cartItems) {
                    qty++;
                    price += int.parse(item.price);
                    if (!names.containsKey(item.pName)) {
                      names[item.pName] = 1;
                      prices[item.pName] = int.parse(item.price);
                    } else {
                      names[item.pName] += 1;
                    }
                  }
                  // print('@ITEMS $names');
                  cartItemWidgets = [
                    Header(title: "Cart"),
                    if (widget.item != null)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Text(
                          "${state.cartItems.length} Items in cart",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ];

                  for (var item in state.cartItems) {
                    cartItemWidgets.add(CartItemCard(
                      name: item.pName,
                      image: item.img,
                      price: int.parse(item.price),
                      qty: item.qty,
                    ));
                  }
                  cartItemWidgets.add(SizedBox(
                    height: 15,
                  ));
                  cartItemWidgets.add(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: ${state.total}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ));
                  cartItemWidgets.add(ElevatedButton(
                      onPressed: () async {
                        bool delete = false;
                        await showDialog(
                            context: context,
                            builder: (context) {
                              bool isCheck = false;
                              return AlertDialog(
                                title: Text("Agreement"),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                          StateSetter setStates) =>
                                      Container(
                                    height: 130,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Please be informed, if order cancelled before taking the service, "
                                          "20% of cancellation charges will be deducted from total cart value at the "
                                          "time for the refund",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                                value: isCheck,
                                                onChanged: (val) =>
                                                    setStates(() {
                                                      isCheck = val;
                                                    })),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Do you agree?",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (isCheck) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => loader());
                                          String description = '';

                                          for (var item in names.keys) {
                                            description +=
                                                "${names[item]}x $item <br>";
                                            cartItemWidgets.add(CartItemCard(
                                              name: item,
                                              price: prices[item],
                                              qty: names[item],
                                            ));
                                          }
                                          print(description);
                                          bool booked = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => BlocProvider(
                                                        create: (context) =>
                                                            CartCubit(),
                                                        child: CheckOutScreen(
                                                            desc: description,
                                                            names: names,
                                                            total: state.total),
                                                      )));
                                          if (booked != null &&
                                              booked == true) {
                                            print("BOOKED NOT NULL");
                                            delete = true;
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                          // Navigator.pop(context);
                                        } else {
                                          showToast(
                                              "Kindly agree to the disclaimer",
                                              Colors.red);
                                        }
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ],
                              );
                            });
                        if (delete) {
                          print("@DELETED");
                          await BlocProvider.of<CartCubit>(context).emptyCart();
                        }
                      },
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )));
                  cartItemWidgets.add(SizedBox(
                    height: 15,
                  ));
                }
                return Scaffold(
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
                          children: cartItemWidgets,
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else if (state is CartErrorState) {
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
          });
  }
}
