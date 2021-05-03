import 'package:elive/controllers/apiController.dart';
import 'package:elive/screens/payment_screen.dart';
import 'package:elive/stateMangement/booking_bloc/bookingCubit.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCard extends StatelessWidget {
  final id, time, date, price, status, email;

  const BookingCard(
      {Key key,
      this.id,
      this.time,
      this.date,
      this.price,
      this.status,
      this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          "Booking ID: $id",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Date: $date",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Time: $time",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          status ==
                                  'Your Booking is Confirmed! Please Proceed The Payment'
                              ? "Status: Payment pending"
                              : (status == "Waiting For Confirmation"
                                  ? "Status: Payment pending"
                                  : 'Status: $status'),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          "Price",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "AED $price",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // if (status != null && status != 'Payment Done')
              //   Padding(
              //     padding: const EdgeInsets.only(top: 5),
              //     child: InkWell(
              //       onTap: () async {
              //         bool payed = await showDialog(
              //             context: context,
              //             builder: (context) => AlertDialog(
              //                   title: Text("Agreement"),
              //                   content: Container(
              //                     height: 100,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           "Please be informed, if order cancelled before taking the service, "
              //                           "20% of cancellation charges will be deducted from total cart value at the "
              //                           "time for the refund",
              //                           style: TextStyle(color: Colors.red),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "Do you agree?",
              //                           style: TextStyle(
              //                               color: Colors.black,
              //                               fontWeight: FontWeight.w600),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   actions: [
              //                     InkWell(
              //                         onTap: () async {
              //                           Navigator.pop(context);
              //                         },
              //                         child: Text(
              //                           'No',
              //                           style: TextStyle(
              //                               color: Colors.black,
              //                               fontSize: 18,
              //                               fontWeight: FontWeight.w600),
              //                         )),
              //                     SizedBox(
              //                       width: 15,
              //                     ),
              //                     InkWell(
              //                         onTap: () async {},
              //                         child: Text(
              //                           'Yes',
              //                           style: TextStyle(
              //                               color: Colors.black,
              //                               fontSize: 18,
              //                               fontWeight: FontWeight.w600),
              //                         )),
              //                   ],
              //                 ));
              //         if (payed)
              //           await BlocProvider.of<BookingCubit>(context)
              //               .getBookings();
              //       },
              //       child: Container(
              //         height: 30,
              //         width: 75,
              //         decoration: BoxDecoration(
              //           color: Colors.green,
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Center(
              //           child: Text(
              //             "Pay Now",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              if (status != null && status != 'Cancelled')
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                          context: context, builder: (context) => loader());

                      if (status == "Payment Done") {
                        Navigator.pop(context);
                        showToast("Payout not verified", Colors.blue);
                      } else {
                        bool updated = await ApiController.setBookingStatus(
                            status: "Cancelled", id: id);
                        if (updated != null) {
                          showToast("Booking Cancelled", Colors.green);
                          await BlocProvider.of<BookingCubit>(context)
                              .getBookings();
                          Navigator.pop(context);
                        } else {
                          showToast("Could not cancel booking", Colors.green);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
