import 'dart:typed_data';

import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/authMethods.dart';
// import 'package:instagram/screens/homeScreen.dart';
import 'package:instagram/screens/signupScreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/globalVariables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/textFieldInput.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _usernameController = TextEditingController();
  bool _isLoading = false;

  Uint8List? _image;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().login(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      AdvanceSnackBar(message: "Logged In", isFixed: false, bgColor: blueColor)
          .show(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    } else {
      AdvanceSnackBar(message: res, bgColor: Colors.red, isFixed: false)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            // alignment: Alignment.center,
            width: MediaQuery.of(context).size.width > webScreenSize
                ? 700
                : double.infinity,
            // color: Colors.pink,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            // width: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                      // color: Colors.blue,
                      ),
                  flex: 1,
                ),
                //svg image
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),

                //circle avatar
                // Stack(
                //   children: [
                //     _image != null
                //         ? CircleAvatar(
                //             backgroundImage: MemoryImage(_image!),
                //             radius: 64,
                //           )
                //         : const CircleAvatar(
                //             //  backgroundColor: primaryColor,
                //             backgroundImage: AssetImage(
                //               "assets/images/defaultImage.jpg",
                //             ),

                //             radius: 64,
                //           ),
                //     Positioned(
                //         bottom: -10,
                //         right: -0,
                //         // left: 80,
                //         child: IconButton(
                //           onPressed: () => selectImage(),
                //           icon: Icon(Icons.add_a_photo),
                //         ))
                //   ],
                // ),
                // const SizedBox(
                //   height: 24,
                // ),

                //username
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your Email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),

                //password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),

                //Email
                // TextFieldInput(
                //     textEditingController: _emailController,
                //     hintText: "Enter your Email",
                //     textInputType: TextInputType.emailAddress),
                // const SizedBox(
                //   height: 24,
                // ),

                //bio
                // TextFieldInput(
                //     textEditingController: _bioController,
                //     hintText: "Enter your bio",
                //     textInputType: TextInputType.emailAddress),
                // const SizedBox(
                //   height: 24,
                // ),

                //login buttton
                _isLoading
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: loginUser,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: const Text("Log in"),
                          decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(4)),
                          width: double.infinity,
                        ),
                      ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Dont have an account?"),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupScreen())),
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
