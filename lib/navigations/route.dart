import 'package:flutter/material.dart';
import 'package:flutter_nested_route/controls/main.dart';
import 'package:flutter_nested_route/navigations/route_control.dart';

typedef AppRouteSettingsPredicate = bool Function(AppRouteSettings route);

class AppInformationParser extends RouteInformationParser<AppRouteSettings> {
  AppInformationParser();
  @override
  Future<AppRouteSettings> parseRouteInformation(
      RouteInformation routeInformation) async {
    final configuration =
        AppRouteSettings(name: routeInformation.location ?? "");

    return configuration;
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouteSettings configuration) {
    return RouteInformation(location: configuration.name);
  }
}

class AppRouterDelegate extends RouterDelegate<AppRouteSettings>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;
  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  List<AppRouteSettings> _histories = [];
  List<AppRouteSettings> get histories => _histories;

  AppRouteSettings? _currentConfiguration;
  @override
  AppRouteSettings? get currentConfiguration => _currentConfiguration;

  final List<RouteControl> _controls = [
    MainRouteControl(),
  ];

  void updatePath(AppRouteSettings configuration) {
    setNewRoutePath(configuration);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    this._currentConfiguration = configuration;
  }

  bool routeAccessable(String name, bool hasAccess) {
    return (_controls.where((element) =>
        element.access.containsKey(name) &&
        element.access[name] == hasAccess)).isNotEmpty;
  }

  AppRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final pages = getPages();

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (route.didPop(result)) {
          popHistories();
          return true;
        }
        return false;
      },
    );
  }

  @override
  Future<void> setInitialRoutePath(AppRouteSettings configuration) {
    histories.add(configuration);
    notifyListeners();
    return super.setInitialRoutePath(configuration);
  }

  List<Page> getPages() {
    final pages = _histories
        .map((e) {
          final page = getPage(e);
          return page;
        })
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
    if (pages.isEmpty) return [MaterialPage(child: Scaffold())];
    return pages;
  }

  Page? getPage(AppRouteSettings configuration) {
    Page? page;
    try {
      _controls.firstWhere((control) {
        return (page = control.createPage(configuration)) != null;
      });
    } catch (e) {}
    return page ?? notFound();
  }

  Page notFound() => MaterialPage(
          child: Text(
        "404 -  not found",
      ));

  popHistories() {
    _histories.removeLast();
    if (_histories.isNotEmpty) updatePath(_histories.last);
  }

  void pushNamed(String name, {dynamic arguments}) {
    final configuration = AppRouteSettings(name: name, arguments: arguments);
    _histories.add(configuration);

    updatePath(configuration);
  }

  void pushReplacementNamed(String name, {dynamic arguments}) {
    final configuration = AppRouteSettings(name: name, arguments: arguments);
    if (_histories.isEmpty)
      _histories.add(configuration);
    else
      _histories.last = configuration;
    updatePath(configuration);
  }

  void pushNamedAndRemoveUntil(String name, AppRouteSettingsPredicate predicate,
      {dynamic arguments}) {
    for (var i = _histories.length - 1; i >= 0; i--) {
      final configuration = _histories[i];
      if (predicate(configuration)) {
        break;
      }
      histories.remove(configuration);
    }

    final configuration = AppRouteSettings(name: name, arguments: arguments);
    _histories.add(configuration);
    updatePath(configuration);
  }

  void popUntil(AppRouteSettingsPredicate predicate) {
    for (var i = _histories.length - 1; i >= 0; i--) {
      final configuration = _histories[i];
      if (predicate(configuration)) {
        break;
      }

      navigatorKey.currentState?.pop();
    }
  }

  void pop() {
    _histories.removeLast();
    if (_histories.isNotEmpty) updatePath(_histories.last);
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() == true;
  }
}
