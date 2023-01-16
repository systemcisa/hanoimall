import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hanoimall/constants/data_keys.dart';
import 'package:hanoimall/data/record_model.dart';

class RecordService{
  static final RecordService _recordService = RecordService._internal();
  factory RecordService() => _recordService;
  RecordService._internal();

  Future createNewRecord(
      RecordModel recordModel, String recordKey, String userKey) async{
    DocumentReference<Map<String, dynamic>> recordDocReference =
        FirebaseFirestore.instance.collection(COL_RECORDS).doc(recordKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
    .collection(COL_USER_RECORDS)
    .doc(recordKey);
    final DocumentSnapshot documentSnapshot =  await recordDocReference.get();

    if(!documentSnapshot.exists){
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(recordDocReference, recordModel.toJson());
        transaction.set(userItemDocReference, recordModel.toMinJson());
      });
    }
  }
  Future<RecordModel> getRecord(String recordKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_RECORDS).doc(recordKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    RecordModel recordModel = RecordModel.fromSnapshot(documentSnapshot);
    return recordModel;
  }
  Future<List<RecordModel>> getRecords(String userKey) async{
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection(COL_RECORDS);
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionReference
     //   .where(DOC_USERKEY, isEqualTo: userKey)
        .orderBy("createdDate", descending: true)
        .get();

    List<RecordModel> records=[];
    
    for(int i=0; i< snapshot.size; i++){
      RecordModel recordModel = RecordModel.fromQuerySnapshot(snapshot.docs[i]);
      records.add(recordModel);
    }
    return records;
  }
}