import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:workout_routine/domain/routes/routes.dart';

class AppRouteObserver extends RouteObserver<MaterialPageRoute<Widget>> {
  final logger = Logger('AppRouteObserver');

  @override
  Future<void> didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);

    if (previousRoute == null && Routes.allRoutes.contains(route) && Platform.isAndroid) {
      await minimize();
    }
  }

  Future<void> minimize() async {
    try {
      final result = await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      logger.info("App minimized: $result");
    } on PlatformException catch (e) {
      logger.severe("Error minimizing the app (PlatformException): $e");
    } catch (e) {
      logger.severe("Unexpected error minimizing the app: $e");
    }
  }
}
