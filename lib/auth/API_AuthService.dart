import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class API_AuthService {
  Future userLogin() async {
    String email = "jugendra@gmail.com";
    String password = "1234";

    var url = 'http://192.236.160.238/api/login';
    var data = {'email': email, 'password': password};
    var response = await http.post(Uri.parse(url), body: json.encode(data[email]));
    var message = jsonDecode(response.body);
    if (kDebugMode) {
      print(message);
    }
  }
}
