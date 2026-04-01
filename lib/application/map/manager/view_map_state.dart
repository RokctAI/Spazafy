import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'view_map_state.freezed.dart';

@freezed
abstract class ViewMapState with _$ViewMapState {
  const factory ViewMapState({
    @Default(false) bool isLoading,
    @Default(false) bool isActive,
    @Default(null) AddressData? place,
    @Default(false) bool isSetAddress,
  }) = _ViewMapState;

  const ViewMapState._();
}
