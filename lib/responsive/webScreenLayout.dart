import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/globalVariables.dart';

import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/images/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () {
                onPageChanged(0);
              },
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                onPageChanged(1);
              },
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                onPageChanged(2);
              },
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                onPageChanged(3);
              },
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                onPageChanged(4);
              },
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              )),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}
