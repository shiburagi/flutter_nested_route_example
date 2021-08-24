import 'package:flutter/material.dart';
import 'package:flutter_nested_route/navigations/route_control.dart';
import 'package:flutter_nested_route/screens/main.dart';
import 'package:flutter_nested_route/utils/route_path.dart';

class MainRouteControl extends RouteControl {
  @override
  Map<String, bool?> get access => _access;
  Map<String, bool?> _access = {};

  @override
  Page? createPage(AppRouteSettings configuration) {
    if ([RoutePath.home, RoutePath.profile, RoutePath.settings]
        .contains(configuration.name)) return MaterialPage(child: MainScreen());
  }
}
