import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shalomhouse/constants/common_size.dart';
import 'package:shalomhouse/data/order_model.dart';
import 'package:shalomhouse/repo/order_service.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderKey;
  const OrderDetailScreen(this.orderKey, {Key? key}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _dealComplete = false;
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;
  Widget _textGap = SizedBox(
    height: common_padding,
  );
  Widget _divider = Divider(
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderModel>(
        future: OrderService().getOrder(widget.orderKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            OrderModel orderModel = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                _size = MediaQuery.of(context).size;
                _statusBarHeight = MediaQuery.of(context).padding.top;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          _imagesAppBar(orderModel),
                          SliverPadding(
                            padding: EdgeInsets.all(common_padding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  _divider,
                                  Text(
                                    "요청일 : "+orderModel.orderdate,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                    "요청 건물 : "+ orderModel.title+orderModel.address+"호",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  Row(
                                    children: [

                                      Text(
                                //        ' · ${TimeCalculation.getTimeDiff(orderModel.createdDate)}',
                                        '작업의뢰 작성일 : ${DateFormat('MM-dd KKmm').format(orderModel.createdDate)}',
                                        style:
                                        Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 2,
                                    thickness: 2,
                                    color: Colors.grey[200],
                                  ),
                                  _textGap,
                                  Text(
                                    orderModel.detail,
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
                        decoration: BoxDecoration(
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

  SliverAppBar _imagesAppBar(OrderModel orderModel) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: SizedBox(
          child: SmoothPageIndicator(
              controller: _pageController, // PageController
              count: orderModel.imageDownloadUrls.length,
              effect: WormEffect(
                  dotColor: Colors.white24,
                  activeDotColor: Colors.white,
                  radius: 2,
                  dotHeight: 4,
                  dotWidth: 4), // yo// ur preferred effect
              onDotClicked: (index) {}),
        ),
        centerTitle: true,
        background: PageView.builder(
          controller: _pageController,
          allowImplicitScrolling: true,
          itemBuilder: (context, index) {
            return ExtendedImage.network(
              orderModel.imageDownloadUrls[index],
              fit: BoxFit.cover,
              scale: 0.1,
            );
          },
          itemCount: orderModel.imageDownloadUrls.length,
        ),
      ),
    );
  }
}