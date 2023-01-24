import 'package:beamer/src/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/data/user_model.dart';
import 'package:hanoimall/repo/order_service.dart';
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
    FirebaseFirestore.instance.collection("orders").doc(orderKey).update({
      "delivery": true,
      "completion": false,
    });
  }

  void _goToCompletion(String orderKey, bool negotiable) async {
    FirebaseFirestore.instance.collection("orders").doc(orderKey).update({
      "completion": true,
      "delivery": false,
    });
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
                                Expanded(
                                  child: TextButton(
                                      onPressed: () async {
                                        _goToDelivery(
                                            orderModel.orderKey, true);
                                        context.beamBack();
                                      },
                                      child: const Text('택배보냄')),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextButton(
                                      onPressed: () async {
                                        _goToCompletion(
                                            orderModel.orderKey, true);
                                        context.beamBack();
                                      },
                                      child: const Text('완료')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          _imagesAppBar(orderModel),
                          SliverPadding(
                            padding: const EdgeInsets.all(common_padding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              _divider,
                              Text(orderModel.studentname),
                              SizedBox(
                                height: 15,
                              ),
                              Text('품명    수량     매입단가    매입가     판매단가    판매가'),
                              if (orderModel.count1 != 0)
                                Text(
                                    '${orderModel.product1}     ${orderModel.count1}          ${orderModel.incomeprice1}          ${orderModel.count1 * orderModel.incomeprice1}          ${orderModel.outcomeprice1}            ${orderModel.count1 * orderModel.outcomeprice1}'),
                              if (orderModel.count2 != 0)
                                Text(
                                    '${orderModel.product2}      ${orderModel.count2}         ${orderModel.incomeprice2}          ${orderModel.count2 * orderModel.incomeprice2}           ${orderModel.outcomeprice2}            ${orderModel.count2 * orderModel.outcomeprice2}'),
                              if (orderModel.count3 != 0)
                                Text(
                                    '${orderModel.product3}     ${orderModel.count3}         ${orderModel.incomeprice3}           ${orderModel.count3 * orderModel.incomeprice3}          ${orderModel.outcomeprice3}            ${orderModel.count3 * orderModel.outcomeprice3}'),
                              if (orderModel.count4 != 0)
                                Text(
                                    '${orderModel.product4}     ${orderModel.count4}         ${orderModel.incomeprice4}            ${orderModel.count4 * orderModel.incomeprice4}         ${orderModel.outcomeprice4}            ${orderModel.count4 * orderModel.outcomeprice4}'),
                              if (orderModel.count5 != 0)
                                Text(
                                    '${orderModel.product5}      ${orderModel.count5}         ${orderModel.incomeprice5}            ${orderModel.count5 * orderModel.incomeprice5}         ${orderModel.outcomeprice5}            ${orderModel.count5 * orderModel.outcomeprice5}'),
                              Text(
                                      '                                  ${orderModel.count1 * orderModel.incomeprice1 +
                                         orderModel.count2 * orderModel.incomeprice2 +
                                         orderModel.count3 * orderModel.incomeprice3 +
                                         orderModel.count4 * orderModel.incomeprice4 +
                                         orderModel.count5 * orderModel.incomeprice5},000원'
                                  '            ${orderModel.count1 * orderModel.outcomeprice1 +
                              orderModel.count2 * orderModel.outcomeprice2 +
                              orderModel.count3 * orderModel.outcomeprice3 +
                              orderModel.count4 * orderModel.outcomeprice4 +
                              orderModel.count5 * orderModel.outcomeprice5},000원'),
                              Text(orderModel.phonenum),
                              Text(orderModel.address),

                              // style: const TextStyle(
                              //     color: Colors.black, fontSize: 15)),
                              // _textGap,
                              Row(
                                children: [
                                  Text(
                                      //        ' · ${TimeCalculation.getTimeDiff(orderModel.createdDate)}',
                                      '작업의뢰 작성일 : ${DateFormat('MM-dd KKmm').format(orderModel.createdDate)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      )),
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

  SliverAppBar _imagesAppBar(OrderModel orderModel) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: SizedBox(
          child: SmoothPageIndicator(
              controller: _pageController, // PageController
              count: orderModel.imageDownloadUrls.length,
              effect: const WormEffect(
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
