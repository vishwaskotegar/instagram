import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram/model/userModel.dart';
import 'package:instagram/resources/authMethods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();
  NetworkImage? _profilePic;
  UserModel get getUser => _userModel!;
  NetworkImage get getProfilePic => _profilePic!;

  Future<void> refreshUser() async {
    _userModel = await _authMethods.getUserDetails();
    _profilePic = await NetworkImage(_userModel!.photoUrl);
    // _userModel = userModel;
    notifyListeners();
  }
}
