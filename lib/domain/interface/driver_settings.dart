import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/mobile_translations_response.dart';
import 'package:rokctapp/infrastructure/models/response/currencies_response.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/infrastructure/models/response/driver/setting_response.dart';
import 'package:rokctapp/infrastructure/models/response/gallery_upload_response.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart' hide ApiResult;

abstract class SettingsRepository {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  );

  Future<ApiResult<CurrenciesResponse>> getCurrencies();

  Future<ApiResult<SettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();
}
