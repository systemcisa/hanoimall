import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = [
    "http://www.swu.ac.kr/ImageFileView?imgPath=banner&imgName=805_1.jpg&imgGubun=F",
    "http://www.swu.ac.kr/ImageFileView?imgPath=banner&imgName=740_1.jpg&imgGubun=F",
    "http://www.swu.ac.kr/ImageFileView?imgPath=banner&imgName=721_1.jpg&imgGubun=F"
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExtendedImage.asset("assets/imgs/home_page.png"),
        ],
      )),
    );
  }
}
