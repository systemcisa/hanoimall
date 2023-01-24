import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanoimall/constants/data_keys.dart';

class OrderModel {
  late String orderKey;
  late String userKey;
  late String studentname;
  late String studentnum;
  late List<String> imageDownloadUrls;
  late String phonenum;
  late String category;
  late String product1;
  late String product2;
  late String product3;
  late String product4;
  late String product5;
  late num count1;
  late num count2;
  late num count3;
  late num count4;
  late num count5;
  late num incomeprice1;
  late num incomeprice2;
  late num incomeprice3;
  late num incomeprice4;
  late num incomeprice5;
  late num outcomeprice1;
  late num outcomeprice2;
  late num outcomeprice3;
  late num outcomeprice4;
  late num outcomeprice5;
  late bool negotiable;
  late bool delivery;
  late bool completion;
  late String detail;
  late String address;
  late bool isChecked;
  late DateTime createdDate;
  DocumentReference? reference;

  OrderModel({
    required this.orderKey,
    required this.userKey,
    required this.studentname,
    required this.studentnum,
    required this.imageDownloadUrls,
    required this.phonenum,
    required this.category,
    required this.product1,
    required this.product2,
    required this.product3,
    required this.product4,
    required this.product5,
    required this.count1,
    required this.count2,
    required this.count3,
    required this.count4,
    required this.count5,
    required this.incomeprice1,
    required this.incomeprice2,
    required this.incomeprice3,
    required this.incomeprice4,
    required this.incomeprice5,
    required this.outcomeprice1,
    required this.outcomeprice2,
    required this.outcomeprice3,
    required this.outcomeprice4,
    required this.outcomeprice5,
    required this.negotiable,
    required this.delivery,
    required this.completion,
    required this.detail,
    required this.address,
    required this.isChecked,
    required this.createdDate,
    this.reference
  });

  OrderModel.fromJson(Map<String, dynamic> json, this.orderKey, this.reference) {
    userKey = json[DOC_USERKEY] ?? "";
    studentname = json[DOC_STUDENTNAME] ?? "";
    studentnum = json[DOC_STUDENTNUM] ?? "";
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    phonenum = json[DOC_PHONENUM] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    product1 = json[DOC_PRODUCT1] ?? "";
    product2 = json[DOC_PRODUCT2] ?? "";
    product3 = json[DOC_PRODUCT3] ?? "";
    product4 = json[DOC_PRODUCT4] ?? "";
    product5 = json[DOC_PRODUCT5] ?? "";
    count1 = json[DOC_COUNT1] ?? 0;
    count2 = json[DOC_COUNT2] ?? 0;
    count3 = json[DOC_COUNT3] ?? 0;
    count4 = json[DOC_COUNT4] ?? 0;
    count5 = json[DOC_COUNT5] ?? 0;
    incomeprice1 = json[DOC_INCOMEPRICE1] ?? 0;
    incomeprice2 = json[DOC_INCOMEPRICE2] ?? 0;
    incomeprice3 = json[DOC_INCOMEPRICE3] ?? 0;
    incomeprice4 = json[DOC_INCOMEPRICE4] ?? 0;
    incomeprice5 = json[DOC_INCOMEPRICE5] ?? 0;
    outcomeprice1 = json[DOC_OUTCOMEPRICE1] ?? 0;
    outcomeprice2 = json[DOC_OUTCOMEPRICE2] ?? 0;
    outcomeprice3 = json[DOC_OUTCOMEPRICE3] ?? 0;
    outcomeprice4 = json[DOC_OUTCOMEPRICE4] ?? 0;
    outcomeprice5 = json[DOC_OUTCOMEPRICE5] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    delivery = json[DOC_DELIVERY] ?? false;
    completion = json[DOC_COMPLETION] ?? false;
    detail = json[DOC_DETAIL] ?? "";
    address = json[DOC_ADDRESS1] ?? "";
    isChecked = json[DOC_ISCHECKED] ?? false;
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  OrderModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_STUDENTNAME] = studentname;
    map[DOC_STUDENTNUM] = studentnum;
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_PHONENUM] = phonenum;
    map[DOC_CATEGORY] = category;
    map[DOC_PRODUCT1] = product1;
    map[DOC_PRODUCT2] = product2;
    map[DOC_PRODUCT3] = product3;
    map[DOC_PRODUCT4] = product4;
    map[DOC_PRODUCT5] = product5;
    map[DOC_COUNT1] = count1;
    map[DOC_COUNT2] = count2;
    map[DOC_COUNT3] = count3;
    map[DOC_COUNT4] = count4;
    map[DOC_COUNT5] = count5;
    map[DOC_INCOMEPRICE1] = incomeprice1;
    map[DOC_INCOMEPRICE2] = incomeprice2;
    map[DOC_INCOMEPRICE3] = incomeprice3;
    map[DOC_INCOMEPRICE4] = incomeprice4;
    map[DOC_INCOMEPRICE5] = incomeprice5;
    map[DOC_OUTCOMEPRICE1] = outcomeprice1;
    map[DOC_OUTCOMEPRICE2] = outcomeprice2;
    map[DOC_OUTCOMEPRICE3] = outcomeprice3;
    map[DOC_OUTCOMEPRICE4] = outcomeprice4;
    map[DOC_OUTCOMEPRICE5] = outcomeprice5;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DELIVERY] = delivery;
    map[DOC_COMPLETION] = completion;
    map[DOC_DETAIL] = detail;
    map[DOC_ADDRESS1] = address;

    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    var map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_PHONENUM] = phonenum;
    map[DOC_INCOMEPRICE1] = incomeprice1;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeInMilli = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    return '${uid}_$timeInMilli';
  }
}