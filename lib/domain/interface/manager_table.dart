import 'package:rokctapp/infrastructure/models/response/manager/close_day_response.dart';
import 'package:rokctapp/infrastructure/models/data/manager/table_model.dart';
import 'package:rokctapp/infrastructure/models/data/manager/disable_dates.dart';
import 'package:rokctapp/infrastructure/models/response/manager/table_bookings_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/working_day_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/shop_section_response.dart';
import 'package:rokctapp/infrastructure/models/data/manager/table_data.dart';
import 'package:rokctapp/infrastructure/models/response/manager/table_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/bookings_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/table_info_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/table_statistic_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

abstract class TableInterface {
  Future<ApiResult<ShopSection>> createNewSection({
    required String name,
    required num area,
  });

  Future<ApiResult<ShopSectionResponse>> getSection({int? page, String? query});

  Future<ApiResult<dynamic>> createNewTable({required TableModel tableModel});

  Future<ApiResult<TableResponse>> getTables({
    int? page,
    String? query,
    String? shopSectionId,
    String? type,
    DateTime? from,
    DateTime? to,
  });

  Future<ApiResult<TableBookingResponse>> getTableOrders({
    int? page,
    String? id,
    String? type,
    DateTime? from,
    DateTime? to,
  });

  Future<ApiResult<TableInfoResponse>> getTableInfo(String id);

  Future<ApiResult<TableResponse>> deleteSection(String id);

  Future<ApiResult<TableResponse>> deleteTable(String id);

  Future<ApiResult<List<DisableDates>>> disableDates({
    required DateTime dateTime,
    required String? id,
  });

  Future<ApiResult<BookingsResponse>> getBookings({int? page});

  Future<ApiResult<dynamic>> setBookings({
    String? bookingId,
    String? tableId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ApiResult<WorkingDayResponse>> getWorkingDay();

  Future<ApiResult<CloseDayResponse>> getCloseDay();

  Future<ApiResult<dynamic>> changeOrderStatus({
    required String status,
    required String id,
  });

  Future<ApiResult<TableStatisticResponse>> getStatistic({
    DateTime? from,
    DateTime? to,
  });
}
