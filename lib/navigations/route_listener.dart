import 'package:flutter/material.dart';
import 'package:flutter_nested_route/navigations/route.dart';
import 'package:flutter_nested_route/navigations/route_control.dart';
import 'package:provider/provider.dart';

typedef RouteChanged = void Function(AppRouteSettings? configuration);

class RouteListener extends StatelessWidget {
  const RouteListener({Key? key, required this.controls, this.onChanged})
      : super(key: key);

  final List<RouteControl> controls;
  final RouteChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = Router.of(context).routerDelegate as AppRouterDelegate;
    return ChangeNotifierProvider<AppRouterDelegate?>.value(
      value: value,
      child: Consumer<AppRouterDelegate?>(builder: (context, delegate, child) {
        final configuration = delegate?.currentConfiguration;
        onChanged?.call(configuration);
        final page = controls
            .map((element) =>
                element.createPage(configuration ?? AppRouteSettings(name: "")))
            .firstWhere((element) => element != null, orElse: () => null);
        return Navigator(
          pages: [if (page != null) page],
          onPopPage: (route, result) {
            return route.didPop(result);
          },
        );
      }),
    );
  }
}
