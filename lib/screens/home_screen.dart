import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hanoimall/data/user_model.dart';
import 'package:hanoimall/router/locations.dart';
import 'package:hanoimall/screens/home/me_page.dart';
import 'package:hanoimall/screens/home/orders_page.dart';
import 'package:hanoimall/screens/home/home_page.dart';
import 'package:hanoimall/screens/home/records_page.dart';
import 'package:hanoimall/states/user_notifier.dart';
import 'package:hanoimall/widgets/expandable_fab.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserModel? userModel = context.read<UserNotifier>().userModel;
    return Scaffold(
      body:(userModel == null)
        ? Container()
        : IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          HomePage(),
          OrdersPage(userKey: userModel.userKey),
          RecordsPage(userKey: userModel.userKey),
          const MePage(),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90,
        children: [
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_INPUT');
            },
            shape: const CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.build_sharp),
          ),
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_RECORD');
            },
            shape: const CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.bolt),
          ),
        ],
      ),

      appBar: AppBar(
        title: Text('SHALOM HOUSE', style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.beamToNamed("/");
              },
              icon: const Icon(CupertinoIcons.nosign)),
        ],),
      bottomNavigationBar: BottomNavigationBar(

          currentIndex: _bottomSelectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.grey), label: '홈',),
            BottomNavigationBarItem(icon: Icon(Icons.build, color: Colors.grey), label: '설비관리'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt, color: Colors.grey,), label: '전기관리'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle, color: Colors.grey), label: 'me'),
          ],
          onTap: (index){
            setState((){
              _bottomSelectedIndex = index;
            });
          }
      ),
    );
  }
}

