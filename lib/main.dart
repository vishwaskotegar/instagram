import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/providers/userProvider.dart';
import 'package:instagram/responsive/mobileScreenLayout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/webScreenLayout.dart';
import 'package:instagram/screens/loginScreen.dart';
import 'package:instagram/screens/signupScreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDgZIAGxF7KY-uya30_AN1gKYQkNqh-F_A",
            appId: "1:540403678087:web:520abccf00a39cd55b3122",
            messagingSenderId: "540403678087",
            projectId: "instagram-99284",
            storageBucket: "instagram-99284.appspot.com"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: mobileBackgroundColor,
          systemNavigationBarColor: mobileBackgroundColor));
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: const ResponsiveLayout(
          //     webScreenLayout: WebScreenLayout(),
          //     mobileScreenLayout: MobileScreenLayout()),
          home: StreamBuilder(
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
                  return const Center(child: CircularProgressIndicator());
                }

                return const LoginScreen();
              })
          // LoginScreen(),
          ),
    );
  }
}
