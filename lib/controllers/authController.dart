import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Authenticate {
  final fbLogin = FacebookLogin();
  Future signInFB() async {
    final FacebookLoginResult result =
        await fbLogin.logIn(permissions: [FacebookPermission.email]);
    print("@FB LOGIN $result");
    final String token = result.accessToken.token;
    final response = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final profile = jsonDecode(response.body);
    print(profile);
    return profile;
  }
}
