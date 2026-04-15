import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/create_group_extras_response.dart';
import 'package:rokctapp/infrastructure/models/data/order_detail.dart';
    hide Stock;
import 'package:rokctapp/infrastructure/models/data/stock.dart';
import 'package:rokctapp/infrastructure/models/response/single_extras_group_response.dart';
import 'package:rokctapp/infrastructure/models/response/extras_groups_response.dart';
import 'package:rokctapp/infrastructure/models/response/products_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_product_response.dart';
import 'package:rokctapp/infrastructure/models/response/group_extras_response.dart';
import 'package:rokctapp/infrastructure/models/response/calculate_response.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';

abstract class ProductsInterface {
  Future<ApiResult<void>> deleteExtrasGroup({String? groupId});

  Future<ApiResult<SingleExtrasGroupResponse>> updateExtrasGroup({
    required String title,
    String? groupId,
  });

  Future<ApiResult<void>> deleteExtrasItem({required String extrasId});

  Future<ApiResult<CreateGroupExtrasResponse>> updateExtrasItem({
    required String extrasId,
    required String groupId,
    required String title,
  });

  Future<ApiResult<CreateGroupExtrasResponse>> createExtrasItem({
    required String groupId,
    required String title,
  });

  Future<ApiResult<SingleExtrasGroupResponse>> createExtrasGroup({
    required String title,
  });

  Future<ApiResult<CalculateResponse>> getProductsCalculation(
    List<Stock> stocks,
  );

  Future<ApiResult<GroupExtrasResponse>> getExtras({String? groupId});

  Future<ApiResult<SingleProductResponse>> updateStocks({
    required List<Stock> stocks,
    required List<String> deletedStocks,
    String? uuid,
    bool isAddon = false,
  });

  Future<ApiResult<SingleProductResponse>> updateProduct({
    required Map<String, List<String>> titlesAndDescriptions,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required bool active,
    String? qrcode,
    String? categoryId,
    String? kitchenId,
    String? unitId,
    List<String>? images,
    String? uuid,
    bool needAddons = false,
  });

  Future<ApiResult<SingleProductResponse>> updateExtras({
    required List<String> extrasIds,
    String? productUuid,
  });

  Future<ApiResult<ExtrasGroupsResponse>> getExtrasGroups({
    bool needOnlyValid = true,
  });

  Future<ApiResult<SingleProductResponse>> createProduct({
    required String title,
    required String description,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required String qrcode,
    required bool active,
    String? categoryId,
    String? kitchenId,
    String? unitId,
    List<String>? images,
    bool isAddon = false,
    String type = 'single',
    String? uid,
  });

  Future<ApiResult<SingleProductResponse>> getProductDetails(String uuid);

  Future<ApiResult<ProductsPaginateResponse>> getProducts({
    int? page,
    String? categoryId,
    String? query,
    ProductStatus? status,
    bool needAddons = false,
    bool active = false,
    String? type,
  });
}
