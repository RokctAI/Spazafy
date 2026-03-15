import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_route/auto_route.dart';

import 'package:venderfoodyman/domain/interface/customer/banners.dart';
import 'package:venderfoodyman/domain/interface/customer/categories.dart';
import 'package:venderfoodyman/domain/interface/customer/shops.dart';
import 'package:venderfoodyman/domain/interface/customer/brands.dart';
import 'package:venderfoodyman/domain/interface/customer/products.dart';
import 'package:venderfoodyman/domain/interface/customer/draw.dart';
import 'package:venderfoodyman/domain/interface/customer/orders.dart';
import 'package:venderfoodyman/domain/interface/customer/parcel.dart';
import 'package:venderfoodyman/domain/interface/customer/settings.dart';
import 'package:venderfoodyman/domain/interface/customer/user.dart';

import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/address_information.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/address_old_data.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/filter_model.dart';

import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
import 'package:venderfoodyman/infrastructure/services/utils/marker_image_cropper.dart';
import 'package:venderfoodyman/customer/app_constants.dart';
import 'package:venderfoodyman/presentation/routes/customer/app_router.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';

import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final CategoriesFacade _categoriesRepository;
  final BannersFacade _bannersRepository;
  final ShopsFacade _shopsRepository;
  final ProductsFacade _productsRepository;
  final BrandsFacade _brandsRepository;
  final DrawFacade _drawRepository;
  final OrdersFacade _ordersRepository;
  final ParcelFacade _parcelRepository;
  final SettingsFacade _settingsRepository;

  final ImageCropperForMarker _markerImageCropper = ImageCropperForMarker();

  // Cache for preloaded category shops
  final Map<String, List<ShopData>> _preloadedCategoryShops = {};
  final Map<String, int> _categoryTotalShops = {};

  bool _isNavigatingToShop = false;

  HomeNotifier(
    this._categoriesRepository,
    this._bannersRepository,
    this._shopsRepository,
    this._productsRepository,
    this._brandsRepository,
    this._drawRepository,
    this._ordersRepository,
    this._parcelRepository,
    this._settingsRepository,
  ) : super(const HomeState());

  int categoryIndex = 1;
  int shopIndex = 1;
  int newShopIndex = 1;
  int marketIndex = 1;
  int storyIndex = 1;
  int bannerIndex = 1;
  int shopRefreshIndex = 1;
  int filterShopIndex = 1;
  int marketRefreshIndex = 1;
  int discountProductsIndex = 1;

  // --- Customer Methods ---

  void setAddress([AddressNewModel? data]) async {
    AddressData? addressData = LocalStorage.getAddressSelected();
    state = state.copyWith(
      addressData: data ??
          AddressNewModel(
            title: addressData?.title ?? "",
            address: AddressInformation(address: addressData?.address ?? ""),
            location: [
              addressData?.location?.latitude,
              addressData?.location?.longitude,
            ],
          ),
    );
  }

  Future<void> preloadAllCategoryShops() async {
    for (final category in state.categories) {
      if (category.id != null) {
        _preloadShopsForCategory(category.id!);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  Future<void> _preloadShopsForCategory(String categoryId) async {
    if (_preloadedCategoryShops.containsKey(categoryId)) return;
    try {
      final connected = await AppConnectivity.connectivity();
      if (!connected) return;
      final response = await _shopsRepository.getShopFilter(categoryId: categoryId, page: 1);
      response.when(
        success: (data) {
          final shopsList = data.data ?? [];
          _preloadedCategoryShops[categoryId] = shopsList;
          _categoryTotalShops[categoryId] = data.meta?.total ?? 0;
        },
        failure: (_, __) => _preloadedCategoryShops[categoryId] = [],
      );
    } catch (e) {
      debugPrint('Error preloading shops for category $categoryId: $e');
    }
  }

  void setSelectCategory(int index, BuildContext context) async {
    if (_isNavigatingToShop) return;
    if (state.selectIndexCategory == index) {
      state = state.copyWith(
        selectIndexCategory: -1,
        isSelectCategoryLoading: 0,
        selectIndexSubCategory: -1,
        filterShops: [],
        filterMarket: [],
      );
    } else {
      final String? categoryId = index >= 0 && index < state.categories.length ? state.categories[index].id : null;
      final bool hasPreloadedShops = categoryId != null && _preloadedCategoryShops.containsKey(categoryId);

      if (hasPreloadedShops && _preloadedCategoryShops[categoryId]!.length == 1) {
        _isNavigatingToShop = true;
        state = state.copyWith(
          selectIndexCategory: index,
          isSelectCategoryLoading: 1,
          filterShops: _preloadedCategoryShops[categoryId]!,
        );
        final shop = _preloadedCategoryShops[categoryId]!.first;
        context.router.push(ShopRoute(shopId: shop.id.toString())).then((_) => _isNavigatingToShop = false);
        return;
      }

      state = state.copyWith(
        selectIndexCategory: index,
        selectIndexSubCategory: -1,
        isSelectCategoryLoading: index,
        filterShops: hasPreloadedShops ? _preloadedCategoryShops[categoryId]! : [],
      );

      if (index != -1 && categoryId != null) {
        final response = await _shopsRepository.getShopFilter(categoryId: categoryId, page: 1);
        response.when(
          success: (data) {
            final shopsList = data.data ?? [];
            _preloadedCategoryShops[categoryId] = shopsList;
            _categoryTotalShops[categoryId] = data.meta?.total ?? 0;
            if (!_isNavigatingToShop) {
              state = state.copyWith(filterShops: shopsList, isSelectCategoryLoading: 1, totalShops: data.meta?.total ?? 0);
              if (shopsList.length == 1) {
                final shop = shopsList.first;
                _isNavigatingToShop = true;
                context.router.push(ShopRoute(shopId: shop.id.toString())).then((_) => _isNavigatingToShop = false);
              }
            }
          },
          failure: (failure, status) {
            state = state.copyWith(isSelectCategoryLoading: 1);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      }
    }
  }

  Future<void> fetchCategories(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isCategoryLoading: true);
      final response = await _categoriesRepository.getAllCategories(page: 1);
      response.when(
        success: (data) async {
          state = state.copyWith(isCategoryLoading: false, categories: data.data ?? []);
          preloadAllCategoryShops();
        },
        failure: (failure, status) {
          state = state.copyWith(isCategoryLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  void scrolling(bool scroll) => state = state.copyWith(isScrolling: scroll);

  // --- Driver Methods (Unified) ---

  Future<void> fetchDeliveryZone({bool isFetch = false}) async {
    if (isFetch) {
      final userRepo = GetIt.instance.get<UserFacade>();
      final response = await userRepo.getDeliveryZone();
      response.when(
        success: (data) => setDeliveryZone(data.data?.first.address),
        failure: (failure, status) => debugPrint('==> get delivery zone failure: $failure'),
      );
    } else {
      setDeliveryZone(LocalStorage.getUser()?.deliveryZone);
    }
  }

  void setDeliveryZone(List<List<double>>? address) {
    if (address?.isNotEmpty ?? false) {
      final Set<Polygon> polygon = HashSet<Polygon>();
      List<LatLng> points = [];
      for (final addr in address!) {
        points.add(LatLng(addr[0], addr[1]));
      }
      polygon.add(
        Polygon(
          polygonId: const PolygonId("zone"),
          points: points,
          fillColor: AppStyle.primary.withOpacity(0.01),
          strokeColor: AppStyle.primary,
          geodesic: false,
          strokeWidth: 8,
        ),
      );
      state = state.copyWith(polygon: polygon, isLoading: false, deliveryZone: points);
    }
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
    required Marker market,
  }) async {
    if (await AppConnectivity.connectivity()) {
      state = state.copyWith(polylineCoordinates: [], markers: {}, isLoading: true);
      final response = await _drawRepository.getRouting(start: start, end: end);
      response.when(
        success: (data) {
          List<LatLng> list = [];
          List ls = data.features[0].geometry.coordinates;
          for (int i = 0; i < ls.length; i++) {
            list.add(LatLng(ls[i][1], ls[i][0]));
          }
          state = state.copyWith(polylineCoordinates: list, markers: {market}, isLoading: false);
        },
        failure: (failure, status) => state = state.copyWith(polylineCoordinates: [], markers: {}, isLoading: false),
      );
    } else if (context.mounted) {
      AppHelpers.showNoConnectionSnackBar(context);
    }
  }

  Future<void> fetchCurrentOrder(BuildContext context) async {
    fetchDeliveryZone();
    state = state.copyWith(isGoRestaurant: false, isGoUser: false);
    if (await AppConnectivity.connectivity()) {
      final response = await _ordersRepository.fetchCurrentOrder();
      response.when(
        success: (data) async {
          if (data.data?.isNotEmpty ?? false) {
            state = state.copyWith(orderDetail: data.data?.first);
            final order = data.data!.first;
            final dest = order.status == "on_a_way" 
                ? LatLng(double.parse(order.location?.latitude ?? "0"), double.parse(order.location?.longitude ?? "0"))
                : LatLng(double.parse(order.shop?.location?.latitude ?? "0"), double.parse(order.shop?.location?.longitude ?? "0"));
            
            final markerIcon = order.status == "on_a_way"
                ? await _markerImageCropper.resizeAndCircle(order.user?.img ?? "", 100)
                : await _markerImageCropper.resizeAndCircle(order.shop?.logoImg ?? "", 120);

            getRoutingAll(
              context: context,
              start: LatLng(LocalStorage.getAddressSelected()?.location?.latitude ?? AppConstants.demoLatitude, LocalStorage.getAddressSelected()?.location?.longitude ?? AppConstants.demoLongitude),
              end: dest,
              market: Marker(
                markerId: MarkerId(order.status == "on_a_way" ? "User" : "Shop"),
                position: dest,
                icon: markerIcon,
              ),
            );
            state = state.copyWith(isGoRestaurant: order.status != "on_a_way", isGoUser: order.status == "on_a_way", isLoading: false);
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  Future<void> setOnline({required BuildContext context}) async {
    if (await AppConnectivity.connectivity()) {
      final userRepo = GetIt.instance.get<UserFacade>();
      final response = await userRepo.setOnline();
      response.when(
        success: (data) => LocalStorage.setOnline(!LocalStorage.getOnline()),
        failure: (failure, status) => AppHelpers.showCheckTopSnackBar(context, failure),
      );
    }
  }
}
