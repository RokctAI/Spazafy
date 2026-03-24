
import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart' as mgr hide SnackBarType;
import 'update_extras_group_state.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';

class UpdateExtrasGroupNotifier extends StateNotifier<UpdateExtrasGroupState> {
  final ProductsInterface _productsRepository;
  String _title = '';

  UpdateExtrasGroupNotifier(this._productsRepository)
    : super(const UpdateExtrasGroupState());

  Future<void> updateExtrasGroup(
    BuildContext context, {
    VoidCallback? success,
    String? groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.updateExtrasGroup(
      title: _title,
      groupId: groupId,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> update extras group fail $fail');
        state = state.copyWith(isLoading: false);
        mgr.mgr.AppHelpers.showCheckTopSnackBar(
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
