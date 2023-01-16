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
      imgSize = size.width / 8;
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
        child: Column(
          children: [
            Text(
              DateFormat('MM-dd kkmm').format(record.createdDate),
              style: TextStyle(
                color: (record.negotiable == true)
                    ? Colors.black12
                    : Colors.black,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('신발A',style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20),),
                    Text(
                      record.address1,
                      maxLines: 1,
                      style: TextStyle(
                        color: (record.negotiable == true)
                            ? Colors.black12
                            : Colors.black,
                      ),
                    ),
                  ],
                )
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NUZZON',style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 20),),
                        Text(
                          record.address5,
                          maxLines: 1,
                          style: TextStyle(
                            color: (record.negotiable == true)
                                ? Colors.black12
                                : Colors.black,
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
