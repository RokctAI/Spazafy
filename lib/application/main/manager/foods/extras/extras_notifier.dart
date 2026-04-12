import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/extras/extras_state.dart';

class ExtrasNotifier extends StateNotifier<ExtrasState> {
  final ProductsInterface _productsRepository;

  ExtrasNotifier(this._productsRepository) : super(const ExtrasState());

  Future<void> fetchGroups({RefreshController? refreshController}) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.getExtrasGroups(
      needOnlyValid: false,
    );
    response.when(
      success: (data) {
        state = state.copyWith(groups: data.data ?? [], isLoading: false);
        refreshController?.refreshCompleted();
      },
      failure: (fail, status) {
        debugPrint('===> fetch groups fail $fail');
        state = state.copyWith(isLoading: false);
        refreshController?.refreshFailed();
      },
    );
  }
}
