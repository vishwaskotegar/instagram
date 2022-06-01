import 'package:flutter/material.dart';
import 'package:instagram/screens/addPostScreen.dart';
import 'package:instagram/screens/feedScreen.dart';
import 'package:instagram/screens/searchscreen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(
    child: Text("notification"),
  ),
  Center(
    child: Text("account"),
  ),
];