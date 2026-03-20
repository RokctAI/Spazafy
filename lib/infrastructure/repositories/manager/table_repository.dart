import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/domain/interface/manager/table.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

class TableRepository extends TableInterface {
  @override
  Future<ApiResult<ShopSection>> createNewSection({
    required String name,
    required num area,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_operations.seller_operations.create_seller_section',
        data: {
          "area": area,
          "images": [],
          "title": {LocalStorage.getLanguage()?.locale ?? 'en': name},
        },
      );
      return ApiResult.success(
        data: ShopSection.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get createNewSection failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_seller_sections',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopSectionResponse.fromJson(response.data),
        // data: TableResponse.fromJson(mapData),
      );
    } catch (e) {
      debugPrint('==> get getSection failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> createNewTable({
    required TableModel tableModel,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_operations.seller_operations.create_seller_table',
        data: tableModel.toJson(),
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> get createNewTable failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
    from ??= from ?? DateTime.now();
    to ??= to ?? DateTime.now();
    to = to.add(const Duration(days: 1));
    final data = {
      if (page != null) 'page': page,
      'perPage': 14,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      if (query != null) 'search': query,
      'status': TrKeys.available,
      if (shopSectionId != null) "shop_section_id": shopSectionId,
      if (type != null) "date_from": TimeService.dateFormatYMDHm(from),
      if (type != null) "date_to": TimeService.dateFormatYMDHm(to),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_seller_tables',
        queryParameters: data,
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get getTableInfo failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
      if (from != null)
        "start_from": from.toString().substring(
          0,
          from.toString().indexOf(" "),
        ),
      if (to != null)
        "start_to": to.toString().substring(0, to.toString().indexOf(" ")),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_seller_bookings',
        queryParameters: data,
      );
      return ApiResult.success(
        data: TableBookingResponse.fromJson(response.data),
        // data: TableResponse.fromJson(mapData),
      );
    } catch (e, s) {
      debugPrint('==> get getTableOrders failure: $e,$s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TableResponse>> deleteSection(String id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_operations.seller_operations.delete_seller_sections',
        data: {"ids": [id]},
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get deleteSection failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TableResponse>> deleteTable(String id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_operations.seller_operations.delete_seller_tables',
        data: {"ids": [id]},
      );
      return ApiResult.success(data: TableResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get deleteTable failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_table_disable_dates',
        queryParameters: {
          'lang': LocalStorage.getLanguage()?.locale ?? 'en',
          "date_from": DateFormat("yyyy-MM-dd").format(dateTime),
          "table_id": id,
        },
      );
      return ApiResult.success(data: disableDatesFromJson(response.data));
    } catch (e) {
      debugPrint('==> get disableDates failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BookingsResponse>> getBookings({int? page}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_active_bookings',
        queryParameters: {
          'lang': LocalStorage.getLanguage()?.locale ?? 'en',
          'page': page,
          'perPage': 100,
        },
      );
      return ApiResult.success(data: BookingsResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get getBookings failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
        '/api/v1/method/paas.api.seller_operations.seller_operations.create_seller_booking',
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
      debugPrint('==> get setBookings failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WorkingDayResponse>> getWorkingDay() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_booking_working_days',
        queryParameters: {'lang': LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(
        data: WorkingDayResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get getWorkingDay failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CloseDayResponse>> getCloseDay() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_booking_closed_days',
        queryParameters: {'lang': LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(data: CloseDayResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> getCloseDay failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TableInfoResponse>> getTableInfo(String id) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_booking_details',
        queryParameters: {
          'lang': LocalStorage.getLanguage()?.locale ?? 'en',
          'id': id,
        },
      );
      return ApiResult.success(data: TableInfoResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> getTableInfo failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> changeOrderStatus({
    required String status,
    required String id,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_operations.seller_operations.update_booking_status',
        data: {'status': status, 'id': id},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> changeOrderStatus failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TableStatisticResponse>> getStatistic({
    DateTime? from,
    DateTime? to,
  }) async {
    from ??= from ?? DateTime.now();
    to ??= to ?? DateTime.now();
    to = to.add(const Duration(days: 1));

    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_report.seller_report.get_table_report',
        queryParameters: {
          "date_from": TimeService.dateFormatYMDHm(from),
          "date_to": TimeService.dateFormatYMDHm(to),
        },
      );
      return ApiResult.success(
        data: TableStatisticResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get statistic failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
