import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

part 'parcel_state.freezed.dart';

@freezed
class ParcelState with _$ParcelState {
  const factory ParcelState({
    // Common
    @Default(false) bool isLoading,

    // Customer specific
    @Default(false) bool isButtonLoading,
    @Default(false) bool isMapLoading,
    @Default(false) bool error,
    @Default(null) LocationModel? locationFrom,
    @Default(null) LocationModel? locationTo,
    @Default(null) String? addressTo,
    @Default(null) String? addressFrom,
    @Default(null) TimeOfDay? time,
    @Default(null) ParcelCalculateResponse? calculate,
    @Default([]) List<TypeModel?> types,
    @Default(0) int selectType,
    @Default(false) bool expand,
    @Default(false) bool anonymous,
    @Default(null) ParcelOrder? parcel,
    @Default(null) PaymentData? selectPayment,
    @Default({}) Map<MarkerId, Marker> markers,
    @Default([]) List<LatLng> polylineCoordinates,

    // Driver specific
    @Default(false) bool isActiveLoading,
    @Default(false) bool isAvailableLoading,
    @Default(false) bool isHistoryLoading,
    @Default(false) bool paymentType,
    @Default(null) ParcelOrder? order,
    @Default([]) List<ParcelOrder> activeOrders,
    @Default([]) List<ParcelOrder> availableOrders,
    @Default([]) List<ParcelOrder> historyOrders,
    @Default(0) num totalActiveOrder,
    @Default(0) int deliveryTime,
    @Default(0) int deliveryType,
  }) = _ParcelState;

  const ParcelState._();
}
