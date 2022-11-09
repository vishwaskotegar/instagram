import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/firebase_options.dart';
import 'package:instagram/providers/userProvider.dart';
import 'package:instagram/screens/splash.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
            home: const Splash()));
  }
}
