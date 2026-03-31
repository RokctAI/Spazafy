import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

extension NavigationContext on BuildContext {
  void replaceRouteNamed(String routeName) {
    this.router.replaceNamed(routeName);
  }

  void pushRouteNamed(String routeName) {
    this.router.pushNamed(routeName);
  }

  Future<bool> popRoute() async {
    return this.router.maybePop();
  }
}
