import 'package:elive/stateMangement/models/cart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CartState extends Equatable {}

class CartInitialState extends CartState {
  final List<CartItem> carItems;

  CartInitialState(this.carItems);
  @override
  List<Object> get props => [carItems];
}

class CartLoadingState extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoadedState extends CartState {
  final List<CartItem> cartItems;
  final total;
  final int qty;
  CartLoadedState({this.qty, this.total, @required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class CartItemAddedState extends CartState {
  final List<CartItem> added;
  final total;
  CartItemAddedState({
    this.total,
    @required this.added,
  });

  @override
  List<Object> get props => [added];
}

class CartItemRemoveState extends CartState {
  final List<CartItem> removed;
  final total;
  CartItemRemoveState({this.total, @required this.removed});

  @override
  List<Object> get props => [removed];
}

class GetCartItemState extends CartState {
  final List<CartItem> cartItems;

  GetCartItemState({@required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class CartErrorState extends CartState {
  final String message;

  CartErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
