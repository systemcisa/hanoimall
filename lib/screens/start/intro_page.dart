import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 //   logger.d('current user state: ${context.read<UserNotifier>().userState}');
    return LayoutBuilder(
      builder: (BuildContext , BoxConstraints ) {
        Size size = MediaQuery.of(context).size;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: common_padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('somimall',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Theme.of(context).colorScheme.primary)),
                    SizedBox(
                        height: size.height/1.5,
                        child: ExtendedImage.asset('assets/imgs/somimalllogo.png')),
                    const Text('somimall 우리 아들 처럼 열심히 잘 키워보자'),
                    const Text('2023년도 우리 화이팅^^'),
                    const SizedBox(
                      height: 18,
                    ),
                    TextButton(
                      onPressed: () async {
                        context.read<PageController>().animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);

                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor
                      ),
                      child: Text(
                          '         somimall 앱 시작하기         ',
                          style: Theme.of(context).textTheme.button ),
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }
}
