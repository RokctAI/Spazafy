import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';

final authRepository = driverAuthRepository;
final userRepository = driverUserRepository;
final orderRepository = driverOrderRepository;
final parcelRepository = driverParcelRepository;
final settingsRepository = driverSettingsRepository;
final drawRepository = driverDrawRepository;
final notificationRepo = driverNotificationRepo;

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  ) async {
    String type = '';
    switch (uploadType) {
      case UploadType.brands:
        type = 'brands';
        break;
      case UploadType.extras:
        type = 'extras';
        break;
      case UploadType.categories:
        type = 'categories';
        break;
      case UploadType.shopsLogo:
        type = 'shops/logo';
        break;
      case UploadType.shopsBack:
        type = 'shops/background';
        break;
      case UploadType.deliveryCar:
        type = 'deliveryman/settings';
        break;
      case UploadType.products:
        type = 'products';
        break;
      case UploadType.reviews:
        type = 'reviews';
        break;
      case UploadType.users:
        type = 'users';
        break;
    }
    final data = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
      'type': type,
    });
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.gallery.gallery.upload_gallery_image',
        data: data,
      );
      return ApiResult.success(
        data: GalleryUploadResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> upload image failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.system.system.get_currencies',
      );
      return ApiResult.success(
        data: CurrenciesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get currencies failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SettingsResponse>> getGlobalSettings() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.system.system.get_global_settings',
      );
      return ApiResult.success(data: SettingsResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get settings failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<MobileTranslationsResponse>> getTranslations() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale ?? 'en'};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.translation.get_mobile_translations',
        queryParameters: data,
      );
      return ApiResult.success(
        data: MobileTranslationsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get translations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LanguagesResponse>> getLanguages() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.system.system.get_languages',
      );
      if (LocalStorage.getLanguage() != null &&
          !(LanguagesResponse.fromJson(response.data).data
                  ?.map((e) => e.id)
                  .contains(LocalStorage.getLanguage()?.id) ??
              true)) {
        LanguagesResponse.fromJson(response.data).data?.forEach((element) {
          if (element.isDefault ?? false) {
            LocalStorage.setLanguageData(element);
          }
        });
      }
      return ApiResult.success(data: LanguagesResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get languages failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
