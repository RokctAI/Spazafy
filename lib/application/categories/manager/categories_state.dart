import 'package:rokctapp/infrastructure/models/data/category_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart';
    hide CategoryData;
import 'package:rokctapp/infrastructure/models/models.dart' hide CategoryData;
part 'categories_state.freezed.dart';

@freezed
abstract class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(false) bool isLoading,
    @Default(false) bool isComboLoading,
    @Default([]) List<CategoryData> categories,
    @Default([]) List<CategoryData> comboCategories,
    @Default(1) int activeIndex,
    @Default(1) int activeComboIndex,
  }) = _CategoriesState;

  const CategoriesState._();
}
