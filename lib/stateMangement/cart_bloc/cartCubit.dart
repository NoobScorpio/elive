import 'package:elive/controllers/cartController.dart';
import 'package:elive/stateMangement/models/cart.dart';
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
      List<CartItem> added = await cartRepository.addItem(cartItem);
      if (added == null || added.length == 0) {
        return false;
      } else {
        sp = await SharedPreferences.getInstance();

        if (added.length > 0) {
          for (CartItem cartItem in added) {
            sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
          }
          total = sub;
        }
        print('@EMITING ${added.length}');
        emit(CartLoadedState(
          cartItems: added,
          total: total,
        ));
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
      List<CartItem> removed = await cartRepository.removeItem(name);
      sp = await SharedPreferences.getInstance();

      if (removed.length > 0) {
        for (CartItem cartItem in removed) {
          sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
        }
        total = sub;
      }
      emit(CartLoadedState(
        cartItems: removed,
        total: total,
      ));
      return removed == null ? false : true;
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
      return false;
    }
  }

  Future<List<CartItem>> getItems() async {
    try {
      dynamic sub = 0.0, total = 0.0;
      List<CartItem> cartItems = await cartRepository.getItems();
      sp = await SharedPreferences.getInstance();

      if (cartItems.length > 0) {
        for (CartItem cartItem in cartItems) {
          sub += (int.parse(cartItem.price) ?? 0.0) * (cartItem.qty ?? 0);
        }
        total = sub;
      }
      emit(CartLoadedState(cartItems: cartItems, total: total));
      return cartItems;
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
      return [];
    }
  }

  Future<void> emptyCart() async {
    try {
      dynamic total = 0.0;
      await cartRepository.emptyCart();

      emit(CartLoadedState(cartItems: [], total: total));
    } on Exception {
      emit(CartErrorState(message: "Could not add item"));
    }
  }
}
