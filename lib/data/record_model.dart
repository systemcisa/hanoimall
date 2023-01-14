import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanoimall/constants/data_keys.dart';

class RecordModel {
  late String recordKey;
  late String userKey;
  late String studentname;
  late String studentnum;
 // late List<String> imageDownloadUrls;
  late String recorddate;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late bool delivery;
  late bool completion;
  late String detail;
  late String address1;
  late String address2;
  late String address3;
  late String address4;
  late String address5;
  late String address6;
  late String address7;
  late String address8;
  late String address9;
  late String address10;
  late String address11;
  late String address12;
  late String address13;
  late String address14;
  late bool isChecked;
  late DateTime createdDate;

  RecordModel({
    required this.recordKey,
    required this.userKey,
    required this.studentname,
    required this.studentnum,
  //  required this.imageDownloadUrls,
    required this.title,
    required this.recorddate,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.delivery,
    required this.completion,
    required this.detail,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.address4,
    required this.address5,
    required this.address6,
    required this.address7,
    required this.address8,
    required this.address9,
    required this.address10,
    required this.address11,
    required this.address12,
    required this.address13,
    required this.address14,
    required this.isChecked,
    required this.createdDate,
  });

  RecordModel.fromJson(Map<String, dynamic> json, this.recordKey,) {
    userKey = json[DOC_USERKEY] ?? "";
    studentname = json[DOC_STUDENTNAME] ?? "";
    studentnum = json[DOC_STUDENTNUM] ?? "";
     // imageDownloadUrls = json[DOC_IMAGEDOWNLOADURLS] != null
     //     ? json[DOC_IMAGEDOWNLOADURLS].cast<String>()
     //     : [];
    title = json[DOC_TITLE] ?? "";
    recorddate = json[DOC_RECORDDATE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    delivery = json[DOC_DELIVERY] ?? false;
    completion = json[DOC_COMPLETION] ?? false;
    detail = json[DOC_DETAIL] ?? "";
    address1 = json[DOC_ADDRESS1] ?? "";
    address2 = json[DOC_ADDRESS2] ?? "";
    address3 = json[DOC_ADDRESS3] ?? "";
    address4 = json[DOC_ADDRESS4] ?? "";
    address5 = json[DOC_ADDRESS5] ?? "";
    address6 = json[DOC_ADDRESS6] ?? "";
    address7 = json[DOC_ADDRESS7] ?? "";
    address8 = json[DOC_ADDRESS8] ?? "";
    address9 = json[DOC_ADDRESS9] ?? "";
    address10 = json[DOC_ADDRESS10] ?? "";
    address11 = json[DOC_ADDRESS11] ?? "";
    address12 = json[DOC_ADDRESS12] ?? "";
    address13 = json[DOC_ADDRESS13] ?? "";
    address14 = json[DOC_ADDRESS14] ?? "";
    isChecked = json[DOC_ISCHECKED] ?? false;
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }
    RecordModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id);

  RecordModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_STUDENTNAME] = studentname;
    map[DOC_STUDENTNUM] = studentnum;
 //   map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls;
    map[DOC_TITLE] = title;
    map[DOC_RECORDDATE] = recorddate;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_NEGOTIABLE] = delivery;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DETAIL] = detail;
    map[DOC_ADDRESS1] = address1;
    map[DOC_ADDRESS2] = address2;
    map[DOC_ADDRESS3] = address3;
    map[DOC_ADDRESS4] = address4;
    map[DOC_ADDRESS5] = address5;
    map[DOC_ADDRESS6] = address6;
    map[DOC_ADDRESS7] = address7;
    map[DOC_ADDRESS8] = address8;
    map[DOC_ADDRESS9] = address9;
    map[DOC_ADDRESS10] = address10;
    map[DOC_ADDRESS11] = address11;
    map[DOC_ADDRESS12] = address12;
    map[DOC_ADDRESS13] = address13;
    map[DOC_ADDRESS14] = address14;
    map[DOC_ISCHECKED] = isChecked;

    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    var map = <String, dynamic>{};
//    map[DOC_IMAGEDOWNLOADURLS] = imageDownloadUrls.sublist(0, 1);
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