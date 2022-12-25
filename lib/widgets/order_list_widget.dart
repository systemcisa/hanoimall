import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:shalomhouse/constants/common_size.dart';
import 'package:shalomhouse/data/order_model.dart';
import 'package:shalomhouse/router/locations.dart';
import 'package:shalomhouse/utils/logger.dart';
import 'package:intl/intl.dart';

class OrderListWidget extends StatelessWidget {
  final OrderModel order;
  double? imgSize;
  OrderListWidget(this.order, {Key? key, this.imgSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imgSize == null) {
      Size size = MediaQuery.of(context).size;
      imgSize = size.width / 6;
    }

    return InkWell(
      onTap: () {
        BeamState beamState = Beamer.of(context).currentConfiguration!;
        String currentPath = beamState.uri.toString();
        String newPath = (currentPath == '/')
            ? '/$LOCATION_ORDER/${order.orderKey}'
            : '$currentPath/${order.orderKey}';
        logger.d('newPath - $newPath');
        context.beamToNamed(newPath);
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [
            SizedBox(
                height: imgSize,
                width: imgSize,
                child: ExtendedImage.network(
                  order.imageDownloadUrls[0],
                  fit: BoxFit.cover,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                )),
            SizedBox(
              width: common_sm_padding,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      order.detail,
                      maxLines:1,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text("작업의뢰 작성일"),
                    Text(
                      DateFormat('MM-dd kkmm').format(order.createdDate),

                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}