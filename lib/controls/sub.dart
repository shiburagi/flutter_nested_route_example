import 'package:flutter/material.dart';
import 'package:flutter_nested_route/navigations/route_control.dart';
import 'package:flutter_nested_route/screens/home.dart';
import 'package:flutter_nested_route/screens/profile.dart';
import 'package:flutter_nested_route/screens/settings.dart';
import 'package:flutter_nested_route/utils/route_path.dart';

class SubRouteControl extends RouteControl {
  @override
  Map<String, bool?> get access => _access;
  Map<String, bool?> _access = {};

  @override
  Page? createPage(AppRouteSettings configuration) {
    if (configuration.name?.startsWith(RoutePath.profile) == true)
      return MaterialPage(child: ProfileScreen());
    if (configuration.name?.startsWith(RoutePath.settings) == true)
      return MaterialPage(child: SettingsScreen());
    if (configuration.name == RoutePath.home)
      return MaterialPage(child: HomeScreen());

    return MaterialPage(
      child: Scaffold(
        body: Center(child: Text("404")),
      ),
    );
  }
}
