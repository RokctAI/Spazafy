import 'package:rokctapp/infrastructure/models/data/manager/category_data.dart';
import 'package:rokctapp/domain/interface/manager_catalog.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart'
    as mgr
    hide SnackBarType;
import 'categories_state.dart';

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final CatalogInterface _catalogRepository;

  CategoriesNotifier(this._catalogRepository) : super(const CategoriesState());

  int _page = 0;
  int _comboPage = 0;

  Future<void> fetchCategories(
    BuildContext context, {
    bool? isRefresh,
    RefreshController? controller,
  }) async {
    if (isRefresh ?? false) {
      controller?.resetNoData();
      _page = 0;
      state = state.copyWith(categories: [], isLoading: true);
    }
    final res = await _catalogRepository.getCategories(
      page: ++_page,
      hasProducts: true,
    );
    res.when(
      success: (data) {
        List<CategoryData> list = List.from(state.categories);
        list.addAll(data.data ?? []);
        state = state.copyWith(isLoading: false, categories: list);
        if (isRefresh ?? false) {
          controller?.refreshCompleted();
          return;
        } else if (data.data?.isEmpty ?? true) {
          controller?.loadNoData();
          return;
        }
        controller?.loadComplete();
        return;
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        mgr.AppHelpers.errorSnackBar(context, text: failure);
      },
    );
  }

  Future<void> fetchComboCategories(
    BuildContext context, {
    bool? isRefresh,
    RefreshController? controller,
  }) async {
    if (isRefresh ?? false) {
      controller?.resetNoData();
      _comboPage = 0;
      state = state.copyWith(comboCategories: [], isComboLoading: true);
    }
    final res = await _catalogRepository.getCategories(
      page: ++_comboPage,
      type: 'combo',
      hasProducts: true,
    );
    res.when(
      success: (data) {
        List<CategoryData> list = List.from(state.comboCategories);
        list.addAll(data.data ?? []);
        state = state.copyWith(isComboLoading: false, comboCategories: list);
        if (isRefresh ?? false) {
          controller?.refreshCompleted();
          return;
        } else if (data.data?.isEmpty ?? true) {
          controller?.loadNoData();
          return;
        }
        controller?.loadComplete();
        return;
      },
      failure: (failure, status) {
        state = state.copyWith(isComboLoading: false);
        mgr.AppHelpers.errorSnackBar(context, text: failure);
      },
    );
  }

  void setActiveIndex(int index, {bool isCombo = false}) {
    if (isCombo) {
      if (state.activeComboIndex == index) {
        return;
      }
      state = state.copyWith(activeComboIndex: index);
    } else {
      if (state.activeIndex == index) {
        return;
      }
      state = state.copyWith(activeIndex: index);
    }
  }
}
