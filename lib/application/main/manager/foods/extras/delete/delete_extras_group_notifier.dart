import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart'
    ;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/application/main/manager/foods/extras/delete/delete_extras_group_state.dart';

class DeleteExtrasGroupNotifier extends StateNotifier<DeleteExtrasGroupState> {
  final ProductsInterface _productsRepository;

  DeleteExtrasGroupNotifier(this._productsRepository)
    : super(const DeleteExtrasGroupState());

  Future<void> deleteExtrasGroup(
    BuildContext context, {
    VoidCallback? success,
    String? groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.deleteExtrasGroup(
      groupId: groupId,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> delete extras group fail $fail');
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          text: fail,
          type: SnackBarType.error,
        );
      },
    );
  }
}
