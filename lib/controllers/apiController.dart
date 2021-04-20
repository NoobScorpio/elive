import 'dart:convert';

import 'package:elive/stateMangement/models/category.dart';
import 'package:elive/stateMangement/models/items.dart';
import 'package:elive/utils/constants.dart';
import 'package:flutter/material.dart';

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
}
