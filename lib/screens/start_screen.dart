import 'package:flutter/material.dart';
import 'package:hanoimall/screens/start/auth_page.dart';
import 'package:hanoimall/screens/start/intro_page.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
          body: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
            IntroPage(),
            AuthPage(),
          ])),
    );
  }
}
