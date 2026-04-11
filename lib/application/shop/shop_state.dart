import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/models/data/manager/category_data.dart';
import 'package:rokctapp/infrastructure/models/response/branches_response.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/models/data/brand_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/infrastructure/models/models.dart' hide CategoryData;
import 'package:rokctapp/infrastructure/models/response/all_products_response.dart';

import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart'
    hide CategoryData;
part 'shop_state.freezed.dart';

@freezed
class ShopState with _$ShopState {
  const factory ShopState({
    @Default(false) bool isLoading,
    @Default(false) bool isFilterLoading,
    @Default(true) bool isCategoryLoading,
    @Default(true) bool isPopularLoading,
    @Default(true) bool isProductLoading,
    @Default(false) bool isProductCategoryLoading,
    @Default(false) bool isPopularProduct,
    @Default(true) bool isBrandsLoading,
    @Default(false) bool isLike,
    @Default(false) bool showWeekTime,
    @Default(false) bool showBranch,
    @Default(false) bool isMapLoading,
    @Default(false) bool isGroupOrder,
    @Default(false) bool isJoinOrder,
    @Default(false) bool isSearchEnabled,
    @Default(false) bool isTodayWorkingDay,
    @Default(false) bool isTomorrowWorkingDay,
    @Default(false) bool isNestedScrollDisabled,
    @Default("") String userUuid,
    @Default("") String searchText,
    @Default(TimeOfDay(hour: 0, minute: 0)) TimeOfDay startTodayTime,
    @Default(TimeOfDay(hour: 0, minute: 0)) TimeOfDay endTodayTime,
    @Default(0) int currentIndex,
    @Default(0) int subCategoryIndex,
    @Default({}) Set<Marker> shopMarkers,
    @Default([]) List<LatLng> polylineCoordinates,
    @Default(null) ShopData? shopData,
    // @Default([]) List<ProductData> products,
    // @Default([]) List<ProductData> popularProducts,
    @Default([]) List<ProductData> categoryProducts,
    @Default([]) List<All> allData,
    @Default([]) List<CategoryData>? category,
    @Default([]) List<BrandData>? brands,
    @Default([]) List<BranchModel>? branches,
    @Default([]) List<String> brandIds,
    @Default(0) int sortIndex,
    @Default(false) bool isDataUnavailableOffline,
  }) = _ShopState;

  const ShopState._();
}
