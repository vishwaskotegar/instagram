import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';

import '../screens/loginScreen.dart';
import 'mobileScreenLayout.dart';
import 'webScreenLayout.dart';

class Decision extends StatelessWidget {
  const Decision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const LoginScreen();
        });
  }
}
