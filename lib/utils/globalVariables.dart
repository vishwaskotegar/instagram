import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/addPostScreen.dart';
import 'package:instagram/screens/feedScreen.dart';
import 'package:instagram/screens/notificationScreen.dart';
import 'package:instagram/screens/profileScreen.dart';
import 'package:instagram/screens/searchscreen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
