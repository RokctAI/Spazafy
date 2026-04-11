import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/models/data/addons_data.dart';
import 'package:rokctapp/infrastructure/models/data/brand_data.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/time_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/domain/interface/brands.dart';
import 'package:rokctapp/domain/interface/categories.dart';
import 'package:rokctapp/domain/interface/products.dart';
import 'package:rokctapp/domain/interface/shops.dart';

import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/marker_image_cropper.dart';
import 'package:rokctapp/domain/interface/draw.dart';
import 'package:rokctapp/infrastructure/models/response/all_products_response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/models/data/translation.dart';
import 'package:rokctapp/application/shop/shop_state.dart';




class ShopNotifier extends StateNotifier<ShopState> {
  final ProductsRepositoryFacade _productsRepository;
  final ShopsRepositoryFacade _shopsRepository;
  final CategoriesRepositoryFacade _categoriesRepository;
  final DrawRepositoryFacade _drawRouting;
  final BrandsRepositoryFacade _brandsRepository;

  ShopNotifier(
    this._shopsRepository,
    this._productsRepository,
    this._categoriesRepository,
    this._drawRouting,
    this._brandsRepository,
  ) : super(const ShopState());
  int page = 1;
  List<String> _list = [];
  String? shareLink;

  void showWeekTime() {
    state = state.copyWith(showWeekTime: !state.showWeekTime);
  }

  void showBranch() {
    state = state.copyWith(showBranch: !state.showBranch);
  }

  void enableSearch() {
    state = state.copyWith(isSearchEnabled: !state.isSearchEnabled);
  }

  void enableNestedScroll({bool? val}) {
    state = state.copyWith(
      isNestedScrollDisabled: val ?? !state.isNestedScrollDisabled,
    );
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
  }) async {
    state = state.copyWith(polylineCoordinates: []);
    final response = await _drawRouting.getRouting(start: start, end: end);
    response.when(
      success: (data) {
        List<LatLng> list = [];
        List ls = data.features[0].geometry.coordinates;
        for (int i = 0; i < ls.length; i++) {
          list.add(LatLng(ls[i][1], ls[i][0]));
        }
        state = state.copyWith(polylineCoordinates: list);
      },
      failure: (failure, status) {
        state = state.copyWith(polylineCoordinates: []);
      },
    );
  }

  changeMap({required LatLng shopLocation}) async {
    state = state.copyWith(isMapLoading: true);
    final ImageCropperForMarker image = ImageCropperForMarker();
    Set<Marker> markers = {};
    markers.addAll({
      Marker(
        markerId: const MarkerId("shop"),
        position: shopLocation,
        icon: await image.resizeAndCircle(state.shopData?.logoImg ?? "", 120),
      ),
      Marker(
        markerId: const MarkerId("user"),
        position: LatLng(
          LocalStorage.getAddressSelected()?.location?.latitude ??
              AppConstants.demoLatitude,
          LocalStorage.getAddressSelected()?.location?.longitude ??
              AppConstants.demoLongitude,
        ),
        icon: await image.resizeAndCircle(LocalStorage.getUser()?.img, 120),
      ),
    });
    state = state.copyWith(isMapLoading: false, shopMarkers: markers);
  }

  getMarker() async {
    state = state.copyWith(
      isMapLoading: true,
      showBranch: false,
      showWeekTime: false,
    );
    final ImageCropperForMarker image = ImageCropperForMarker();
    Set<Marker> markers = {};
    markers.addAll({
      Marker(
        markerId: const MarkerId("shop"),
        position: LatLng(
          state.shopData?.location?.latitude ?? AppConstants.demoLatitude,
          state.shopData?.location?.longitude ?? AppConstants.demoLongitude,
        ),
        icon: await image.resizeAndCircle(state.shopData?.logoImg ?? "", 120),
      ),
      Marker(
        markerId: const MarkerId("user"),
        position: LatLng(
          LocalStorage.getAddressSelected()?.location?.latitude ??
              AppConstants.demoLatitude,
          LocalStorage.getAddressSelected()?.location?.longitude ??
              AppConstants.demoLongitude,
        ),
        icon: await image.resizeAndCircle(LocalStorage.getUser()?.img, 120),
      ),
    });
    state = state.copyWith(shopMarkers: markers, isMapLoading: false);
    final res = await _shopsRepository.getShopBranch(
      uuid: state.shopData?.id ?? "",
    );
    res.when(
      success: (data) {
        state = state.copyWith(branches: data.data);
      },
      failure: (t, e) {},
    );
  }

  void onLike() {
    if (state.isLike) {
      for (int i = 0; i < _list.length; i++) {
        if (_list[i] == state.shopData?.id) {
          _list.removeAt(i);
          break;
        }
      }
    } else {
      _list.add(state.shopData?.id ?? "");
    }
    state = state.copyWith(isLike: !state.isLike);
    LocalStorage.setSavedShopsList(_list);
  }

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void changeSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

  void changeSubIndex(int index) {
    state = state.copyWith(subCategoryIndex: index);
  }

  void checkWorkingDay() {
    if (state.shopData == null) return;

    final result = state.shopData!.checkWorkingDay();
    final bool isOpen = result["isOpen"] ?? false;
    final DateTime? start = result["startTodayTime"];
    final DateTime? end = result["endTodayTime"];

    state = state.copyWith(
      isTodayWorkingDay: isOpen,
      startTodayTime: start != null
          ? TimeOfDay(hour: start.hour, minute: start.minute)
          : const TimeOfDay(hour: 0, minute: 0),
      endTodayTime: end != null
          ? TimeOfDay(hour: end.hour, minute: end.minute)
          : const TimeOfDay(hour: 0, minute: 0),
    );
  }

  Future<void> setShop(ShopData shop) async {
    _list = LocalStorage.getSavedShopsList();
    for (String e in _list) {
      if (e == shop.id) {
        state = state.copyWith(isLike: true);
        break;
      }
    }
    state = state.copyWith(shopData: shop);
    generateShareLink();
    checkWorkingDay();
    final response = await _shopsRepository.getSingleShop(
      uuid: (shop.id ?? "").toString(),
    );
    response.when(
      success: (data) async {
        _list = LocalStorage.getSavedShopsList();
        for (String e in _list) {
          if (e == data.data?.id) {
            state = state.copyWith(isLike: true);
            break;
          }
        }
        state = state.copyWith(shopData: data.data);
        checkWorkingDay();
      },
      failure: (failure, status) {},
    );
  }

  leaveGroup() {
    state = state.copyWith(userUuid: "", isGroupOrder: false);
  }

  Future<void> joinOrder(
    BuildContext context,
    String shopId,
    String cartId,
    String name,
    VoidCallback onSuccess,
  ) async {
    state = state.copyWith(isJoinOrder: true);
    final response = await _shopsRepository.joinOrder(
      shopId: shopId,
      name: name,
      cartId: cartId,
    );
    response.when(
      success: (data) async {
        state = state.copyWith(
          isJoinOrder: false,
          isGroupOrder: true,
          userUuid: data,
        );
        onSuccess();
      },
      failure: (failure, status) {
        state = state.copyWith(
          isJoinOrder: false,
          userUuid: "",
          isGroupOrder: false,
        );
      },
    );
  }

  Future<void> fetchShop(BuildContext context, String uuid) async {
    state = state.copyWith(isLoading: true);
    final response = await _shopsRepository.getSingleShop(uuid: uuid);
    response.when(
      success: (data) async {
        _list = LocalStorage.getSavedShopsList();
        for (String e in _list) {
          if (e == data.data?.id) {
            state = state.copyWith(isLike: true);
            break;
          }
        }
        state = state.copyWith(isLoading: false, shopData: data.data);
        generateShareLink();
        checkWorkingDay();
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<bool> fetchCategory(BuildContext context, String shopId) async {
    state = state.copyWith(isCategoryLoading: true);
    final response = await _categoriesRepository.getCategoriesByShop(
      shopId: shopId,
    );
    return response.when(
      success: (data) async {
        state = state.copyWith(category: data.data, isCategoryLoading: false);
        return true;
      },
      failure: (failure, status) {
        state = state.copyWith(isCategoryLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
        return false;
      },
    );
  }

  // At the end of the fetchProducts method in ShopNotifier, add this code
  // to copy brand_ids from regular products to popular products:

  Future<void> fetchProducts(
    BuildContext context,
    String shopId,
    ValueChanged<int> onSuccess,
  ) async {
    page = 1;
    state = state.copyWith(
      isProductLoading: true,
      isCategoryLoading: true,
      isBrandsLoading: true,
    );

    // First, fetch all brands for the shop - this is the only brands request we need
    final brandsResponse = await _brandsRepository.getAllBrands(shopId: shopId);
    List<BrandData> shopBrands = [];

    brandsResponse.when(
      success: (brandsData) {
        shopBrands = brandsData.data ?? [];
        // Update state with all shop brands - we won't need to fetch by category anymore
        state = state.copyWith(brands: shopBrands, isBrandsLoading: false);
      },
      failure: (failure, status) {
        debugPrint('Failed to fetch brands: $failure');
        state = state.copyWith(isBrandsLoading: false);
      },
    );

    // Then fetch products
    final productsResponse = await _productsRepository.getAllProducts(
      shopId: shopId,
    );

    productsResponse.when(
      success: (data) {
        List<All> allList = data.data?.all ?? [];
        for (int i = 0; i < allList.length; i++) {
          allList[i] = allList[i].copyWith(key: GlobalKey());
        }

        if (data.data?.recommended?.isNotEmpty ?? false) {
          final Map<String, Product> productsById = {};
          for (final category in allList) {
            for (final product in category.products ?? []) {
              if (product.id != null) {
                productsById[product.id!] = product;
              }
            }
          }

          final List<Product> recommendedWithBrands = [];
          for (final recProduct in data.data?.recommended ?? []) {
            if (recProduct.id != null &&
                productsById.containsKey(recProduct.id)) {
              final regularProduct = productsById[recProduct.id]!;
              recommendedWithBrands.add(
                recProduct.copyWith(brandId: regularProduct.brandId),
              );
            } else {
              recommendedWithBrands.add(recProduct);
            }
          }

          allList.insert(
            0,
            All(
              translation: Translation(
                title: AppHelpers.getTranslation(TrKeys.popular),
              ),
              key: GlobalKey(),
              products: recommendedWithBrands,
            ),
          );
        }

        state = state.copyWith(
          allData: allList,
          isProductLoading: false,
          isCategoryLoading: false,
        );

        onSuccess.call(allList.length);
      },
      failure: (failure, status) {
        state = state.copyWith(
          isProductLoading: false,
          isCategoryLoading: false,
        );
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  // Modified fetchBrands method - only used as a fallback
  Future<void> fetchBrands(
    BuildContext context, {
    String? categoryId,
    String? shopId,
  }) async {
    if (state.brands != null && state.brands!.isNotEmpty) {
      return;
    }
    state = state.copyWith(isBrandsLoading: true);
    final response = await _brandsRepository.getAllBrands(
      categoryId: categoryId,
      shopId: shopId,
    );
    response.when(
      success: (data) {
        state = state.copyWith(brands: data.data, isBrandsLoading: false);
      },
      failure: (failure, status) {
        state = state.copyWith(isBrandsLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  // ignore: unused_element
  Future<void> _fetchBrandForCategory(
    BuildContext context,
    int page,
    String categoryId,
  ) async {
    try {
      final result = await _brandsRepository.getAllBrands(
        categoryId: categoryId,
      );
      result.when(
        success: (data) {
          state = state.copyWith(brands: data.data ?? []);
        },
        failure: (error, statusCode) {
          debugPrint(error);
        },
      );
    } catch (e) {
      debugPrint('Exception in _fetchBrandForCategory: $e');
    }
  }

  Future<void> checkProductsPopular(BuildContext context, String shopId) async {
    page = 1;
    final response = await _productsRepository.getProductsPopularPaginate(
      page: 1,
      shopId: shopId,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isPopularProduct: (data.data ?? []).isNotEmpty);
      },
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  // Future<void> fetchProductsPopular(BuildContext context, String shopId) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     page = 1;
  //     state = state.copyWith(
  //       isProductLoading: true,
  //     );
  //     final response = await _productsRepository.getProductsPopularPaginate(
  //         page: 1, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         state = state.copyWith(
  //             popularProducts: data.data
  //                     ?.map((e) => ProductData.fromJson(e.toJson()))
  //                     .toList() ??
  //                 [],
  //             isProductLoading: false,
  //             isPopularProduct: (data.data ?? []).isNotEmpty);
  //       },
  //       failure: (failure, status) {
  //         state = state.copyWith(isProductLoading: false);
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }

  Future<void> fetchProductsByCategory(
    BuildContext context,
    String shopId,
    String categoryId,
  ) async {
    state = state.copyWith(isProductCategoryLoading: true);
    page = 1;
    final response = await _productsRepository
        .getProductsShopByCategoryPaginate(
          page: 1,
          shopId: shopId,
          categoryId: categoryId,
          sortIndex: state.sortIndex,
          brands: state.brandIds,
        );
    response.when(
      success: (data) {
        state = state.copyWith(
          categoryProducts: data.data ?? [],
          isProductCategoryLoading: false,
        );
      },
      failure: (failure, status) {
        state = state.copyWith(isProductCategoryLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> fetchProductsByCategoryPage(
    BuildContext context,
    String shopId,
    String categoryId, {
    RefreshController? controller,
  }) async {
    final response = await _productsRepository
        .getProductsShopByCategoryPaginate(
          page: ++page,
          shopId: shopId,
          categoryId: categoryId,
        );
    response.when(
      success: (data) {
        List<ProductData> list = List.from(state.categoryProducts);
        list.addAll(data.data!.toList());
        state = state.copyWith(categoryProducts: list);
        if (data.data?.isEmpty ?? true) {
          controller?.loadNoData();
          return;
        }
        controller?.loadComplete();
      },
      failure: (failure, status) {
        controller?.loadComplete();
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  // Future<void> fetchProductsPage(BuildContext context, String shopId,
  //     {RefreshController? controller}) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     final response = await _productsRepository.getProductsPaginate(
  //         page: ++page, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         List<ProductData> list = List.from(state.products);
  //         list.addAll(data.data!.toList());
  //         state = state.copyWith(
  //           products:
  //               list.map((e) => ProductData.fromJson(e.toJson())).toList(),
  //         );
  //         if (data.data?.isEmpty ?? true) {
  //           controller?.loadNoData();
  //           return;
  //         }
  //
  //         controller?.loadComplete();
  //       },
  //       failure: (failure, status) {
  //         controller?.loadComplete();
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }

  // Future<void> fetchProductsPopularPage(BuildContext context, String shopId,
  //     {RefreshController? controller}) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     final response = await _productsRepository.getProductsPopularPaginate(
  //         page: ++page, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         List<ProductData> list = List.from(state.products);
  //         list.addAll(data.data ?? []);
  //         state = state.copyWith(products: list);
  //         if (data.data?.isEmpty ?? true) {
  //           controller?.loadNoData();
  //           return;
  //         }
  //
  //         controller?.loadComplete();
  //       },
  //       failure: (failure, status) {
  //         controller?.loadComplete();
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }

  setBrands({required String id}) {
    List<String> list = List.from(state.brandIds);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(brandIds: list);
  }

  clear() {
    state = state.copyWith(brandIds: [], sortIndex: 0);
  }

  changeSort(int index) {
    state = state.copyWith(sortIndex: index);
  }

  generateShareLink() async {
    final productLink = '${AppConstants.webUrl}/shop/${state.shopData?.id}';

    final dynamicLink =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${AppConstants.firebaseWebKey}';

    final dataShare = {
      "dynamicLinkInfo": {
        "domainUriPrefix": AppConstants.uriPrefix,
        "link": productLink,
        "androidInfo": {
          "androidPackageName": AppConstants.androidPackageName,
          "androidFallbackLink":
              "${AppConstants.webUrl}/shop/${state.shopData?.id}",
        },
        "iosInfo": {
          "iosBundleId": AppConstants.iosPackageName,
          "iosFallbackLink":
              "${AppConstants.webUrl}/shop/${state.shopData?.id}",
        },
        "socialMetaTagInfo": {
          "socialTitle": "${state.shopData?.translation?.title}",
          "socialDescription": "${state.shopData?.translation?.description}",
          "socialImageLink": '${state.shopData?.logoImg}',
        },
      },
    };
    final client = dioHttp.client(requireAuth: false);
    final res = await client.post(
      'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${AppConstants.firebaseWebKey}',
      data: dataShare,
    );

    state = state.copyWith(shareLink: res.data['shortLink']);

    debugPrint('share link shop_notifier: ${state.shareLink}\n$dataShare');
  }

  onShare() async {
    await Share.share(
      state.shareLink ?? '',
      subject: state.shopData?.translation?.title ?? "Juvo",
      // title: state.shopData?.translation?.description ?? "",
    );
  }

  Future<ShopData?> fetchShopData(String shopId) async {
    final response = await _shopsRepository.getSingleShop(uuid: shopId);
    return response.when(
      success: (data) => data.data,
      failure: (failure, status) {
        return null;
      },
    );
  }
}
