import 'package:rokctapp/infrastructure/models/data/story_data.dart';
import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/models/response/banners_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/data/manager/category_data.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/models/data/brand_data.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool isCategoryLoading,
    @Default(true) bool isBannerLoading,
    @Default(true) bool isShopLoading,
    @Default(true) bool isAllShopsLoading,
    @Default(true) bool isNewShopsLoading,
    @Default(true) bool isStoryLoading,
    @Default(true) bool isShopRecommendLoading,
    @Default([]) List<ProductData> discountProducts,
    @Default(true) bool isDiscountProductsLoading,
    @Default(-1) int totalShops,
    @Default(-1) int selectIndexCategory,
    @Default(-1) int selectIndexSubCategory,
    @Default(0) int isSelectCategoryLoading,
    @Default(null) AddressNewModel? addressData,
    @Default([]) List<CategoryData> categories,
    @Default([]) List<BannerData> banners,
    @Default([]) List<BannerData> ads,
    @Default(null) BannerData? banner,
    @Default([]) List<ShopData> shops,
    @Default([]) List<ShopData> allShops,
    @Default([]) List<ShopData> newShops,
    @Default([]) List<List<StoryModel?>?>? story,
    @Default([]) List<ShopData> shopsRecommend,
    @Default([]) List<ShopData> filterShops,
    @Default([]) List<ShopData> filterMarket,
    @Default([]) List<BrandData> brands,
  }) = _HomeState;

  const HomeState._();
}
