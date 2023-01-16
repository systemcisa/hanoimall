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
  late num price;
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
    required this.price,
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
    price = json[DOC_PRICE] ?? 0;
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
    map[DOC_PRICE] = price;
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