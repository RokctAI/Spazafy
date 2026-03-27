import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'view_map_page.dart';

// // // // @RoutePage()
class ManagerViewMapPage extends StatelessWidget {
  final VoidCallback onChanged;
  final bool isShopLocation;
  final String? shopId;

  const ManagerViewMapPage(
    this.onChanged, {
    super.key,
    this.isShopLocation = false,
    this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return ViewMapPage(
      onChanged: onChanged,
      isShopLocation: isShopLocation,
      shopId: shopId != null ? int.tryParse(shopId) : null,
    );
  }
}
