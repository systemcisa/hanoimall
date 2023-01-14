import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hanoimall/router/locations.dart';
import 'package:hanoimall/screens/splash_screen.dart';
import 'package:hanoimall/screens/start/auth_page.dart';
import 'package:hanoimall/screens/start_screen.dart';
import 'package:hanoimall/states/user_notifier.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:provider/provider.dart';


final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: [
            ...HomeLocation().pathBlueprints,
            ...InputLocation().pathBlueprints,
            ...ItemLocation().pathBlueprints,
          ],
          check: (context, location) {
            return context.watch<UserNotifier>().user != null;
          },
          showPage: BeamPage(child: StartScreen()))
    ],
    locationBuilder: BeamerLocationBuilder(
        beamLocations: [HomeLocation(), InputLocation(), ItemLocation()]));

void main() async {
  logger.d('My first log by logger!!');
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<Object>(
        future:  _initialization,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      // print('error occur while loading.');
      return const Text(
        'Error occur',
        textDirection: TextDirection.ltr,
      );
    } else if (snapshot.connectionState == ConnectionState.done) {
      return const TomatoApp();
    } else {
      return const SplashScreen();
    }
  }
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserNotifier>(
      create: (BuildContext context) {
        return UserNotifier();
      },
      child: MaterialApp.router(
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'DoHyeon',
            hintColor: Colors.grey[350],
            textTheme: const TextTheme(button: TextStyle(color: Colors.white)),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.white,
                    minimumSize: const Size(10, 48))),
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                titleTextStyle: TextStyle(
                    color: Colors.black87, fontSize: 20, fontFamily: 'DoHyeon'),
                actionsIconTheme: IconThemeData(color: Colors.black87))),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
