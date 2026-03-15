import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'package:venderfoodyman/domain/interface/customer/settings.dart';
import 'package:venderfoodyman/domain/interface/shops.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
import 'package:venderfoodyman/presentation/routes/app_router.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final SettingsFacade _settingsRepository;
  final UserFacade _usersRepository;
  final ShopsFacade _shopsRepository;

  ProfileNotifier(
    this._settingsRepository,
    this._usersRepository,
    this._shopsRepository,
  ) : super(const ProfileState());

  void setLogoImage(String path) {
    state = state.copyWith(logoImage: path);
  }

  void setBgImage(String path) {
    state = state.copyWith(bgImage: path);
  }

  void setAddress(AddressData? address) {
    state = state.copyWith(addressModel: address);
  }

  void setFile(String path) {
    List<String> list = List.from(state.filepath);
    list.add(path);
    state = state.copyWith(filepath: list);
  }

  void deleteFile(String path) {
    List<String> list = List.from(state.filepath);
    list.remove(path);
    state = state.copyWith(filepath: list);
  }

  Future<void> fetchUser(
    BuildContext context, {
    RefreshController? refreshController,
    ValueChanged<String?>? onSuccess,
  }) async {
    if (LocalStorage.getToken().isNotEmpty) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        if (refreshController == null) {
          state = state.copyWith(isLoading: true);
        }
        final response = await _usersRepository.getProfileDetails();
        response.when(
          success: (data) async {
            LocalStorage.setWalletData(data.data?.wallet);
            LocalStorage.setUser(data.data);
            onSuccess?.call(data.data?.phone);
            if (refreshController == null) {
              state = state.copyWith(isLoading: false, userData: data.data);
            } else {
              state = state.copyWith(userData: data.data);
            }
            refreshController?.refreshCompleted();
          },
          failure: (failure, status) {
            if (refreshController == null) {
              state = state.copyWith(isLoading: false);
            }
            if (status == 401) {
              context.router.popUntilRoot();
              context.replaceRoute(const AuthRoute());
            }
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      }
    }
  }

  // Manager bits
  Future<void> createShop({
    required BuildContext context,
    required String tax,
    required String deliveryTo,
    required String deliveryFrom,
    required String phone,
    required String startPrice,
    required String name,
    required String desc,
    required String perKm,
    required AddressData address,
    required String deliveryType,
    required String? categoryId,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isSaveLoading: true);
      String? logoImage;
      String? backgroundImage;
      List<String>? files;
      // ... image upload logic ...
      final response = await _shopsRepository.createShop(
        logoImage: logoImage,
        documents: files ?? [],
        backgroundImage: backgroundImage,
        tax: double.tryParse(tax) ?? 0,
        deliveryTo: double.tryParse(deliveryTo) ?? 0,
        deliveryFrom: double.tryParse(deliveryFrom) ?? 0,
        deliveryType: deliveryType,
        phone: phone,
        name: name,
        description: desc,
        startPrice: double.tryParse(startPrice) ?? 0,
        perKm: double.tryParse(perKm) ?? 0,
        address: address,
        category: categoryId,
      );
      response.when(
        success: (data) {
          state = state.copyWith(isSaveLoading: false);
          fetchUser(context);
          context.maybePop();
        },
        failure: (failure, s) {
          state = state.copyWith(isSaveLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _usersRepository.deleteAccount();
      response.when(
        success: (data) async {
          LocalStorage.logout();
          context.router.popUntilRoot();
          context.replaceRoute(const AuthRoute());
        },
        failure: (fail, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, fail);
        },
      );
    }
  }
}

Future<void> fetchRequestResponse({required BuildContext context}) async {
  if (await AppConnectivity.connectivity()) {
    state = state.copyWith(isLoading: true);
    final response = await _usersRepository.getRequestModel();
    response.when(
      success: (data) {
        state = state.copyWith(
          requestData: (data.data?.isEmpty ?? true) ? null : data.data?.first,
          isLoading: false,
        );
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> get request response failure: $failure');
      },
    );
  } else {
    // ignore: use_build_context_synchronously
    AppHelpers.showNoConnectionSnackBar(context);
  }
}
