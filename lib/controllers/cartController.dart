import 'dart:convert';
import 'package:elive/stateMangement/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartRepository {
  Future<List<CartItem>> addItem(CartItem cartItem);
  Future<List<CartItem>> getItems();
  Future<List<CartItem>> removeItem(name);
  Future<void> emptyCart();
}

class CartRepositoryImpl extends CartRepository {
  SharedPreferences sharedPreferences;

  CartRepositoryImpl();
  @override
  Future<List<CartItem>> addItem(CartItem cartItem) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      MyCart cart = MyCart();
      var getCart = sharedPreferences.getString('cart');

      if (getCart == null) {
        cart.cartItem = [];
        cart.cartItem.add(cartItem);
        await sharedPreferences.setString('cart', json.encode(cart.toJson()));
      } else {
        cart = MyCart.fromJson(json.decode(getCart));
        if (cart.cartItem != null && cart.cartItem.length != 0) {
          // for (int i = 0; i < cart.cartItem.length; i++) {
          //   if (cartItem.pid == cart.cartItem[i].pid) {
          //     if (cartItem.id == cart.cartItem[i].id) {
          //       cart.cartItem[i].qty += cartItem.qty;
          //       break;
          //     }
          //   }
          // }
          cart.cartItem.add(cartItem);
          await sharedPreferences.setString('cart', json.encode(cart.toJson()));
        } else {
          // cart.cartItem = [];
          if (cart.cartItem == null || cart.cartItem.length == 0) {
            cart.cartItem = [];
            cart.cartItem.add(cartItem);
            await sharedPreferences.setString(
                'cart', json.encode(cart.toJson()));
          } else {
            // for (int i = 0; i < cart.cartItem.length; i++) {
            //   if (cartItem.pid == cart.cartItem[i].pid) {
            //     if (cartItem.id == cart.cartItem[i].id) {
            //       cart.cartItem[i].qty += cartItem.qty;
            //       break;
            //     }
            //   }
            // }
            cart.cartItem.add(cartItem);
            await sharedPreferences.setString(
                'cart', json.encode(cart.toJson()));
          }
        }
      }
      if (cart.cartItem != null) {
        for (int i = 0; i < cart.cartItem.length; i++) {
          if (cartItem == cart.cartItem[i]) {
            print('@CART ADD ITEM ${cart.cartItem[i].name}');
          }
        }
      }

      return cart.cartItem ?? [];
      // }
    } catch (e) {
      print('@CART $e');
      print(e);
      return null;
    }
  }

  @override
  Future<List<CartItem>> getItems() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var getCart = sharedPreferences.getString('cart');

    if (getCart == null) {
      print('EMPTY CART GET ITEMS');
      return [];
    } else {
      MyCart cart = MyCart();
      cart = MyCart.fromJson(json.decode(getCart));
      if (cart.cartItem != null) {
        print('EMPTY CART GET ITEMS ${cart.cartItem.length}');
      } else {
        print('EMPTY CART GET ITEMS 2nd Call');
      }
      return cart.cartItem ?? [];
    }
  }

  @override
  Future<List<CartItem>> removeItem(name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var getCart = sharedPreferences.getString('cart');
    MyCart cart = MyCart();
    cart = MyCart.fromJson(json.decode(getCart));
    for (int i = 0; i < cart.cartItem.length; i++) {
      if (cart.cartItem[i].pName == name) {
        cart.cartItem.removeAt(i);
        // break;
      }
    }
    await sharedPreferences.setString('cart', json.encode(cart.toJson()));
    return cart.cartItem;
  }

  @override
  Future<void> emptyCart() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      MyCart cart = MyCart();
      await sharedPreferences.setString('cart', json.encode(cart.toJson()));
    } catch (e) {
      print("@CART REPO EMPTY : $e");
    }
  }
}
