import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/interface/products.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'foods_state.dart';

class FoodsNotifier extends StateNotifier<FoodsState> {
  final ProductsFacade _productsRepository;
  int _page = 0;
  bool _hasMore = true;
  Timer? _timer;
  String _query = '';
  String? _categoryId;
  String _productType = 'single';

  FoodsNotifier(this._productsRepository) : super(const FoodsState());

  // Manager/Listing methods
  Future<void> fetchMoreProducts({RefreshController? refreshController}) async {
    if (!_hasMore) {
      refreshController?.loadNoData();
      return;
    }
    final response = await _productsRepository.getProducts(
      page: ++_page,
      query: _query.isEmpty ? null : _query.trim(),
      categoryId: _categoryId,
      type: _productType,
    );
    response.when(
      success: (data) {
        List<ProductData> products = List.from(state.foods);
        final List<ProductData> newProducts = data.data ?? [];
        products.addAll(newProducts);
        _hasMore = newProducts.length >= 10;
        refreshController?.loadComplete();
        state = state.copyWith(foods: products);
      },
      failure: (fail, status) {
        debugPrint('===> fetch more products fail $fail');
        refreshController?.loadFailed();
      },
    );
  }

  Future<void> fetchCategoryProducts({
    String? categoryId,
    RefreshController? refreshController,
  }) async {
    _categoryId = categoryId;
    refreshController?.resetNoData();
    _hasMore = true;
    _page = 0;
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.getProducts(
      categoryId: _categoryId,
      query: _query.isEmpty ? null : _query.trim(),
      page: ++_page,
      type: _productType,
    );
    response.when(
      success: (data) {
        final List<ProductData> products = data.data ?? [];
        _hasMore = products.length >= 10;
        state = state.copyWith(foods: products, isLoading: false);
      },
      failure: (fail, status) {
        debugPrint('===> fetch category products fail $fail');
        state = state.copyWith(foods: [], isLoading: false);
      },
    );
  }

  Future<void> initialFetchFoods() async {
    if (state.foods.isNotEmpty) {
      return;
    }
    _page = 0;
    _hasMore = true;
    _query = '';
    _categoryId = null;
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.getProducts(
      page: ++_page,
      type: _productType,
    );
    response.when(
      success: (data) {
        List<ProductData> products = data.data ?? [];
        _hasMore = products.length >= 10;
        state = state.copyWith(isLoading: false, foods: products);
      },
      failure: (fail, status) {
        debugPrint('===> fetch products fail $fail');
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void updateSingleProduct(ProductData? product) {
    List<ProductData> products = List.from(state.foods);
    int? index;
    for (int i = 0; i < products.length; i++) {
      if (product?.id == products[i].id) {
        index = i;
      }
    }
    if (index != null && product != null) {
      products[index] = product;
      state = state.copyWith(foods: products);
    }
  }

  // Driver methods (merged from FoodNotifier)
  void changeToggle(bool toggle) {
    state = state.copyWith(toggle: toggle);
  }

  void changeTimeIndex(int index) {
    state = state.copyWith(timeIndex: index);
  }
}
