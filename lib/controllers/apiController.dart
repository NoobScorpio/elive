import 'dart:convert';

import 'package:elive/stateMangement/models/booking.dart';
import 'package:elive/stateMangement/models/bookingList.dart';
import 'package:elive/stateMangement/models/category.dart';
import 'package:elive/stateMangement/models/items.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:elive/stateMangement/models/promo.dart';
import 'package:elive/stateMangement/models/sliderImages.dart';
import 'package:elive/utils/constants.dart';

import 'package:http/http.dart' as http;

class ApiController {
  static Future<Category> getCategory() async {
    var response = await http.get(Uri.parse(baseURL + "/allpackages.php"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        var data = json.decode(response.body);
        Category category = Category.fromJson(data);
        print("GET ${category.records}");
        return category;
      } catch (e) {
        print(e);
        return null;
      }
    } else if (response.statusCode == 400) {
      return null;
    } else if (response.statusCode == 500) {
      return null;
    } else {
      return null;
    }
  }

  static Future<Items> getCategoryItems({cid}) async {
    try {
      var response =
          await http.get(Uri.parse(baseURL + "/allitem.php?id=$cid"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        Items items = Items.fromJson(data);
        print("GET ${items.records}");
        return items;
      } else if (response.statusCode == 400) {
        return null;
      } else if (response.statusCode == 500) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future
  static Future<Promo> getPromos() async {
    try {
      var response = await http.get(Uri.parse(baseURL + "/promo.php"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        Promo items = Promo.fromJson(data);
        print("GET ${items.records}");
        return items;
      } else if (response.statusCode == 400) {
        return null;
      } else if (response.statusCode == 500) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<BookingList> getBookings() async {
    try {
      var response = await http.get(Uri.parse(baseURL + "/listOfbooking.php"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        BookingList items = BookingList.fromJson(data);
        // print("GET ${items.records}");
        return items;
      } else if (response.statusCode == 400) {
        return null;
      } else if (response.statusCode == 500) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> postFeedback({email, feedback}) async {
    try {
      var response = await http.post(Uri.parse(baseURL + "/giveFeedback.php"),
          body: json.encode({"userEmail": "$email", "feedback": "$feedback"}));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE 200");
        var data = json.decode(response.body);
        if (data['message'].toString().contains('Confirmed'))
          return true;
        else
          return false;
      } else if (response.statusCode == 400) {
        print("RESPONSE 400 ${response.body}");
        return false;
      } else if (response.statusCode == 500) {
        print("RESPONSE 500");
        return false;
      } else {
        print("RESPONSE SOMETHING");
        return false;
      }
    } catch (e) {
      print(e);
      print("RESPONSE ERROR");
      return false;
    }
  }

  static Future<bool> postBooking(
      {Booking booking, name, phone, address}) async {
    try {
      var response = await http.post(Uri.parse(baseURL + "/create.php"),
          body: json.encode({
            "userEmail": "${booking.userEmail}",
            "description": "${booking.description}",
            "time": "${booking.time}",
            "firestoreId": "${booking.firestoreId}",
            "date": "${booking.date}",
            "service": "${booking.service}",
            "total": booking.total.toString(),
            "status": "Awaiting Confirmation",
            "token": "${booking.token}",
            "notification": "true",
            "name": name,
            "address": address,
            "phone": phone
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE 200");
        var data = json.decode(response.body);
        if (data['message'].toString().contains('Confirmed'))
          return true;
        else
          return false;
      } else if (response.statusCode == 400) {
        print("RESPONSE 400");
        return false;
      } else if (response.statusCode == 500) {
        print("RESPONSE 500");
        return false;
      } else {
        print("RESPONSE SOMETHING");
        return false;
      }
    } catch (e) {
      print("RESPONSE ERROR");
      print(e);
      return false;
    }
  }

  static Future setUserToken({MyUser user}) async {
    try {
      var response = await http.post(Uri.parse(baseURL + "/insertToken.php"),
          body: json.encode({
            "userId": "${user.uid}",
            "userEmail": "${user.email}",
            "token": "${user.pushToken}"
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE 200 ${response.body}");
        return true;
      } else if (response.statusCode == 400) {
        print("RESPONSE 400 ${response.body}");
        return false;
      } else if (response.statusCode == 500) {
        print("RESPONSE 500 ${response.body}");
        return false;
      } else {
        print("RESPONSE SOMETHING");
        return false;
      }
    } catch (e) {
      print(e);
      print("RESPONSE ERROR");
      return false;
    }
  }

  static Future setBookingStatus({String status, String id}) async {
    try {
      var response = await http.post(Uri.parse(baseURL + "/update.php"),
          body: json.encode({
            "id": "$id",
            "status": "$status",
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("RESPONSE 200 ${response.body}");
        return true;
      } else if (response.statusCode == 400) {
        print("RESPONSE 400 ${response.body}");
        return false;
      } else if (response.statusCode == 500) {
        print("RESPONSE 500 ${response.body}");
        return false;
      } else {
        print("RESPONSE SOMETHING");
        return false;
      }
    } catch (e) {
      print(e);
      print("RESPONSE ERROR");
      return false;
    }
  }

  static Future<SliderImages> getSliderImages() async {
    try {
      var response = await http.get(Uri.parse(baseURL + "/sliderImage.php"));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        SliderImages items = SliderImages.fromJson(data);
        print("GET ${items.records}");
        return items;
      } else if (response.statusCode == 400) {
        return null;
      } else if (response.statusCode == 500) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
