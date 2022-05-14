import 'dart:typed_data';

import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/authMethods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/textFieldInput.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webScreenLayout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUp(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      AdvanceSnackBar(message: res, bgColor: Colors.red, isFixed: false)
          .show(context);
    }
    else{
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout())
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
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
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                          radius: 64,
                        )
                      : const CircleAvatar(
                          //  backgroundColor: primaryColor,
                          backgroundImage: AssetImage(
                            "assets/images/defaultImage.jpg",
                          ),

                          radius: 64,
                        ),
                  Positioned(
                      bottom: -10,
                      right: -0,
                      // left: 80,
                      child: IconButton(
                        onPressed: () => selectImage(),
                        icon: Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),

              //username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Username",
                textInputType: TextInputType.text,
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
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your Email",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),

              //bio
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),

              //login buttton
              InkWell(
                onTap: () => signUpUser(),
                child: _isLoading ? const CircularProgressIndicator() :
                Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: const Text("sign up"),
                  decoration: BoxDecoration(
                      color: blueColor, borderRadius: BorderRadius.circular(4)),
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ));
  }
}
