import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/shops.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'like_state.dart';

class LikeNotifier extends StateNotifier<LikeState> {
  final ShopsRepositoryFacade _shopsRepository;

  LikeNotifier(this._shopsRepository) : super(const LikeState());

  Future<void> fetchLikeShop(BuildContext context) async {
    state = state.copyWith(isShopLoading: true);
    final list = LocalStorage.getSavedShopsList();
    if (list.isNotEmpty) {
      final response = await _shopsRepository.getShopsByIds(list);
      response.when(
        success: (data) async {
          state = state.copyWith(
            isShopLoading: false,
            shops: data.data ?? [],
            likedShopsCount: data.data?.length ?? 0,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isShopLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      state = state.copyWith(
        isShopLoading: false,
        shops: [],
        likedShopsCount: 0,
      );
    }
  }
}
