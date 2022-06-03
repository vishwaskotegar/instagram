import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/addPostScreen.dart';
import '../screens/feedScreen.dart';
import '../screens/notificationScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/searchscreen.dart';

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
