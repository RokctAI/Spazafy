import 'package:rokctapp/infrastructure/models/response/multi_gallery_upload_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/gallery_upload_response.dart';

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
