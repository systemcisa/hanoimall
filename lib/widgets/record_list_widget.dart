import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/record_model.dart';
import 'package:hanoimall/router/locations.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:intl/intl.dart';

class RecordListWidget extends StatelessWidget {
  final RecordModel record;
  double? imgSize;

  RecordListWidget(this.record, {Key? key, this.imgSize}) : super(key: key);

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
            ? '/$LOCATION_RECORD/${record.recordKey}'
            : '$currentPath/${record.recordKey}';
        logger.d('newPath - $newPath');
        context.beamToNamed(newPath);
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [
            // SizedBox(
            //     height: imgSize,
            //     width: imgSize,
            //     child: ExtendedImage.network(
            //       record.imageDownloadUrls[0],
            //       fit: BoxFit.cover,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.circular(12),
            //     )),
            const SizedBox(
              width: common_sm_padding,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                Text(
                  record.detail,
                  maxLines: 1,
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                Text(
                  "작업의뢰 작성일",
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                Text(
                  DateFormat('MM-dd kkmm').format(record.createdDate),
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
              ],
            )),
            const SizedBox(
              width: 50,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '작성자 정보',
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                Text(
                  record.studentname,
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                Text(
                  record.studentnum,
                  style: TextStyle(
                    color: (record.negotiable == true)
                        ? Colors.black12
                        : Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("작업완료",
                    style: TextStyle(
                      color: (record.negotiable == true)
                          ? Colors.redAccent
                          : Colors.transparent,
                    )),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
