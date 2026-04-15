import 'package:rokctapp/infrastructure/models/data/category_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart'
    hide CategoryData;
import 'package:rokctapp/infrastructure/models/models.dart' hide CategoryData;
part 'edit_food_categories_state.freezed.dart';

@freezed
abstract class EditFoodCategoriesState with _$EditFoodCategoriesState {
  const factory EditFoodCategoriesState({
    @Default(false) bool isLoading,
    @Default([]) List<CategoryData> categories,
    @Default(0) int activeIndex,
    TextEditingController? categoriesController,
    CategoryData? foodCategory,
  }) = _EditFoodCategoriesState;

  const EditFoodCategoriesState._();
}
