import 'package:flutter/material.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/resources/authMethods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    _userModel = await _authMethods.getUserDetails();
    // _userModel = userModel;
    notifyListeners();
  }
}
