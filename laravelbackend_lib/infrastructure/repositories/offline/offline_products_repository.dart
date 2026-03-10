import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/domain/interface/products.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/hive_database.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';

/// Offline-first implementation of [ProductsInterface].
/// All data reads/writes go through Hive.
class OfflineProductsRepository implements ProductsInterface {
  @override
  Future<ApiResult<ProductsPaginateResponse>> getProducts({
    int? page,
    int? categoryId,
    String? query,
    ProductStatus? status,
    bool needAddons = false,
    bool active = false,
    String? type,
  }) async {
    try {
      final allJson = HiveDatabase.getAll(HiveDatabase.productBox);
      List<ProductData> products =
          allJson.map((json) => ProductData.fromJson(json)).toList();

      // Filter by category if requested
      if (categoryId != null) {
        products =
            products.where((p) => p.categoryId == categoryId).toList();
      }

      // Filter by search query
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        products = products.where((p) {
          final title = p.translation?.title?.toLowerCase() ?? '';
          final barCode = p.barCode?.toLowerCase() ?? '';
          return title.contains(q) || barCode.contains(q);
        }).toList();
      }

      // Filter by status
      if (status != null) {
        products =
            products.where((p) => p.status == status.name).toList();
      }

      // Filter by type
      if (type != null) {
        products = products.where((p) => p.type == type).toList();
      }

      // Filter by active
      if (active) {
        products = products.where((p) => p.active == true).toList();
      }

      return ApiResult.success(
        data: ProductsPaginateResponse(data: products),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(
    String uuid,
  ) async {
    try {
      final json = HiveDatabase.getItem(HiveDatabase.productBox, uuid);
      if (json == null) {
        return const ApiResult.failure(error: 'Product not found');
      }
      return ApiResult.success(
        data: SingleProductResponse(data: ProductData.fromJson(json)),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> createProduct({
    required String title,
    required String description,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required String qrcode,
    required bool active,
    int? categoryId,
    int? kitchenId,
    int? unitId,
    List<String>? images,
    bool isAddon = false,
    String type = 'single',
    String? uid,
  }) async {
    try {
      final uuid = uid ?? DateTime.now().millisecondsSinceEpoch.toString();
      final productJson = <String, dynamic>{
        'id': DateTime.now().millisecondsSinceEpoch,
        'uuid': uuid,
        'bar_code': qrcode,
        'tax': num.tryParse(tax),
        'interval': num.tryParse(interval),
        'min_qty': int.tryParse(minQty),
        'max_qty': int.tryParse(maxQty),
        'status': 'published',
        'type': type,
        'active': active,
        'addon': isAddon,
        'category_id': categoryId,
        'unit_id': unitId,
        'img': images?.isNotEmpty == true ? images!.first : null,
        'translation': {
          'title': title,
          'description': description,
          'locale': 'en',
        },
        'translations': [
          {
            'title': title,
            'description': description,
            'locale': 'en',
          },
        ],
      };

      await HiveDatabase.putItem(
        HiveDatabase.productBox,
        uuid,
        productJson,
      );

      return ApiResult.success(
        data: SingleProductResponse(
          data: ProductData.fromJson(productJson),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateProduct({
    required Map<String, List<String>> titlesAndDescriptions,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required bool active,
    String? qrcode,
    int? categoryId,
    int? kitchenId,
    int? unitId,
    List<String>? images,
    String? uuid,
    bool needAddons = false,
  }) async {
    try {
      if (uuid == null) {
        return const ApiResult.failure(error: 'UUID required for update');
      }

      final existing = HiveDatabase.getItem(HiveDatabase.productBox, uuid);
      if (existing == null) {
        return const ApiResult.failure(error: 'Product not found');
      }

      // Update fields
      existing['tax'] = num.tryParse(tax);
      existing['interval'] = num.tryParse(interval);
      existing['min_qty'] = int.tryParse(minQty);
      existing['max_qty'] = int.tryParse(maxQty);
      existing['active'] = active;
      existing['bar_code'] = qrcode ?? existing['bar_code'];
      existing['category_id'] = categoryId ?? existing['category_id'];
      existing['unit_id'] = unitId ?? existing['unit_id'];
      if (images != null && images.isNotEmpty) {
        existing['img'] = images.first;
      }

      // Update translations
      if (titlesAndDescriptions.isNotEmpty) {
        final translations = <Map<String, dynamic>>[];
        titlesAndDescriptions.forEach((locale, values) {
          translations.add({
            'locale': locale,
            'title': values.isNotEmpty ? values[0] : '',
            'description': values.length > 1 ? values[1] : '',
          });
        });
        existing['translations'] = translations;
        if (translations.isNotEmpty) {
          existing['translation'] = translations.first;
        }
      }

      await HiveDatabase.putItem(HiveDatabase.productBox, uuid, existing);

      return ApiResult.success(
        data: SingleProductResponse(
          data: ProductData.fromJson(existing),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateStocks({
    required List<Stock> stocks,
    required List<int> deletedStocks,
    String? uuid,
    bool isAddon = false,
  }) async {
    try {
      if (uuid == null) {
        return const ApiResult.failure(error: 'UUID required');
      }
      final existing = HiveDatabase.getItem(HiveDatabase.productBox, uuid);
      if (existing == null) {
        return const ApiResult.failure(error: 'Product not found');
      }

      existing['stocks'] = stocks.map((s) => s.toJson()).toList();
      await HiveDatabase.putItem(HiveDatabase.productBox, uuid, existing);

      return ApiResult.success(
        data: SingleProductResponse(
          data: ProductData.fromJson(existing),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateExtras({
    required List<int> extrasIds,
    String? productUuid,
  }) async {
    // Offline: extras not fully supported yet
    return const ApiResult.failure(
      error: 'Extras update not supported offline',
    );
  }

  @override
  Future<ApiResult<ExtrasGroupsResponse>> getExtrasGroups({
    bool needOnlyValid = true,
  }) async {
    return const ApiResult.failure(
      error: 'Not available offline',
    );
  }

  @override
  Future<ApiResult<GroupExtrasResponse>> getExtras({int? groupId}) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<CalculateResponse>> getProductsCalculation(
    List<Stock> stocks,
  ) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<SingleExtrasGroupResponse>> createExtrasGroup({
    required String title,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<SingleExtrasGroupResponse>> updateExtrasGroup({
    required String title,
    int? groupId,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<void>> deleteExtrasGroup({int? groupId}) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<CreateGroupExtrasResponse>> createExtrasItem({
    required int groupId,
    required String title,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<CreateGroupExtrasResponse>> updateExtrasItem({
    required int extrasId,
    required int groupId,
    required String title,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<void>> deleteExtrasItem({required int extrasId}) async {
    return const ApiResult.failure(error: 'Not available offline');
  }
}
