import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/data/manager/bookings_data.dart';

class BookingsResponse {
  BookingsData? data;

  BookingsResponse({required this.data});

  factory BookingsResponse.fromJson(Map<String, dynamic> json) =>
      BookingsResponse(
        data: json["data"] == null ? null : BookingsData.fromJson(json["data"]),
      );
}
