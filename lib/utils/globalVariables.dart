import 'package:flutter/material.dart';
import 'package:instagram/screens/addPostScreen.dart';
import 'package:instagram/screens/feedScreen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
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