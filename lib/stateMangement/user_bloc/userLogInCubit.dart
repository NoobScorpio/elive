import 'dart:io';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/user_bloc/userState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elive/controllers/authController.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState(MyUser()));

  Future<bool> update(MyUser user) async {
    try {
      emit(UserLoadingState());
      if (user != null) {
        emit(UserLoadedState(user: user));
        return true;
      } else
        return false;
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
      return null;
    }
  }

  Future loginUser(MyUser user) async {
    try {
      emit(UserLoadingState());

      if (user == null) {
        emit(UserLoadedState(user: null));
      } else {
        emit(UserLoadedState(user: user));
      }
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
    }
  }

  logOut() {
    try {
      emit(UserLoadingState());
      emit(UserLoadedState(user: null));
    } on Exception {
      emit(UserErrorState(message: "Could not get user"));
    }
  }
}
