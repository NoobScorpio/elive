import 'package:cached_network_image/cached_network_image.dart';
import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/cart_bloc/cartCubit.dart';
import 'package:elive/stateMangement/cart_bloc/cartState.dart';
import 'package:elive/stateMangement/models/cart.dart';
import 'package:elive/stateMangement/models/items.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsScreen extends StatefulWidget {
  final int cid;
  final width;
  final String category, image;
  const ItemsScreen({Key key, this.category, this.cid, this.image, this.width})
      : super(key: key);
  @override
  _ItemsScreenState createState() => _ItemsScreenState(cid, category, image);
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<CartItem> cartItems;
  final int cid;
  bool first = true;
  final String category, image;
  bool loading = true;
  List<Widget> itemWidgets = [];
  _ItemsScreenState(this.cid, this.category, this.image);
  getCartItems() async {
    await BlocProvider.of<CartCubit>(context).getItems();
  }

  getItems() async {
    List<Widget> itemsList = [];
    itemsList.add(SizedBox(
      height: 10,
    ));
    itemsList.add(
      Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, image) => Container(
                width: widget.width - 50,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
              progressIndicatorBuilder: (context, img, progress) => Container(
                width: widget.width - 50,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, img, err) => Container(
                width: widget.width - 50,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(1),
            //   child: Container(
            //     width: widget.width - 50,
            //     height: 150,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       image: DecorationImage(
            //           image: AssetImage('assets/images/hairstyle.jpg'),
            //           fit: BoxFit.cover),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                width: widget.width - 50,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                width: widget.width - 50,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                        fontSize: 42,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    itemsList.add(SizedBox(
      height: 15,
    ));
    Items items = await ApiController.getCategoryItems(cid: cid);
    if (items == null) {
      itemsList.add(Text('No Items in this category'));
    } else {
      for (ItemRecords item in items.records) {
        itemsList.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Price: ' + item.itemPrice,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      CartItem cartItem = CartItem();
                      cartItem.qty = 1;
                      cartItem.name = item.itemName;
                      cartItem.pid = int.parse(item.packageId);
                      cartItem.id = int.parse(item.itemId);
                      cartItem.price = item.itemPrice;
                      cartItem.pName = item.itemName;
                      cartItem.img = widget.image;
                      bool added = await BlocProvider.of<CartCubit>(context)
                          .addItem(cartItem);
                      if (added) {
                        {
                          showToast("Added to cart", Colors.green);
                          // Get the position of the current widget when clicked, and pass in overlayEntry

                        }
                      } else
                        showToast('Could not add to cart', Colors.red);
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Center(
                            child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ))),
                  )
                ],
              ),
            ),
          ),
        ));
      }
    }
    itemWidgets = itemsList;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();
    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                BlocConsumer<CartCubit, CartState>(listener: (context, state) {
              if (state is CartLoadedState) {}
            }, builder: (context, state) {
              if (state is CartInitialState) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is CartLoadingState) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is CartLoadedState) {
                print('LOADED ${state.qty}');
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            '${state.qty}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is CartErrorState) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
          )
        ],
        title: Text(
          category,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? loader()
          : SingleChildScrollView(
              child: Column(
                children: itemWidgets,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await BlocProvider.of<CartCubit>(context).getItems();
          await BlocProvider.of<CartCubit>(context).emptyCart();
          print('CART EMPTY');
        },
      ),
    );
  }
}
