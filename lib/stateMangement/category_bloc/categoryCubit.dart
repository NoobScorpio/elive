import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/category_bloc/categoryState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState());

  Future<void> getCategory() async {
    try {
      // emit(AdsLoadingState());
      final category = await ApiController.getCategory();
      emit(CategoryLoadedState(category: category));
    } on Exception {
      emit(CategoryErrorState(message: "Could not get featured Items"));
    }
  }
}
