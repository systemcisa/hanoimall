import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/record_model.dart';
import 'package:hanoimall/repo/image_storage.dart';
import 'package:hanoimall/repo/record_service.dart';
import 'package:hanoimall/states/category_notifier.dart';
import 'package:hanoimall/states/select_image_notifier.dart';
import 'package:hanoimall/states/user_notifier.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  String _address = 'A동';
  bool _isChecked = false;
  bool _seuggestPriceSelected = false;
  bool isCreatingItem = false;
  bool _isDelivery = false;
  bool _isCompletion = false;



  var _border =
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  var _divider = Divider(
    height: common_padding * 2 + 1,
    thickness: 1,
    color: Colors.grey[450],
    indent: common_padding,
    endIndent: common_padding,
  );

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _addressController1 = TextEditingController();
  TextEditingController _addressController2 = TextEditingController();
  TextEditingController _addressController3 = TextEditingController();
  TextEditingController _addressController4 = TextEditingController();
  TextEditingController _addressController5 = TextEditingController();
  TextEditingController _addressController6 = TextEditingController();
  TextEditingController _addressController7 = TextEditingController();
  TextEditingController _addressController8 = TextEditingController();
  TextEditingController _addressController9 = TextEditingController();
  TextEditingController _addressController10 = TextEditingController();
  TextEditingController _addressController11 = TextEditingController();
  TextEditingController _addressController12 = TextEditingController();
  TextEditingController _addressController13 = TextEditingController();
  TextEditingController _addressController14 = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    isCreatingItem = true;
    setState(() {});
    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String recordKey = RecordModel.generateItemKey(userKey);
    List<Uint8List> images = context.read<SelectImageNotifier>().images;
    UserNotifier userNotifier = context.read<UserNotifier>();

    if (userNotifier.userModel == null) return;
    List<String> downloadUrls =
        await ImageStorage.uploadImages(images, recordKey);

    final num? price = num.tryParse(_priceController.text);

    RecordModel recordModel = RecordModel(
        recordKey: recordKey,
        userKey: userKey,
        studentname: userNotifier.userModel!.studentname,
        studentnum: userNotifier.userModel!.studentnum,
    //    imageDownloadUrls: downloadUrls,
        recorddate: _nameController.text,
        title: _address,
        address1: _addressController1.text,
        address2: _addressController2.text,
        address3: _addressController3.text,
        address4: _addressController4.text,
        address5: _addressController5.text,
        address6: _addressController6.text,
        address7: _addressController7.text,
        address8: _addressController8.text,
        address9: _addressController9.text,
        address10: _addressController10.text,
        address11: _addressController11.text,
        address12: _addressController12.text,
        address13: _addressController13.text,
        address14: _addressController14.text,
        isChecked: _isChecked,
        category: context.read<CategoryNotifier>().currentCategoryInEng,
        price: price ?? 0,
        negotiable: _seuggestPriceSelected,
        detail: _detailController.text,
        createdDate: DateTime.now().toUtc());
    logger.d('upload finished - ${downloadUrls.toString()}');

    await RecordService()
        .createNewRecord(recordModel, recordKey, userNotifier.user!.uid);
    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        return IgnorePointer(
            ignoring: isCreatingItem,
            child: Scaffold(
              appBar: AppBar(
                bottom: PreferredSize(
                    preferredSize: Size(_size.width, 2),
                    child: isCreatingItem
                        ? const LinearProgressIndicator(
                            minHeight: 2,
                          )
                        : Container()),
                leading: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black87,
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor),
                  child: Text(
                    '뒤로',
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.foregroundColor),
                  ),
                  onPressed: () {
                    context.beamBack();
                  },
                ),
                title: const Text('동대문 사입'),
                actions: [
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.black87,
                          backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor),
                      onPressed: attemptCreateItem,
                      child: Text(
                        '완료',
                        style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor),
                      )),
                ],
              ),
              body: ListView(children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('신발A',style: TextStyle(color: Colors.redAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController1,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('신발B',style: TextStyle(color: Colors.orangeAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController2,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('신발C',style: TextStyle(color: Colors.purpleAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController3,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('신발D',style: TextStyle(color: Colors.greenAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController4,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('NUZZON',style: TextStyle(color: Colors.blueAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController5,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('THEOT',style: TextStyle(color: Colors.redAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController6,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('DHP',style: TextStyle(color: Colors.orangeAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController7,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('NPH',style: TextStyle(color: Colors.purpleAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController8,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('CPH',style: TextStyle(color: Colors.greenAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController9,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('STUDIO W',style: TextStyle(color: Colors.blueAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController10,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('TECHNO',style: TextStyle(color: Colors.redAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController11,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('DWP',style: TextStyle(color: Colors.blueAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController12,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('APM',style: TextStyle(color: Colors.black, fontSize: 15),),
                          TextFormField(
                            controller: _addressController13,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('JWP',style: TextStyle(color: Colors.orangeAccent, fontSize: 15),),
                          TextFormField(
                            controller: _addressController14,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: '주소+사입비',
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: common_padding),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _divider,
                TextFormField(
                  controller: _detailController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: '사입 내용',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border),
                ),
              ]),
            ));
      },
    );
  }
}
