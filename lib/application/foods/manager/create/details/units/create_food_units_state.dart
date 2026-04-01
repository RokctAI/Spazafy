import 'package:rokctapp/infrastructure/models/data/manager/unit_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'create_food_units_state.freezed.dart';

@freezed
abstract class CreateFoodUnitsState with _$CreateFoodUnitsState {
  const factory CreateFoodUnitsState({
    @Default(false) bool isLoading,
    @Default([]) List<UnitData> units,
    @Default(0) int activeIndex,
    TextEditingController? unitController,
  }) = _CreateFoodUnitsState;

  const CreateFoodUnitsState._();
}
