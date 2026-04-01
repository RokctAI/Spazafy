import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/constants/manager/enums.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';
import 'create_new_group_item_state.dart';
import 'package:rokctapp/domain/interface/manager_products.dart';

class CreateNewGroupItemNotifier
    extends StateNotifier<CreateNewGroupItemState> {
  final ProductsInterface _productsRepository;
  String _title = '';

  CreateNewGroupItemNotifier(this._productsRepository)
    : super(const CreateNewGroupItemState());

  Future<void> createExtrasItem(
    BuildContext context, {
    VoidCallback? success,
    String? groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.createExtrasItem(
      title: _title,
      groupId: groupId ?? '0',
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> create extras item fail $fail');
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          fail,
          type: SnackBarType.error,
        );
      },
    );
  }

  void setTitle(String value) {
    _title = value.trim();
  }
}
