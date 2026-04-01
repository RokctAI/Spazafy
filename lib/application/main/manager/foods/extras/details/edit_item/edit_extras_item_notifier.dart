import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart'
    as mgr
    hide SnackBarType;
import 'edit_extras_item_state.dart';

class EditExtrasItemNotifier extends StateNotifier<EditExtrasItemState> {
  final ProductsInterface _productsRepository;
  String _title = '';

  EditExtrasItemNotifier(this._productsRepository)
    : super(const EditExtrasItemState());

  Future<void> updateExtrasItem(
    BuildContext context, {
    VoidCallback? success,
    String? groupId,
    String? extrasId,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.updateExtrasItem(
      extrasId: extrasId ?? '',
      title: _title,
      groupId: groupId ?? '',
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> update extras item fail $fail');
        state = state.copyWith(isLoading: false);
        mgr.mgr.mgr.AppHelpers.showCheckTopSnackBar(
          context,
          context,
          text: fail,
          type: SnackBarType.error,
        );
      },
    );
  }

  void setTitle(String value) {
    _title = value.trim();
  }
}
