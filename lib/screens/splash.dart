import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/responsive/decision.dart';

import '../utils/colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Decision(),
      )),
    );
  }
  // StreamBuilder(
  //             stream: FirebaseAuth.instance.authStateChanges(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.active) {
  //                 if (snapshot.hasData) {
  //                   return const ResponsiveLayout(
  //                       webScreenLayout: WebScreenLayout(),
  //                       mobileScreenLayout: MobileScreenLayout());
  //                 } else if (snapshot.hasError) {
  //                   return Center(child: Text('${snapshot.error}'));
  //                 }
  //               }
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               }

  //               return const LoginScreen();
  //             })),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: "Splash",
            child: SvgPicture.asset(
              'assets/images/MemeBucket.svg',
              color: primaryColor,
              height: 64,
            ),
          ),
        ),
      ),
    );
  }
}
