import 'package:venderfoodyman/infrastructure/models/customer/data/help_data.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/notification_list_data.dart';

import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/translation.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';

abstract class SettingsFacade {
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();

  Future<ApiResult<NotificationsListModel>> getNotificationList();

  Future<ApiResult<dynamic>> updateNotification(
    List<NotificationData>? notifications,
  );

  Future<ApiResult<HelpModel>> getFaq();

  Future<ApiResult<Translation>> getTerm();

  Future<ApiResult<Translation>> getPolicy();

  // Shared Upload & Currencies
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  );
  Future<ApiResult<CurrenciesResponse>> getCurrencies();

  // Manager Specific
  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );
  Future<ApiResult<AiTranslationResponse>> getAiTranslation({
    required AiTranslationRequest model,
  });
}
