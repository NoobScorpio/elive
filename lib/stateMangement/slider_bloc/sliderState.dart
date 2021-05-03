import 'package:elive/stateMangement/models/sliderImages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SliderState extends Equatable {}

class SliderInitialState extends SliderState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SliderLoadingState extends SliderState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SliderLoadedState extends SliderState {
  final SliderImages images;

  SliderLoadedState({@required this.images});

  @override
  // TODO: implement props
  List<Object> get props => [images];
}

class SliderErrorState extends SliderState {
  final String message;

  SliderErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
