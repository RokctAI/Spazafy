import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

part 'statistics_state.freezed.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default(false) bool isLoading,
    @Default(true) bool isRefresh,
    @Default([]) List<StatisticsOrder> listOfOrder,
    @Default([]) List<num> prices,
    @Default([]) List<DateTime> time,
    StatisticsModel? countData, // Manager type
    StatisticsIncomeResponse? countDataDriver, // Driver type
  }) = _StatisticsState;

  const StatisticsState._();
}
