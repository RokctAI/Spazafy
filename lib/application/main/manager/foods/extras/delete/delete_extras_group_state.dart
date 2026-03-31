import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/infrastructure/models/data/manager/group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'delete_extras_group_state.freezed.dart';

@freezed
abstract class DeleteExtrasGroupState with _$DeleteExtrasGroupState {
  const factory DeleteExtrasGroupState({@Default(false) bool isLoading}) =
      _DeleteExtrasGroupState;

  const DeleteExtrasGroupState._();
}
