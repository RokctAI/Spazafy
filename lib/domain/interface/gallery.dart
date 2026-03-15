import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/services/customer/enums.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class GalleryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String file,
    UploadType uploadType,
  );

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );
}
