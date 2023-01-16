import 'package:beamer/src/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/record_model.dart';
import 'package:intl/intl.dart';
import 'package:hanoimall/repo/record_service.dart';

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
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(common_padding),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              SizedBox(
                                height: 60,
                              ),
                              Text(
                                  DateFormat('MM-dd KKmm')
                                      .format(recordModel.createdDate),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              _textGap,
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '신발A',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        recordModel.address1,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('신발B',style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20)),
                                      Text(
                                        recordModel.address2,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('신발C',style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address3,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('신발D',style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address4,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('NUZZON',style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address5,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('THEOT',style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address6,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('DPH',style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address7,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('NPH',style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address8,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('CPH',style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address9,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('STUDIO W',style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address10,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('TECHNO',style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address11,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('DWP',style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address12,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('APM',style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address13,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('JPH',style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 20)),
                                      Text(
                                        recordModel.address14,
                                        style: TextStyle(
                                          color:
                                              (recordModel.negotiable == true)
                                                  ? Colors.black12
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                color: Colors.grey[200],
                              ),
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
                  ],
                );
              },
            );
          }
          return Container();
        });
  }
}
