import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class BlogsFacade {
  Future<ApiResult<BlogsPaginateResponse>> getBlogs(int page, String type);

  Future<ApiResult<BlogDetailsResponse>> getBlogDetails(String uuid);
}
