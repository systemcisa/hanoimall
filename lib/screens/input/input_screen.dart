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
  int customcount=1;
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

  final TextEditingController _product1Controller = TextEditingController();
  final TextEditingController _product2Controller = TextEditingController();
  final TextEditingController _product3Controller = TextEditingController();
  final TextEditingController _product4Controller = TextEditingController();
  final TextEditingController _product5Controller = TextEditingController();
  final TextEditingController _count1Controller = TextEditingController();
  final TextEditingController _count2Controller = TextEditingController();
  final TextEditingController _count3Controller = TextEditingController();
  final TextEditingController _count4Controller = TextEditingController();
  final TextEditingController _count5Controller = TextEditingController();
  final TextEditingController _incomeprice1Controller = TextEditingController();
  final TextEditingController _incomeprice2Controller = TextEditingController();
  final TextEditingController _incomeprice3Controller = TextEditingController();
  final TextEditingController _incomeprice4Controller = TextEditingController();
  final TextEditingController _incomeprice5Controller = TextEditingController();
  final TextEditingController _outcomeprice1Controller = TextEditingController();
  final TextEditingController _outcomeprice2Controller = TextEditingController();
  final TextEditingController _outcomeprice3Controller = TextEditingController();
  final TextEditingController _outcomeprice4Controller = TextEditingController();
  final TextEditingController _outcomeprice5Controller = TextEditingController();
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

    final num? count1 = num.tryParse(_count1Controller.text);
    final num? count2 = num.tryParse(_count2Controller.text);
    final num? count3 = num.tryParse(_count3Controller.text);
    final num? count4 = num.tryParse(_count4Controller.text);
    final num? count5 = num.tryParse(_count5Controller.text);
    final num? incomeprice1 = num.tryParse(_incomeprice1Controller.text);
    final num? incomeprice2 = num.tryParse(_incomeprice2Controller.text);
    final num? incomeprice3 = num.tryParse(_incomeprice3Controller.text);
    final num? incomeprice4 = num.tryParse(_incomeprice4Controller.text);
    final num? incomeprice5 = num.tryParse(_incomeprice5Controller.text);
    final num? outcomeprice1 = num.tryParse(_outcomeprice1Controller.text);
    final num? outcomeprice2 = num.tryParse(_outcomeprice2Controller.text);
    final num? outcomeprice3 = num.tryParse(_outcomeprice3Controller.text);
    final num? outcomeprice4 = num.tryParse(_outcomeprice4Controller.text);
    final num? outcomeprice5 = num.tryParse(_outcomeprice5Controller.text);

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
        product1: _product1Controller.text,
        product2: _product2Controller.text,
        product3: _product3Controller.text,
        product4: _product4Controller.text,
        product5: _product5Controller.text,
        count1: count1 ?? 0,
        count2: count2 ?? 0,
        count3: count3 ?? 0,
        count4: count4 ?? 0,
        count5: count5 ?? 0,
        incomeprice1: incomeprice1 ?? 0,
        incomeprice2: incomeprice2 ?? 0,
        incomeprice3: incomeprice3 ?? 0,
        incomeprice4: incomeprice4 ?? 0,
        incomeprice5: incomeprice5 ?? 0,
        outcomeprice1: outcomeprice1 ?? 0,
        outcomeprice2: outcomeprice2 ?? 0,
        outcomeprice3: outcomeprice3 ?? 0,
        outcomeprice4: outcomeprice4 ?? 0,
        outcomeprice5: outcomeprice5 ?? 0,
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
                Text('        품명         수량         매입단가       판매단가'),

                if(customcount>0)Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _product1Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "품명",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _count1Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "수량",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _incomeprice1Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(

                              hintText: "매입단가",
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
                        child: TextFormField(
                          controller: _outcomeprice1Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(

                              hintText: "판매단가",
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
                      TextButton(onPressed: (){

                        customcount=customcount+1;
                        setState(() {});
                      }, child: Text('추가'))
                    ],
                  ),
                ),
                if(customcount>1)Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _product2Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "품명",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _count2Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "수량",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _incomeprice2Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "매입단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _outcomeprice2Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "판매단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      SizedBox(width: 50,)
                    ],
                  ),
                ),
                if(customcount>2)Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _product3Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "품명",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _count3Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "수량",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _incomeprice3Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "매입단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _outcomeprice3Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "판매단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      SizedBox(width: 50,)
                    ],
                  ),
                ),
                if(customcount>3)Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _product4Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "품명",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _count4Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "수량",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _incomeprice4Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "매입단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _outcomeprice4Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "판매단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      SizedBox(width: 50,)
                    ],
                  ),
                ),
                if(customcount>4)Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _product5Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "품명",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _count5Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "수량",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _incomeprice5Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "매입단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _outcomeprice5Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "판매단가",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: common_padding),
                              border: _border,
                              enabledBorder: _border,
                              focusedBorder: _border),
                        ),
                      ),
                      SizedBox(width: 50,)
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
