
import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart' as mgr hide SnackBarType;
import 'delete_extras_item_state.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';

class DeleteExtrasItemNotifier extends StateNotifier<DeleteExtrasItemState> {
  final ProductsInterface _productsRepository;

  DeleteExtrasItemNotifier(this._productsRepository)
    : super(const DeleteExtrasItemState());

  Future<void> deleteExtrasItem(
    BuildContext context, {
    VoidCallback? success,
    int? extrasId,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.deleteExtrasItem(
      extrasId: extrasId ?? 0,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> delete extras item fail $fail');
        state = state.copyWith(isLoading: false);
        mgr.mgr.AppHelpers.showCheckTopSnackBar(
          context,
          text: fail,
          type: SnackBarType.error,
        );
      },
    );
  }
}
