import 'package:flutter/material.dart';
import 'package:flutter_nested_route/navigations/route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppInformationParser(),
    );
  }
}
