import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiredDate;

  String? get token {
    if(_expiredDate != null && _expiredDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
  };


  Future<void> _authenticate(String email, String password, String urlSegment) async {

    final url = Uri.parse('${dotenv.env['API_URL']}:${dotenv.env['PORT']}/api/$urlSegment');

    try {

      final response = await http.post(url,
      headers: requestHeaders,
      body: jsonEncode({
        'email' : email,
        'password' : password
      }));

      final responseData = jsonDecode(response.body);

      _token = responseData['token'];
      _expiredDate = DateTime.now().add(Duration(minutes: 5));

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = jsonEncode({
        'token' : token,
        'expiredDate' : _expiredDate?.toIso8601String()
      });

      prefs.setString('userData', userData);

    } catch (e) {
      throw e;
    }

  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  void logout() async {
    _token = null;
    _expiredDate = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}