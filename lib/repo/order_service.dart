import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hanoimall/constants/data_keys.dart';
import 'package:hanoimall/data/order_model.dart';
import 'package:hanoimall/utils/logger.dart';

class OrderService {
  static final OrderService _orderService = OrderService._internal();
  factory OrderService() => _orderService;
  OrderService._internal();

  Future createNewOrder(
      OrderModel orderModel, String orderKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> orderDocReference =
        FirebaseFirestore.instance.collection(COL_ORDERS).doc(orderKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ORDERS)
        .doc(orderKey);
    final DocumentSnapshot documentSnapshot = await orderDocReference.get();
    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(orderDocReference, orderModel.toJson());
        transaction.set(userItemDocReference, orderModel.toMinJson());
      });
    }
  }

  Future<OrderModel> getOrder(String orderKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ORDERS).doc(orderKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    OrderModel orderModel = OrderModel.fromSnapshot(documentSnapshot);
    return orderModel;
  }

  Future<List<OrderModel>> getOrders(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ORDERS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_USERKEY, isEqualTo: userKey)
       // .orderBy("createdDate", descending: true)
        .get();

    List<OrderModel> orders = [];

    for (int i = 0; i < snapshots.size; i++) {
      OrderModel orderModel = OrderModel.fromQuerySnapshot(snapshots.docs[i]);
      orders.add(orderModel);
    }
    return orders;
  }

  Future<List<OrderModel>> getUserOrders(String userKey,
      {String? orderKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ORDERS);
    QuerySnapshot<Map<String, dynamic>> snapshots =
    await collectionReference.get();

    List<OrderModel> orders = [];

    for (int i = 0; i < snapshots.size; i++) {
      OrderModel orderModel = OrderModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(orderKey != null && orderKey == orderModel.orderKey))
        orders.add(orderModel);
    }
    return orders;
  }
  // Future<OrderModel> updateOrder(String orderKey) async {
  //   DocumentReference<Map<String, dynamic>> documentReference =
  //   FirebaseFirestore.instance.collection(COL_ORDERS).doc(orderKey);
  //   final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //   await documentReference.update("negotiable":true);
  //
  // }
}