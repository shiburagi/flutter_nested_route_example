import 'package:flutter/material.dart';
import 'package:flutter_nested_route/controls/sub.dart';
import 'package:flutter_nested_route/navigations/route.dart';
import 'package:flutter_nested_route/navigations/route_listener.dart';
import 'package:flutter_nested_route/utils/route_path.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Senarai laluan yg ada di "main screen"
  final List<String> values = [
    RoutePath.home,
    RoutePath.profile,
    RoutePath.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final routerDelegate =
        Router.of(context).routerDelegate as AppRouterDelegate;

    // ambil nilai "currentPath" dari "currentConfiguration"
    final currentPath =
        routerDelegate.currentConfiguration?.name ?? RoutePath.home;

    // cari index dari "values"
    final currentIndex = values.indexOf(currentPath);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        // untuk navigasi bila BottomNavigationBarItem ditekan
        onTap: (value) {
          // untuk menukar laluan pada pelayar
          routerDelegate.pushReplacementNamed(values[value]);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
      // disini gunakan "RouteListener" dan berikan "SubRouteControl()" di parameter "controls"
      body: RouteListener(controls: [
        SubRouteControl(),
      ]),
    );
  }
}
