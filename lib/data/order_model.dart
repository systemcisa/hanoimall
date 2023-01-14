import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanoimall/constants/data_keys.dart';

class OrderModel {
  late String orderKey;
  late String userKey;
  late String studentname;
  late String studentnum;
  late List<String> imageDownloadUrls;
  late String orderdate;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late String detail;
  late String address;
  late bool isChecked1;
  late bool isChecked2;
  late bool isChecked3;
  late bool isChecked4;
  late bool isChecked5;
  late bool isChecked6;
  late DateTime createdDate;
  DocumentReference? reference;

  OrderModel({
    required this.orderKey,
    required this.userKey,
    required this.studentname,
    required this.studentnum,
    required this.imageDownloadUrls,
    required this.orderdate,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.address,
    required this.isChecked1,
    required this.isChecked2,
    required this.isChecked3,
    required this.isChecked4,
    required this.isChecked5,
    required this.isChecked6,
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
    orderdate = json[DOC_ORDERDATE] ?? "";
    title = json[DOC_TITLE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? "";
    address = json[DOC_ADDRESS1] ?? "";
    isChecked1 = json[DOC_ISCHECKED] ?? false;

    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  OrderModel.fromAlgoliaObject(Map<String, dynamic> json, this.orderKey) {
    userKey = json[DOC_USERKEY] ?? "";
    studentname = json[DOC_STUDENTNAME] ?? "";
    studentnum = json[DOC_STUDENTNUM] ?? "";
    imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
        ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
        : [];
    orderdate = json[DOC_ORDERDATE] ?? "";
    title = json[DOC_TITLE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? "";
    address = json[DOC_ADDRESS1] ?? "";
    isChecked1 = json[DOC_ISCHECKED] ?? false;

    createdDate = DateTime.now().toUtc();
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
    map[DOC_ORDERDATE] = orderdate;
    map[DOC_TITLE] = title;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DETAIL] = detail;
    map[DOC_ADDRESS1] = address;

    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    var map = <String, dynamic>{};
    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
    map[DOC_TITLE] = title;
    map[DOC_PRICE] = price;
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