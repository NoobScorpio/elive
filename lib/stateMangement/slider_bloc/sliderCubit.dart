import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/category_bloc/categoryState.dart';
import 'package:elive/stateMangement/slider_bloc/sliderState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitialState());

  Future<void> getImages() async {
    try {
      // emit(AdsLoadingState());
      final images = await ApiController.getSliderImages();
      emit(SliderLoadedState(images: images));
    } on Exception {
      emit(SliderErrorState(message: "Could not get featured Items"));
    }
  }
}
