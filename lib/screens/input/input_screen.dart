import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/repo/image_storage.dart';
import 'package:hanoimall/repo/order_service.dart';
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
  num _phonenum = 010;
  bool _isChecked = false;
  bool _isDelivery = false;
  bool _isCompletion = false;

  final bool _seuggestPriceSelected = false;

  final _border = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent));

  final _divider = Divider(
    height: common_padding * 2 + 1,
    thickness: 1,
    color: Colors.grey[450],
    indent: common_padding,
    endIndent: common_padding,
  );

  bool isCreatingItem = false;

  final TextEditingController _price1Controller = TextEditingController();
  final TextEditingController _price2Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumController =
  TextEditingController(text: '010');
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

    final num? price1 = num.tryParse(_price1Controller.text);
    final num? price2 = num.tryParse(_price2Controller.text);

    OrderModel orderModel = OrderModel(
        orderKey: orderKey,
        userKey: userKey,
        studentname: _nameController.text,
        studentnum: userNotifier.userModel!.studentnum,
        imageDownloadUrls: downloadUrls,
        phonenum: _phonenumController.text,
        address: _addressController.text,
        isChecked: _isChecked,
        delivery: _isDelivery,
        completion: _isCompletion,
        category: context.read<CategoryNotifier>().currentCategoryInEng,
        price1: price1 ?? 0,
        price2: price2 ?? 0,
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
                title: const Text('주문내역 등록'),
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
                MultiImageSelect(),
                _divider,
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: common_padding),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _price1Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              icon: Icon(Icons.attach_money),
                              hintText: "구입",
                              // prefixIcon: ImageIcon(
                              //   ExtendedAssetImageProvider('assets/imgs/won.png'),
                              //   color: Colors.grey[350],
                              // ),
                              // prefixIconConstraints: BoxConstraints(maxWidth: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                          child: Text(
                            ",000원",
                            style: TextStyle(color: Colors.grey[350], fontSize: 16),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _price2Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              icon: Icon(Icons.attach_money),
                              hintText: "판매",
                              // prefixIcon: ImageIcon(
                              //   ExtendedAssetImageProvider('assets/imgs/won.png'),
                              //   color: Colors.grey[350],
                              // ),
                              // prefixIconConstraints: BoxConstraints(maxWidth: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                          child: Text(
                            ",000원",
                            style: TextStyle(color: Colors.grey[350], fontSize: 16),
                          )),
                    ],
                  ),
                ),
                //       _divider,
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: TextFormField(
                    controller: _phonenumController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskedInputFormatter("000 0000 0000")
                    ],
                    decoration: InputDecoration(icon: Icon(Icons.phone),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: common_padding),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border),
                  ),
                ),
                //        _divider,
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: TextFormField(maxLines: 2,
                    controller: _addressController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.home),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: common_padding),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border),
                  ),
                ),
                //        _divider,
                TextFormField(
                  controller: _detailController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: '사입 내용',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: common_padding),
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
