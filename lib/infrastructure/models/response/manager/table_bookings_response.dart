import 'package:rokctapp/dummy_types.dart';
import 'dart:convert';
import 'package:rokctapp/infrastructure/models/data/manager/table_bookings_data.dart';
// To parse this JSON data, do
//
//     final tableBookingResponse = tableBookingResponseFromJson(jsonString);

TableBookingResponse tableBookingResponseFromJson(String str) =>
    TableBookingResponse.fromJson(json.decode(str));

String tableBookingResponseToJson(TableBookingResponse data) =>
    json.encode(data.toJson());

class TableBookingResponse {
  List<TableBookingData> data;

  TableBookingResponse({required this.data});

  factory TableBookingResponse.fromJson(Map<String, dynamic> json) =>
      TableBookingResponse(
        data: List<TableBookingData>.from(
          json["data"].map((x) => TableBookingData.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
