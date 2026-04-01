import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/mobile_translations_response.dart';
import 'package:rokctapp/infrastructure/models/response/global_settings_response.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart';
import 'package:rokctapp/infrastructure/models/data/take_data.dart';
import 'package:rokctapp/infrastructure/models/data/help_data.dart';
import 'package:rokctapp/infrastructure/models/data/notification_list_data.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/global_settings_response.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart';
import 'package:rokctapp/infrastructure/models/response/mobile_translations_response.dart';
import 'package:rokctapp/infrastructure/models/data/translation.dart'
    hide Translation;

abstract class SettingsRepositoryFacade {
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
}
