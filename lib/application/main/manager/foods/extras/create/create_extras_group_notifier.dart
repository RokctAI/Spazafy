import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart'
    ;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/application/main/manager/foods/extras/create/create_extras_group_state.dart';

class CreateExtrasGroupNotifier extends StateNotifier<CreateExtrasGroupState> {
  final ProductsInterface _productsRepository;
  String _title = '';

  CreateExtrasGroupNotifier(this._productsRepository)
    : super(const CreateExtrasGroupState());

  Future<void> createExtrasGroup(
    BuildContext context, {
    VoidCallback? success,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.createExtrasGroup(title: _title);
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        success?.call();
      },
      failure: (fail, status) {
        debugPrint('===> create extras group fail $fail');
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
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
