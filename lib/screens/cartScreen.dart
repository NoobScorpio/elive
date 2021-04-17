import 'package:elive/utils/cartItemCard.dart';
import 'package:elive/utils/constants.dart';
import 'package:elive/utils/header.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: double.maxFinite,
            //   height: 60,
            //   color: Colors.black,
            // ),
            Header(title: "Cart"),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  "3 Items in cart",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            CartItemCard(),
            CartItemCard(),
            CartItemCard(),
            CartItemCard(),
            CartItemCard(),
            CartItemCard(),
            CartItemCard(),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {}, child: Text('Proceed to Checkout')),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
