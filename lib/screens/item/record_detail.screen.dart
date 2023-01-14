import 'package:beamer/src/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/data/record_model.dart';
import 'package:hanoimall/repo/order_service.dart';
import 'package:intl/intl.dart';
import 'package:hanoimall/repo/record_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecordDetailScreen extends StatefulWidget {
  final String recordKey;

  const RecordDetailScreen(this.recordKey, {Key? key}) : super(key: key);

  @override
  _RecordDetailScreenState createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  final bool _dealComplete = false;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;
  final Widget _textGap = const SizedBox(
    height: common_padding,
  );
  final Widget _divider = Divider(
    height: common_padding * 2 + 2,
    thickness: 2,
    color: Colors.grey[200],
  );

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null || _statusBarHeight == null) return;
      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToDelivery(String orderKey, bool negotiable) async {
    FirebaseFirestore.instance.collection("records").doc(orderKey).update({
      "delivery": true,
    });
  }
  void _goToCompletion(String orderKey, bool negotiable) async {
    FirebaseFirestore.instance.collection("records").doc(orderKey).update({
      "completion": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecordModel>(
        future: RecordService().getRecord(widget.recordKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            RecordModel recordModel = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                _size = MediaQuery.of(context).size;
                _statusBarHeight = MediaQuery.of(context).padding.top;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      bottomNavigationBar: SafeArea(
                        top: false,
                        bottom: true,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey[300]!))),
                          child: Padding(
                            padding: const EdgeInsets.all(common_sm_padding),
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      _goToDelivery(recordModel.recordKey, true);
                                      context.beamBack();
                                    },
                                    child: const Text('택배보냄')),
                                TextButton(
                                    onPressed: () async {
                                      _goToCompletion(recordModel.recordKey, true);
                                      context.beamBack();
                                    },
                                    child: const Text('완료')),
                              ],
                            ),

                          ),
                        ),
                      ),
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                   //       _imagesAppBar(recordModel),
                          SliverPadding(
                            padding: const EdgeInsets.all(common_padding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  SizedBox(height: 60,),
                              Text(DateFormat('MM-dd KKmm').format(recordModel.createdDate),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              _textGap,
                              Text(
                                recordModel.detail,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              _textGap,
                              // Text(
                              //   '조회 33',
                              //   style: Theme.of(context).textTheme.caption,
                              // ),
                              // _textGap,

                              // MaterialButton(
                              //     padding: EdgeInsets.zero,
                              //     onPressed: () {},
                              //     child: Align(
                              //         alignment: Alignment.centerLeft,
                              //         child: Text(
                              //           '이 게시글 신고하기',
                              //         ))),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                            ])),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Container(
                        height: kToolbarHeight + _statusBarHeight!,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.transparent
                            ])),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          shadowColor: Colors.transparent,
                          backgroundColor: isAppbarCollapsed
                              ? Colors.white
                              : Colors.transparent,
                          foregroundColor:
                              isAppbarCollapsed ? Colors.black87 : Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        });
  }

  // SliverAppBar _imagesAppBar(RecordModel recordModel) {
  //   return SliverAppBar(
  //     expandedHeight: _size!.width,
  //     pinned: true,
  //     flexibleSpace: FlexibleSpaceBar(
  //       title: SizedBox(
  //         child: SmoothPageIndicator(
  //             controller: _pageController, // PageController
  //             count: recordModel.imageDownloadUrls.length,
  //             effect: const WormEffect(
  //                 dotColor: Colors.white24,
  //                 activeDotColor: Colors.white,
  //                 radius: 2,
  //                 dotHeight: 4,
  //                 dotWidth: 4), // yo// ur preferred effect
  //             onDotClicked: (index) {}),
  //       ),
  //       centerTitle: true,
  //       background: PageView.builder(
  //         controller: _pageController,
  //         allowImplicitScrolling: true,
  //         itemBuilder: (context, index) {
  //           return ExtendedImage.network(
  //             recordModel.imageDownloadUrls[index],
  //             fit: BoxFit.cover,
  //             scale: 0.1,
  //           );
  //         },
  //         itemCount: recordModel.imageDownloadUrls.length,
  //       ),
  //     ),
  //   );
  // }
}
