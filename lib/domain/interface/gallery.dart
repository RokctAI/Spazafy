import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class GalleryRepositoryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String file,
    UploadType uploadType,
  );

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );
}
