import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';

part 'view_map_state.freezed.dart';

@freezed
abstract class ViewMapState with _$ViewMapState {
  const factory ViewMapState({
    @Default(false) bool isLoading,
    @Default(false) bool isScrolling,
    @Default(false) bool isSetAddress,
    @Default(false) bool isActive,
    AddressNewModel? place,
  }) = _ViewMapState;

  const ViewMapState._();
}
