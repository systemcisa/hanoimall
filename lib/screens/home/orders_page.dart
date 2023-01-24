import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/repo/order_service.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:hanoimall/widgets/order_list_widget.dart';
import 'package:shimmer/shimmer.dart';

class OrdersPage extends StatefulWidget {
  final String userKey;
  const OrdersPage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool init = false;
  List<OrderModel> orders = [];

  @override
  void initState() {
    if (!init) {
      _onRefresh();
      init = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery
            .of(context)
            .size;
        final imgSize = size.width / 7;
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
        //          child: _listView(imgSize),);

                  child: (orders.isNotEmpty)
                      ? _listView(imgSize)
                      : _shimmerListView(imgSize));

      },
    );
  }

  Future _onRefresh() async {
    orders.clear();
    orders.addAll(await OrderService().getOrders(widget.userKey));
    setState(() {});
  }

  Widget _listView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
          padding: EdgeInsets.all(common_padding),
          separatorBuilder: (context, index) {
            return Divider(
              height: common_padding*2+1,
              thickness: 1,
              color: Colors.grey[300],
              indent: common_padding,
              endIndent: common_padding,
            );
          },
          itemBuilder: ( context, index) {
            OrderModel order = orders[index];
            return OrderListWidget(order, imgSize: imgSize);
          }, itemCount: orders.length,
        ),
    );
  }

  Widget _shimmerListView(double imgSize) {
    logger.d(orders);
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(common_padding),
        separatorBuilder: (context, index) {
          return Divider(
            height: common_padding * 2 + 1,
            thickness: 1,
            color: Colors.grey[200],
            indent: common_sm_padding,
            endIndent: common_sm_padding,
          );
        },
        itemBuilder: (context, index) {
          return SizedBox(
            height: imgSize,
            child: Row(
              children: [
                Container(
                    height: imgSize,
                    width: imgSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    )),
                SizedBox(
                  width: common_sm_padding,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 12,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 14,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 14,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                )),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}