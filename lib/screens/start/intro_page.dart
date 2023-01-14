import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/states/user_notifier.dart';
import 'package:hanoimall/utils/logger.dart';
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
                    Text('shalom house',
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Theme.of(context).colorScheme.primary)),
                    SizedBox(
                        height: size.height/1.5,
                        child: ExtendedImage.asset('assets/imgs/SAM_0161.jpeg')),
                    const Text('서울여자대학교 샬롬하우스 기숙사입니다'),
                    const Text('기숙사 광고 및 시설관리를 위한 앱입니다~'),
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
                          '         기숙사 앱 시작하기         ',
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
