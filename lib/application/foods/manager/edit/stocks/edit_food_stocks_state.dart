import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/infrastructure/models/data/manager/group.dart';
import 'package:rokctapp/infrastructure/models/data/manager/stock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'edit_food_stocks_state.freezed.dart';

@freezed
abstract class EditFoodStocksState with _$EditFoodStocksState {
  const factory EditFoodStocksState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isFetchingGroups,
    @Default([]) List<int> deleteStocks,
    @Default([]) List<Group> groups,
    @Default([]) List<Stock> stocks,
    @Default([]) List<Extras> activeGroupExtras,
    @Default({}) Map<String, List<Extras?>> selectGroups,
  }) = _EditFoodStocksState;

  const EditFoodStocksState._();
}
