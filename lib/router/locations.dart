import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:hanoimall/screens/home_screen.dart';
import 'package:hanoimall/screens/input/category_input_screen.dart';
import 'package:hanoimall/screens/input/input_screen.dart';
import 'package:hanoimall/screens/input/record_screen.dart';
import 'package:hanoimall/screens/item/order_detail.screen.dart';
import 'package:hanoimall/screens/item/record_detail.screen.dart';
import 'package:hanoimall/states/category_notifier.dart';
import 'package:hanoimall/states/select_image_notifier.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:provider/provider.dart';

const LOCATION_HOME = 'home';
const LOCATION_INPUT = 'input';
const LOCATION_ORDER = 'order';
const LOCATION_ORDER_ID = 'order_id';
const LOCATION_RECORD = 'record';
const LOCATION_RECORD_ID = 'record_id';
const LOCATION_CATEGORY_INPUT = 'category_input';
const LOCATION_CATEGORY_RECORD = 'category_record';
const LOCATION_CATEGORY_RECORD1 = 'category_record1';
const LOCATION_CATEGORY_RECORD2 = 'category_record2';
const LOCATION_CATEGORY_RECORD3 = 'category_record3';
const LOCATION_CATEGORY_RECORD4 = 'category_record4';
const LOCATION_CATEGORY_RECORD5 = 'category_record5';
const LOCATION_CATEGORY_RECORD6 = 'category_record6';
const LOCATION_CATEGORY_RECORD7 = 'category_record7';
const LOCATION_CATEGORY_RECORD8 = 'category_record8';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: HomeScreen(), key: ValueKey(LOCATION_HOME))];
  }

  @override
  List get pathBlueprints => ['/'];
}

class InputLocation extends BeamLocation {
  @override
  Widget builder(BuildContext context, Widget navigator) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: categoryNotifier),
          ChangeNotifierProvider(create: (context) => SelectImageNotifier())
        ],
        child: ChangeNotifierProvider.value(
            value: categoryNotifier, child: super.builder(context, navigator)));
  }

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathBlueprintSegments.contains(LOCATION_INPUT))
        BeamPage(key: ValueKey(LOCATION_INPUT), child: InputScreen()),
      if (state.pathBlueprintSegments.contains(LOCATION_RECORD))
        BeamPage(key: ValueKey(LOCATION_RECORD), child: RecordScreen()),
      if (state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD1))
        BeamPage(
            key: ValueKey(LOCATION_CATEGORY_RECORD1),
            child: CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD3))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD3),
      //       child:CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD4))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD4),
      //       child:CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD5))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD5),
      //       child:CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD6))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD6),
      //       child:CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD7))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD7),
      //       child:CategoryInputScreen()),
      // if(state.pathBlueprintSegments.contains(LOCATION_CATEGORY_RECORD8))
      //   BeamPage(
      //       key: ValueKey(LOCATION_CATEGORY_RECORD8),
      //       child:CategoryInputScreen()),
    ];
  }

  @override
  // TODO: implement pathBlueprints
  List get pathBlueprints => [
        '/$LOCATION_INPUT',
        '/$LOCATION_INPUT/$LOCATION_CATEGORY_INPUT',
        '/$LOCATION_RECORD',
        '/$LOCATION_RECORD/$LOCATION_CATEGORY_RECORD1',
        '/$LOCATION_RECORD/$LOCATION_CATEGORY_RECORD2'
      ];
}

class ItemLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    logger.d('path - ${state.uriBlueprint}\n${state.uri}');
    return [
      ...HomeLocation().buildPages(context, state),
      if (state.pathParameters.containsKey(LOCATION_ORDER_ID))
        BeamPage(
            key: ValueKey(LOCATION_ORDER_ID),
            child: OrderDetailScreen(
                state.pathParameters[LOCATION_ORDER_ID] ?? "")),
      if (state.pathParameters.containsKey(LOCATION_RECORD_ID))
        BeamPage(
            key: ValueKey(LOCATION_RECORD_ID),
            child: RecordDetailScreen(
                state.pathParameters[LOCATION_RECORD_ID] ?? "")),
    ];
  }

  @override
  List get pathBlueprints => [
        '/$LOCATION_ORDER/:$LOCATION_ORDER_ID',
        '/$LOCATION_RECORD/:$LOCATION_RECORD_ID',
      ];
}
