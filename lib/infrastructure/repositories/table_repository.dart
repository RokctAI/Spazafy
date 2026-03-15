import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/domain/interface/table.dart';

class TableRepository extends TableInterface {
  String get _role => LocalStorage.getUser()?.role ?? 'seller';

  @override
  Future<ApiResult<ShopSection>> createNewSection({
    required String name,
    required num area,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/$_role/shop-sections',
        queryParameters: {
          "area": area,
          "images": [],
          "title": {LocalStorage.getLanguage()?.locale ?? 'en': name},
        },
      );
      return ApiResult.success(
        data: ShopSection.fromJson(response.data["data"]),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ShopSectionResponse>> getSection({
    int? page,
    String? query,
  }) async {
    final data = {
      if (page != null) 'page': page,
      if (query != null) 'search': query,
      'perPage': 14,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/shop-sections',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopSectionResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> createNewTable({
    required TableModel tableModel,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/$_role/tables',
        queryParameters: tableModel.toJson(),
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableResponse>> getTables({
    int? page,
    String? query,
    String? shopSectionId,
    String? type,
    DateTime? from,
    DateTime? to,
  }) async {
    from ??= DateTime.now();
    to ??= DateTime.now();
    to = to.add(const Duration(days: 1));
    final data = {
      if (page != null) 'page': page,
      'perPage': 14,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      if (query != null) 'search': query,
      'status': 'available',
      if (shopSectionId != null) "shop_section_id": shopSectionId,
      if (type != null) "date_from": TimeService.dateFormatYMDHm(from),
      if (type != null) "date_to": TimeService.dateFormatYMDHm(to),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/tables',
        queryParameters: data,
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableBookingResponse>> getTableOrders({
    int? page,
    String? id,
    String? type,
    DateTime? from,
    DateTime? to,
  }) async {
    to = to != null ? to.add(const Duration(days: 1)) : from;
    final data = {
      if (page != null) 'page': page,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      if (type != null) 'status': type,
      if (from != null) "start_from": from.toString().substring(0, 10),
      if (to != null) "start_to": to.toString().substring(0, 10),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/user-bookings',
        queryParameters: data,
      );
      return ApiResult.success(
        data: TableBookingResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableResponse>> deleteSection(String? id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.delete(
        '/api/v1/dashboard/$_role/shop-sections/delete',
        queryParameters: {"ids[0]": id},
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableResponse>> deleteTable(String? id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.delete(
        '/api/v1/dashboard/$_role/tables/delete',
        queryParameters: {"ids[0]": id},
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<List<DisableDates>>> disableDates({
    required DateTime dateTime,
    required String? id,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/disable-dates/table/$id',
        queryParameters: {
          'lang': LocalStorage.getLanguage()?.locale ?? 'en',
          "date_from": DateFormat("yyyy-MM-dd").format(dateTime),
        },
      );
      return ApiResult.success(data: disableDatesFromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<BookingsResponse>> getBookings({int? page}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/bookings',
        queryParameters: {
          'lang': LocalStorage.getLanguage()?.locale ?? 'en',
          'page': page,
          'perPage': 100,
        },
      );
      return ApiResult.success(data: BookingsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setBookings({
    String? bookingId,
    String? tableId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/$_role/user-bookings',
        data: {
          'booking_id': bookingId,
          'end_date': TimeService.dateFormatYMDHm(endDate ?? DateTime.now()),
          'start_date': TimeService.dateFormatYMDHm(
            startDate ?? DateTime.now(),
          ),
          "table_id": tableId,
        },
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<WorkingDayResponse>> getWorkingDay() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/booking/shop-working-days/${LocalStorage.getUser()?.shop?.uuid}',
        queryParameters: {'lang': LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(
        data: WorkingDayResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CloseDayResponse>> getCloseDay() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/booking/shop-closed-dates/${LocalStorage.getUser()?.shop?.uuid}',
        queryParameters: {'lang': LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(data: CloseDayResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableInfoResponse>> getTableInfo(String? id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/user-bookings/$id',
        queryParameters: {'lang': LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(data: TableInfoResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult> changeOrderStatus({
    required String status,
    required String? id,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/$_role/user-booking/status/$id',
        queryParameters: {'status': status},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TableStatisticResponse>> getStatistic({
    DateTime? from,
    DateTime? to,
  }) async {
    from ??= DateTime.now();
    to ??= DateTime.now().add(const Duration(days: 1));
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/$_role/table/statistic',
        queryParameters: {
          "date_from": TimeService.dateFormatYMDHm(from),
          "date_to": TimeService.dateFormatYMDHm(to),
        },
      );
      return ApiResult.success(
        data: TableStatisticResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
