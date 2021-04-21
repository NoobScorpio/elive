import 'dart:convert';

import 'package:elive/controllers/cartController.dart';
import 'package:elive/stateMangement/models/cart.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cartState.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;
  SharedPreferences sp;

  CartCubit({this.cartRepository}) : super(CartInitialState([]));

  Future<bool> addItem(CartItem cartItem) async {
    try {
      dynamic sub = 0.0, total = 0.0;
      int qty = 0;
      List<CartItem> added = await cartRepository.addItem(cartItem);
      if (added == null || added.length == 0) {
        return false;
      } else {
        sp = await SharedPreferences.getInstance();

        if (added.length > 0) {
          for (CartItem cartItem in added) {
            sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
            qty += cartItem.qty;
          }
          total = sub;
        }
        print('@EMITING ${added.length}');
        emit(CartLoadedState(cartItems: added, total: total, qty: qty));
        return true;
      }
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
      return false;
    }
  }

  Future<bool> removeItem(String name) async {
    try {
      dynamic sub = 0.0, total = 0.0;
      int qty = 0;
      List<CartItem> removed = await cartRepository.removeItem(name);
      sp = await SharedPreferences.getInstance();

      if (removed.length > 0) {
        for (CartItem cartItem in removed) {
          sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
          qty += cartItem.qty;
        }
        total = sub;
      }
      emit(CartLoadedState(cartItems: removed, total: total, qty: qty));
      return removed == null ? false : true;
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
      return false;
    }
  }

  Future<List<CartItem>> getItems() async {
    try {
      dynamic sub = 0.0, total = 0.0;
      int qty = 0;
      List<CartItem> cartItems = await cartRepository.getItems();
      sp = await SharedPreferences.getInstance();

      if (cartItems.length > 0) {
        for (CartItem cartItem in cartItems) {
          sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
          qty += cartItem.qty;
        }
        total = sub;
      }
      emit(CartLoadedState(cartItems: cartItems, total: total, qty: qty));
      return cartItems;
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
      return [];
    }
  }

  Future<void> emptyCart() async {
    try {
      MyCart myCart = MyCart();
      await init();
      await preferences.setString("cart", json.encode(myCart.toJson()));
      emit(CartLoadedState(cartItems: [], total: 0.0, qty: 0));
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
    }
  }
}
