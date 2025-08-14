import 'package:flutter/material.dart';

class RouteObserverProvider extends InheritedWidget {
  final RouteObserver<ModalRoute> routeObserver;

  const RouteObserverProvider({
    Key? key,
    required this.routeObserver,
    required Widget child,
  }) : super(key: key, child: child);

  static RouteObserverProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteObserverProvider>()!;
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) {
    return routeObserver != oldWidget.routeObserver;
  }
}