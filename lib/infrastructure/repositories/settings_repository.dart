import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/settings.dart';
import 'package:foodyman/infrastructure/models/data/help_data.dart';
import 'package:foodyman/infrastructure/models/data/notification_list_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import '../models/data/translation.dart';

class SettingsRepository implements SettingsRepositoryFacade {
  // --- Common & Customer (Frappe/ERPNext) ---

  @override
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.system.system.get_global_settings');
      return ApiResult.success(data: GlobalSettingsResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to standard V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.get('/api/v1/rest/settings');
        // GlobalSettingsResponse and SettingsResponse might need mapping if they differ significantly
        return ApiResult.success(data: GlobalSettingsResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale ?? 'en'};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.translation.get_mobile_translations', queryParameters: data);
      return ApiResult.success(data: MobileTranslationsResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.get('/api/v1/rest/translations/paginate', queryParameters: data);
        return ApiResult.success(data: MobileTranslationsResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<LanguagesResponse>> getLanguages() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      // Try Frappe endpoint first
      final response = await client.get('/api/method/paas.api.system.system.get_languages');
      final languagesResponse = LanguagesResponse.fromJson(response.data);
      _updateLocalLanguages(languagesResponse);
      return ApiResult.success(data: languagesResponse);
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.get('/api/v1/rest/languages/active');
        final languagesResponse = LanguagesResponse.fromJson(response.data);
        _updateLocalLanguages(languagesResponse);
        return ApiResult.success(data: languagesResponse);
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  void _updateLocalLanguages(LanguagesResponse response) {
    if (LocalStorage.getLanguage() == null ||
        !(response.data?.map((e) => e.id).contains(LocalStorage.getLanguage()?.id) ?? true)) {
      response.data?.forEach((element) {
        if (element.isDefault ?? false) {
          LocalStorage.setLanguageData(element);
        }
      });
    }
    if (response.data?.isNotEmpty ?? false) {
      LocalStorage.setActiveLanguages(response.data!);
    }
  }

  @override
  Future<ApiResult<HelpModel>> getFaq() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/method/paas.api.admin_content.admin_content.get_admin_faqs');
      return ApiResult.success(data: HelpModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<Translation>> getTerm() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.page.page.get_page', queryParameters: {'slug': 'term'});
      return ApiResult.success(data: Translation.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<Translation>> getPolicy() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.page.page.get_page', queryParameters: {'slug': 'policy'});
      return ApiResult.success(data: Translation.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<NotificationsListModel>> getNotificationList() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/method/paas.api.notification.notification.get_notification_settings');
      return ApiResult.success(data: notificationsListModelFromJson(response.data) ?? NotificationsListModel());
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult> updateNotification(List<NotificationData>? notifications) async {
    final data = {'notifications': notifications?.map((n) => {'notification_id': n.id, 'active': n.active}).toList()};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.notification.notification.update_notification_settings', data: data);
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Image Upload (Manager/Driver) ---

  @override
  Future<ApiResult<GalleryUploadResponse>> uploadImage(String filePath, UploadType uploadType) async {
    String type = uploadType.name;
    // Map specialized types if needed
    if (uploadType == UploadType.shopsLogo) type = 'shops/logo';
    if (uploadType == UploadType.shopsBack) type = 'shops/background';
    if (uploadType == UploadType.deliveryCar) type = 'deliveryman/settings';

    final data = FormData.fromMap({'image': await MultipartFile.fromFile(filePath), 'type': type});
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/galleries', data: data);
      return ApiResult.success(data: GalleryUploadResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(List<String?> filePaths, UploadType uploadType) async {
    String type = uploadType.name;
    final data = FormData.fromMap({
      for (int i = 0; i < filePaths.length; i++) if (filePaths[i] != null) 'images[$i]': await MultipartFile.fromFile(filePaths[i]!),
      'type': type,
    });
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/galleries/store-many', data: data);
      return ApiResult.success(data: MultiGalleryUploadResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Manager Hub / AI ---

  @override
  Future<ApiResult<AiTranslationResponse>> getAiTranslation({required AiTranslationRequest model}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/ai-translations', data: model.toJson());
      return ApiResult.success(data: AiTranslationResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/v1/rest/currencies');
      return ApiResult.success(data: CurrenciesResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
