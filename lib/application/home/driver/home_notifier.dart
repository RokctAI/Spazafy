import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/marker_image_cropper.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:rokctapp/infrastructure/models/data/parcel_order.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'home_state.dart';

final userRepository = driverUserRepository;
final drawRepository = driverDrawRepository;
final orderRepository = driverOrderRepository;
final parcelRepository = driverParcelRepository;
final settingsRepository = driverSettingsRepository;

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
  final ImageCropperMarker image = ImageCropperMarker();

  Future<void> fetchDeliveryZone({bool isFetch = false}) async {
    if (isFetch) {
      final response = await userRepository.getDeliveryZone();
      response.when(
        success: (data) {
          setDeliveryZone(data.data);
        },
        failure: (failure, status) {
          debugPrint('==> get delivery zone failure: $failure');
        },
      );
    } else {
      setDeliveryZone(LocalStorage.getDriver()?.deliveryZone);
    }
  }

  void setDeliveryZone(List<List<double>>? address) {
    if (address?.isNotEmpty ?? false) {
      final Set<Polygon> polygon = HashSet<Polygon>();
      final List<List<double>> addresses = address ?? [];
      List<LatLng> points = [];
      for (final address in addresses) {
        final latLng = LatLng(address[0], address[1]);
        points.add(latLng);
      }
      polygon.add(
        Polygon(
          polygonId: const PolygonId("zone"),
          points: points,
          fillColor: AppStyle.primary.withValues(alpha: 0.01),
          strokeColor: AppStyle.primary,
          geodesic: false,
          strokeWidth: 8,
        ),
      );
      state = state.copyWith(
        polygon: polygon,
        isLoading: false,
        deliveryZone: points,
      );
    }
  }

  void scrolling(bool scroll) {
    state = state.copyWith(isScrolling: scroll);
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
    required Marker market,
  }) async {
    state = state.copyWith(
      polylineCoordinates: [],
      markers: {},
      isLoading: true,
    );
    final response = await drawRepository.getRouting(start: start, end: end);
    response.when(
      success: (data) {
        List<LatLng> list = [];
        List ls = data.features[0].geometry.coordinates;
        for (int i = 0; i < ls.length; i++) {
          list.add(LatLng(ls[i][1], ls[i][0]));
        }
        state = state.copyWith(
          polylineCoordinates: list,
          markers: {market},
          isLoading: false,
        );
      },
      failure: (failure, status) {
        // if(status==400){
        //   AppHelpers.showCheckTopSnackBar(context, TrKeys.moreDistance);
        // }
        state = state.copyWith(
          polylineCoordinates: [],
          markers: {},
          isLoading: false,
        );
      },
    );
  }

  Future<void> getRouting({
    required BuildContext context,
    required LatLng start,
    required bool isOnline,
  }) async {
    state = state.copyWith(isLoading: state.isLoading);
    final response = await userRepository.setCurrentLocation(start);
    response.when(
      success: (data) {},
      failure: (failure, status) {
        if (status != 501) {
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(failure),
          );
        }
      },
    );
  }

  Future<void> goMarket({
    required BuildContext context,
    String? orderId,
    OrderDetailData? order,
    bool setOrder = false,
    required VoidCallback onSuccess,
  }) async {
    state = state.copyWith(isGoUser: false, isLoading: true);
    if (setOrder) {
      final response = await orderRepository.setOrder(orderId ?? "0");
      response.when(
        success: (data) {
          state = state.copyWith(
            isLoading: false,
            orderDetail: order,
            isGoRestaurant: true,
          );
          onSuccess();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(failure),
          );
        },
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        orderDetail: order,
        isGoRestaurant: true,
      );
    }
  }

  Future<void> goMarketParcel({
    required BuildContext context,
    String? parcelId,
    ParcelOrder? parcel,
    bool setOrder = false,
  }) async {
    state = state.copyWith(
      isGoRestaurant: true,
      isGoUser: false,
      isLoading: true,
    );
    if (setOrder) {
      final response = await parcelRepository.setParcel(parcelId ?? "0");
      response.when(
        success: (data) {
          state = state.copyWith(isLoading: false, parcelDetail: parcel);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(failure),
          );
        },
      );
    } else {
      state = state.copyWith(isLoading: false, parcelDetail: parcel);
    }
  }

  Future<void> fetchCurrentOrder(BuildContext context) async {
    fetchDeliveryZone();
    state = state.copyWith(isGoRestaurant: false, isGoUser: false);
    final response = await orderRepository.fetchCurrentOrder();
    response.when(
      success: (data) async {
        if (data.data?.isNotEmpty ?? false) {
          state = state.copyWith(orderDetail: data.data?.first);
          if (data.data?.first.status == "on_a_way") {
            getRoutingAll(
              // ignore: use_build_context_synchronously
              context: context,
              start: LatLng(
                LocalStorage.getAddressSelected()?.location?.latitude ??
                    AppConstants.demoLatitude,
                LocalStorage.getAddressSelected()?.location?.longitude ??
                    AppConstants.demoLongitude,
              ),
              end: LatLng(
                double.parse(data.data?.first.location?.latitude ?? "0"),
                double.parse(data.data?.first.location?.longitude ?? "0"),
              ),
              market: Marker(
                markerId: const MarkerId("User"),
                position: LatLng(
                  double.parse(data.data?.first.location?.latitude ?? "0"),
                  double.parse(data.data?.first.location?.longitude ?? "0"),
                ),
                icon: await image.resizeAndCircle(
                  data.data?.first.user?.img ?? "",
                  100,
                ),
              ),
            );
            state = state.copyWith(
              isGoRestaurant: false,
              isGoUser: true,
              isLoading: false,
            );
          } else {
            state = state.copyWith(isGoRestaurant: true, isGoUser: false);
            getRoutingAll(
              // ignore: use_build_context_synchronously
              context: context,
              start: LatLng(
                LocalStorage.getAddressSelected()?.location?.latitude ??
                    AppConstants.demoLatitude,
                LocalStorage.getAddressSelected()?.location?.longitude ??
                    AppConstants.demoLongitude,
              ),
              end: LatLng(
                double.parse(data.data?.first.shop?.location?.latitude ?? "0"),
                double.parse(data.data?.first.shop?.location?.longitude ?? "0"),
              ),
              market: Marker(
                markerId: const MarkerId("Shop"),
                position: LatLng(
                  double.parse(
                    data.data?.first.shop?.location?.latitude ?? "0",
                  ),
                  double.parse(
                    data.data?.first.shop?.location?.longitude ?? "0",
                  ),
                ),
                icon: await image.resizeAndCircle(
                  data.data?.first.shop?.logoImg ?? "",
                  120,
                ),
              ),
            );
          }
        }
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(failure),
        );
      },
    );
  }

  Future<void> goClient(
    BuildContext context,
    int? orderId, {
    OrderDetailData? order,
  }) async {
    state = state.copyWith(isGoUser: true, isGoRestaurant: false);
    if (order != null) {
      state = state.copyWith(orderDetail: order);
      return;
    }
    final response = await orderRepository.updateOrder(
      orderId ?? 0,
      "on_a_way",
    );
    response.when(
      success: (data) {},
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(failure),
        );
      },
    );
    return;
  }

  Future<void> goClientParcel(
    BuildContext context,
    int? parcelId, {
    ParcelOrder? parcel,
  }) async {
    state = state.copyWith(isGoUser: true, isGoRestaurant: false);
    if (parcel != null) {
      state = state.copyWith(parcelDetail: parcel);
      return;
    }
    final response = await parcelRepository.updateParcel(
      parcelId ?? 0,
      "on_a_way",
    );
    response.when(
      success: (data) {},
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(failure),
        );
      },
    );
    return;
  }

  Future<void> addReview({
    required BuildContext context,
    String? comment,
    double? rating,
    int? orderId,
  }) async {
    orderRepository.addReview(
      orderId ?? 0,
      rating: rating ?? 0,
      comment: comment ?? "",
    );
  }

  Future<void> addReviewParcel({
    required BuildContext context,
    String? comment,
    double? rating,
    int? parcelId,
  }) async {
    parcelRepository.addReviewParcel(
      parcelId ?? 0,
      rating: rating ?? 0,
      comment: comment ?? "",
    );
  }

  Future<void> deliveredFinishParcel({
    required BuildContext context,
    int? parcelId,
  }) async {
    state = state.copyWith(
      isGoUser: false,
      isGoRestaurant: false,
      polylineCoordinates: [],
      endPolylineCoordinates: [],
      markers: {},
    );
    parcelRepository.updateParcel(parcelId ?? 0, "delivered");
  }

  Future<void> deliveredFinish({
    required BuildContext context,
    int? orderId,
  }) async {
    state = state.copyWith(
      isGoUser: false,
      isGoRestaurant: false,
      polylineCoordinates: [],
      endPolylineCoordinates: [],
      markers: {},
    );
    orderRepository.updateOrder(orderId ?? 0, "delivered");
  }

  Future<void> cancelOrder({
    required BuildContext context,
    required int orderId,
    required String note,
  }) async {
    state = state.copyWith(isLoading: true);
    await orderRepository.cancelOrder(orderId, note);
    state = state.copyWith(
      isGoUser: false,
      isGoRestaurant: false,
      polylineCoordinates: [],
      endPolylineCoordinates: [],
      markers: {},
    );
    state = state.copyWith(isLoading: false);
  }

  Future<void> uploadImage({
    required BuildContext context,
    required int? orderId,
    required String path,
  }) async {
    final res = await settingsRepository.uploadImage(path, UploadType.products);
    res.when(
      success: (success) {
        orderRepository.uploadImage(
          orderId.toString(),
          success.imageData?.title,
        );
      },
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> setOnline({required BuildContext context}) async {
    final response = await userRepository.setOnline();
    response.when(
      success: (data) {
        LocalStorage.setOnline(!LocalStorage.getOnline());
      },
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(failure),
        );
      },
    );
  }
}
