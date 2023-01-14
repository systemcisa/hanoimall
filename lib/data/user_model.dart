import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanoimall/constants/data_keys.dart';

class UserModel {
    late String userKey;
  late String phoneNumber;
  late String studentname;
  late String studentnum;
  late DateTime createdDate;
  DocumentReference? reference;

  UserModel(
      {required this.userKey,
        required this.phoneNumber,
        required this.studentname,
        required this.studentnum,
        required this.createdDate,
        this.reference});

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference)
      : phoneNumber = json[DOC_PHONENUMBER],
        studentname = json[DOC_STUDENTNAME],
        studentnum = json[DOC_STUDENTNUM],
        createdDate = json[DOC_CREATEDDATE] == null
            ? DateTime.now().toUtc()
            : (json[DOC_CREATEDDATE] as Timestamp).toDate();

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_PHONENUMBER] = phoneNumber;
    map[DOC_STUDENTNAME] = studentname;
    map[DOC_STUDENTNUM] = studentnum;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }
    static String getstudentname(String uid) {
      String timeInMilli = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      return '${uid}_$timeInMilli';
    }
}