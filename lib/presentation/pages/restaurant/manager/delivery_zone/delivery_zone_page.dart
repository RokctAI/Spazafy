import 'package:rokctapp/app_constants.dart';

import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/buttons/manager/pop_button.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/application/restaurant/manager/delivery_zone/delivery_zone_provider.dart'
    as manager_delivery;

import 'package:rokctapp/application/restaurant/manager/delivery_zone/delivery_zone_provider.dart'
    as manager_delivery;

@RoutePage()
class ManagerDeliveryZonePage extends ConsumerStatefulWidget {
  const ManagerDeliveryZonePage({super.key});

  @override
  ConsumerState<ManagerDeliveryZonePage> createState() =>
      _ManagerDeliveryZonePageState();
}

class _ManagerDeliveryZonePageState
    extends ConsumerState<ManagerDeliveryZonePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(manager_delivery.deliveryZoneProvider.notifier)
          .fetchDeliveryZone(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(manager_delivery.deliveryZoneProvider);
          final event = ref.read(
            manager_delivery.deliveryZoneProvider.notifier,
          );
          return Stack(
            children: [
              state.isLoading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppStyle.white,
                    )
                  : GoogleMap(
                      tiltGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      polygons: state.polygon,
                      onTap: event.addTappedPoint,
                      initialCameraPosition: CameraPosition(
                        bearing: 0,
                        target: LatLng(
                          state.polygon.isNotEmpty
                              ? state.polygon.first.points.first.latitude
                              : help.AppHelpers.getInitialLatitude() ??
                                    AppConstants.demoLatitude,
                          state.polygon.isNotEmpty
                              ? state.polygon.first.points.first.longitude
                              : help.AppHelpers.getInitialLongitude() ??
                                    AppConstants.demoLongitude,
                        ),
                        tilt: 0,
                        zoom: 11,
                      ),
                    ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                bottom: 20.r,
                left: 15.r,
                right: 15.r,
                child: Row(
                  children: [
                    const PopButton(
                      heroTag: AppConstants.heroTagAddOrderButton,
                    ),
                    8.horizontalSpace,
                    if (state.tappedPoints.length > 3)
                      Expanded(
                        child: CustomButton(
                          title: help.AppHelpers.getTranslation(TrKeys.save),
                          isLoading: state.isSaving,
                          onPressed: () => event.updateDeliveryZone(
                            updateSuccess: context.maybePop,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
