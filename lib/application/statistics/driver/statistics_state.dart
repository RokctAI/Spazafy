import 'package:rokctapp/dummy_types.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'statistics_state.freezed.dart';

@freezed
abstract class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default(false) bool isLoading,
    @Default(true) bool isRefresh,
    @Default([]) List<Series<OrdinalSales, String>> list,
    @Default([]) List<StatisticsOrder> listOfOrder,
    StatisticsIncomeResponse? countData,
  }) = _StatisticsState;

  const StatisticsState._();
}
