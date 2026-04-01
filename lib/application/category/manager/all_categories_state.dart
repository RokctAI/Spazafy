import 'package:rokctapp/infrastructure/models/data/manager/category_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/models.dart' hide CategoryData;
part 'all_categories_state.freezed.dart';

@freezed
abstract class AllCategoriesState with _$AllCategoriesState {
  const factory AllCategoriesState({
    @Default([]) List<CategoryData> categories,
    @Default([]) List<CategoryData> comboCategories,
    @Default([]) List<CategoryData> categoriesSub,
    @Default([]) List<CategoryData> comboCategoriesSub,
    @Default(1) int activeIndex,
    @Default(1) int activeSubIndex,
    @Default(1) int activeComboIndex,
    @Default(1) int activeComboSubIndex,
    TextEditingController? categoryController,
    TextEditingController? categorySubController,
    @Default(false) bool isLoading,
  }) = _AllCategoriesState;

  const AllCategoriesState._();
}
