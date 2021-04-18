import 'package:equatable/equatable.dart';
import 'package:elive/stateMangement/models/myUser.dart';

abstract class UserState extends Equatable {}

class UserInitialState extends UserState {
  final MyUser user;
  UserInitialState(this.user);
  @override
  List<Object> get props => [];
}

class UserLoadingState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserLoadedState extends UserState {
  final MyUser user;

  UserLoadedState({this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
