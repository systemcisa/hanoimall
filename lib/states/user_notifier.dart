import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hanoimall/constants/shared_pref_keys.dart';
import 'package:hanoimall/data/user_model.dart';
import 'package:hanoimall/repo/user_service.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier() {
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await _setNewUser(user);
      notifyListeners();
    });
  }

  Future _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studentname = prefs.getString(SHARED_STUDENTNAME) ?? "";
      String studentnum = prefs.getString(SHARED_STUDENTNUN) ?? "";
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;
      UserModel userModel = UserModel(
          userKey: "",
          phoneNumber: phoneNumber,
          studentname: studentname,
          studentnum: studentnum,
          createdDate: DateTime.now().toUtc());
      await UserService().createNewUser(userModel.toJson(), userKey);

      _userModel = await UserService().getUserModel(userKey);
      logger.d(_userModel!.toJson().toString());
    }
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
}
