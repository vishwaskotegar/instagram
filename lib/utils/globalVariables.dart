import 'package:flutter/material.dart';
import 'package:instagram/screens/addPostScreen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  Center(
    child: Text("home"),
  ),
  Center(
    child: Text("Search"),
  ),
  AddPostScreen(),
  Center(
    child: Text("notification"),
  ),
  Center(
    child: Text("account"),
  ),
];