import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookingState extends Equatable {}

class BookingInitialState extends BookingState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BookingLoadingState extends BookingState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BookingLoadedState extends BookingState {
  final BookingList bookings;

  BookingLoadedState({@required this.bookings});

  @override
  // TODO: implement props
  List<Object> get props => [bookings];
}

class BookingErrorState extends BookingState {
  final String message;

  BookingErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
