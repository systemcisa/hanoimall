import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/data/user_model.dart';
import 'package:hanoimall/repo/image_storage.dart';
import 'package:hanoimall/repo/order_service.dart';
import 'package:hanoimall/repo/user_service.dart';
import 'package:hanoimall/screens/input/multi_image_select.dart';
import 'package:hanoimall/states/category_notifier.dart';
import 'package:hanoimall/states/select_image_notifier.dart';
import 'package:hanoimall/states/user_notifier.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String _address = 'A동';
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;
  final bool _seuggestPriceSelected = false;

  final _border =
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  final _divider = Divider(
    height: common_padding * 2 + 1,
    thickness: 1,
    color: Colors.grey[450],
    indent: common_padding,
    endIndent: common_padding,
  );

  bool isCreatingItem = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String orderKey = OrderModel.generateItemKey(userKey);
    List<Uint8List> images = context.read<SelectImageNotifier>().images;
    UserNotifier userNotifier = context.read<UserNotifier>();

    if (userNotifier.userModel == null) return;
    List<String> downloadUrls =
        await ImageStorage.uploadImages(images, orderKey);

    final num? price = num.tryParse(_priceController.text);

    OrderModel orderModel = OrderModel(
        orderKey: orderKey,
        userKey: userKey,
        studentname: userNotifier.userModel!.studentname,
        studentnum: userNotifier.userModel!.studentnum,
        imageDownloadUrls: downloadUrls,
        orderdate: _nameController.text,
        title: _address,
        address: _addressController.text,
        isChecked1: _isChecked1,
        isChecked2: _isChecked2,
        isChecked3: _isChecked3,
        isChecked4: _isChecked4,
        isChecked5: _isChecked5,
        isChecked6: _isChecked6,
        category: context.read<CategoryNotifier>().currentCategoryInEng,
        price: price ?? 0,
        negotiable: _seuggestPriceSelected,
        detail: _detailController.text,
        createdDate: DateTime.now().toUtc());
    logger.d('uid - ${FirebaseAuth.instance.currentUser!.uid}');

    await OrderService()
        .createNewOrder(orderModel, orderKey, userNotifier.user!.uid);
    // ignore: use_build_context_synchronously
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
                title: const Text('시설점검 신청'),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('''@최대한 자세히 작성해주세요@
@모든 시설 보수는 오후 1시 이전까지 접수 받습니다@
@모든 시설 보수는 오후 1시 이후에 작업 합니다@'''),
                ),
                _divider,
                MultiImageSelect(),
                _divider,
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: '신청 날짜 MM.DD',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border),
                ),
                _divider,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('위치'),
                    ListTile(
                      title: const Text('A동'),
                      leading: Radio(
                        value: "A동",
                        groupValue: _address,
                        onChanged: (value) {
                          setState(() {
                            _address = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('B동'),
                      leading: Radio(
                        value: 'B동',
                        groupValue: _address,
                        onChanged: (value) {
                          setState(() {
                            _address = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('국생'),
                      leading: Radio(
                        value: '국생',
                        groupValue: _address,
                        onChanged: (value) {
                          setState(() {
                            _address = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                _divider,
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: '호실',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: common_padding),
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border),
                ),
                _divider,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('방'),
                    CheckboxListTile(
                        title: const Text('A방'),
                        value: _isChecked1,
                        onChanged: (value) {
                          setState(() {
                            _isChecked1 = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: const Text('B방'),
                        value: _isChecked2,
                        onChanged: (value) {
                          setState(() {
                            _isChecked2 = value!;
                          });
                        }),
                  ],
                ),
                _divider,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('번'),
                    CheckboxListTile(
                        title: const Text('1'),
                        value: _isChecked3,
                        onChanged: (value) {
                          setState(() {
                            _isChecked3 = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: const Text('2'),
                        value: _isChecked4,
                        onChanged: (value) {
                          setState(() {
                            _isChecked4 = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: const Text('3'),
                        value: _isChecked5,
                        onChanged: (value) {
                          setState(() {
                            _isChecked5 = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: const Text('4'),
                        value: _isChecked6,
                        onChanged: (value) {
                          setState(() {
                            _isChecked6 = value!;
                          });
                        }),
                  ],
                ),
                _divider,
                TextFormField(
                  controller: _detailController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: ''''내용<구체적으로 적어주세요>
    예) 김샬롬 옷장 두 번째 서랍이 안닫혀요''',
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

  void showToast(String value) {
    Fluttertoast.showToast(
        msg: "$value 선택",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
