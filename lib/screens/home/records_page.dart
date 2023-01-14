import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/record_model.dart';
import 'package:hanoimall/repo/record_service.dart';
import 'package:hanoimall/widgets/record_list_widget.dart';
import 'package:shimmer/shimmer.dart';

class RecordsPage extends StatefulWidget {
  final String userKey;
  const RecordsPage({Key? key ,required this.userKey} ) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  bool init = false;
  List<RecordModel> records = [];

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
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery
            .of(context)
            .size;
        final imgSize = size.width / 4;
        return FutureBuilder<List<RecordModel>>(
            future: RecordService().getRecords(widget.userKey),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: (records.isNotEmpty)
                      ? _listView(imgSize)
                      : _shimmerListView(imgSize));
            });
      },
    );
  }

  Future _onRefresh() async {
    records.clear();
    records.addAll(await RecordService().getRecords(widget.userKey));
    setState(() {});
  }

  Widget _listView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
          padding: const EdgeInsets.all(common_padding),
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: common_padding+1,
              thickness: 1,
              color: Colors.grey[300],
              indent: common_padding,
              endIndent: common_padding,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            RecordModel record = records[index];
            return RecordListWidget(record, imgSize: imgSize);
          }, itemCount: records.length,
        ),
    );
  }

  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(common_padding),
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
                const SizedBox(
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
                        const SizedBox(
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
                        const SizedBox(
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