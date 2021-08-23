import 'package:flutter/material.dart';
import 'package:flutter_nested_route/controls/sub.dart';
import 'package:flutter_nested_route/navigations/route.dart';
import 'package:flutter_nested_route/navigations/route_listener.dart';
import 'package:flutter_nested_route/utils/route_path.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainScreen> {
  final List<String> values = [
    RoutePath.home,
    RoutePath.profile,
    RoutePath.settings,
  ];
  @override
  Widget build(BuildContext context) {
    final routerDelegate =
        Router.of(context).routerDelegate as AppRouterDelegate;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: values
            .indexOf(
                routerDelegate.currentConfiguration?.name ?? RoutePath.home)
            .clamp(0, values.length),
        onTap: (value) {
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
      body: RouteListener(controls: [
        SubRouteControl(),
      ]),
    );
  }
}
