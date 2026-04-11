import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:rokctapp/infrastructure/models/data/group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_extras_group_state.freezed.dart';

@freezed
abstract class UpdateExtrasGroupState with _$UpdateExtrasGroupState {
  const factory UpdateExtrasGroupState({@Default(false) bool isLoading}) =
      _UpdateExtrasGroupState;

  const UpdateExtrasGroupState._();
}
