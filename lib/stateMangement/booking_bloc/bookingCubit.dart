import 'package:elive/controllers/apiController.dart';
import 'package:elive/stateMangement/booking_bloc/bookingState.dart';
import 'package:elive/stateMangement/category_bloc/categoryState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitialState());

  Future<void> getBookings() async {
    try {
      // emit(AdsLoadingState());
      final bookings = await ApiController.getBookings();
      emit(BookingLoadedState(bookings: bookings));
    } on Exception {
      emit(BookingErrorState(message: "Could not get featured Items"));
    }
  }
}
