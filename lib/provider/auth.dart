import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String _email;
  String _token;
  String _userId;
  DateTime _expiryDate;
  /////
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

////////////////////////////////////////////////////////////////////
   static const String firebaseAppUserUrl = 'Copy Past Your own firebase app url';
  String apiKey = 'apiKey';

  Future<void> _authenticate(
      String email, String password, String urlSigmen) async {
    final url =
        '$firebaseAppUserUrl:$urlSigmen?key=$apiKey';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      ///else if [NO Error].....................
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _email = responseData['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      ///to call [Auto LogOut] when we first log in ............
      _autoLogOut();
      notifyListeners();

      /// [*] Storing data after logIn in [haredPref] .... for [Auto log in] .......
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'email': _email,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

      print(responseData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _email = null;
    _expiryDate = null;
    //////////
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  /// [*] Retrive Data from [SharedPref] ...............................[Auto LogIn]....
  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    /// Reintializ all property up there ......... and call [Auto LogOut] function
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _email = extractedUserData['email'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  /// [Auto LogOut] Functionalaty .........
  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    var timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
