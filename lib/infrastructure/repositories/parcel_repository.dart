import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/parcel_order.dart';
import 'package:rokctapp/infrastructure/models/response/parcel_calculate_response.dart';
import 'package:rokctapp/infrastructure/models/response/parcel_response.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/data/location.dart';
import 'package:rokctapp/infrastructure/models/response/transactions_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/parcel.dart';

import 'package:rokctapp/infrastructure/models/response/parcel_paginate_response.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

import 'package:rokctapp/infrastructure/models/data/refund_data.dart';

class ParcelRepository implements ParcelRepositoryFacade {
  @override
  Future<ApiResult<void>> addReview(
    dynamic orderId, {
    required double rating,
    required String comment,
  }) async {
    final data = {'rating': rating, if (comment != "") 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.parcel.parcel.add_parcel_review',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add parcel review failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.parcel.parcel.add_parcel_review',
          method: 'POST',
          payload: data,
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelTypeResponse>> getTypes() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.get_types',
        data: data,
      );
      final responseData = ParcelTypeResponse.fromJson(response.data);

      // Persistence: Cache types
      await appDatabase.putItem(
        'settings',
        'parcel_types',
        responseData.toJson(),
      );

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');

      // Fallback
      try {
        final localData = await appDatabase.getItem('settings', 'parcel_types');
        if (localData != null) {
          return ApiResult.success(
            data: ParcelTypeResponse.fromJson(localData),
          );
        }
      } catch (localError) {
        debugPrint('==> local parcel types fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelCalculateResponse>> getCalculate({
    required String typeId,
    required LocationModel from,
    required LocationModel to,
  }) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'address_from[latitude]': from.latitude,
      'address_from[longitude]': from.longitude,
      'address_to[latitude]': to.latitude,
      'address_to[longitude]': to.longitude,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.calculate_price',
        data: data,
      );
      return ApiResult.success(
        data: ParcelCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> orderParcel({
    required String typeId,
    required LocationModel from,
    required String fromTitle,
    required LocationModel to,
    required String toTitle,
    required String time,
    required String note,
    required String phoneFrom,
    required String phoneTo,
    required String usernameTo,
    required String floorTo,
    required String floorFrom,
    required String houseFrom,
    required String houseTo,
    required String value,
    required String comment,
    required String instruction,
    required bool notify,
    required String usernameFrom,
  }) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      "address_from": {
        "address": fromTitle,
        "latitude": from.latitude,
        "longitude": from.longitude,
        if (floorFrom.isNotEmpty) 'stage': floorFrom,
        if (houseFrom.isNotEmpty) 'house': houseFrom,
      },
      "address_to": {
        "address": toTitle,
        "latitude": to.latitude,
        "longitude": to.longitude,
        if (floorTo.isNotEmpty) 'stage': floorTo,
        if (houseTo.isNotEmpty) 'house': houseTo,
      },
      'rate': LocalStorage.getSelectedCurrency()?.rate,
      'delivery_date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'delivery_time': time,
      if (comment.isNotEmpty) 'note': comment,
      if (instruction.isNotEmpty) 'instruction': instruction,
      if (note.isNotEmpty) 'description': note,
      if (value.isNotEmpty) 'qr_value': value,
      'phone_from': phoneFrom,
      'phone_to': phoneTo,
      'notify': notify ? 1 : 0,
      'username_from': usernameFrom,
      'username_to': usernameTo,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.create_parcel_order',
        data: {'order_data': data},
      );
      return ApiResult.success(data: res.data["data"]["id"]);
    } catch (e) {
      debugPrint('==> get parcel order failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.parcel.parcel.create_parcel_order',
          method: 'POST',
          payload: {'order_data': data},
        );
        // Return dummy success ID
        return ApiResult.success(
          data: 'OFFLINE-PARCEL-${DateTime.now().millisecondsSinceEpoch}',
        );
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelPaginateResponse>> getActiveParcel(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'page': page,
      'statuses[0]': "new",
      "statuses[1]": "accepted",
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "order_statuses": true,
      "perPage": 10,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      // Status filtering logic as implemented in previous session
      if (data['statuses[0]'] != null) {
        data['status'] = [
          data['statuses[0]'],
          data['statuses[1]'],
          data['statuses[2]'],
          data['statuses[3]'],
        ];
        data.removeWhere((key, value) => key.startsWith('statuses'));
      }
      final response = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.get_parcel_orders',
        data: data,
      );
      final responseData = ParcelPaginateResponse.fromJson(response.data);

      // Persistence: Cache active parcels (only page 1 for simplicity)
      if (page == 1) {
        await appDatabase.putItem(
          'settings',
          'active_parcels',
          responseData.toJson(),
        );
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get open parcel failure: $e');

      // Fallback (page 1 only)
      if (page == 1) {
        try {
          final localData = await appDatabase.getItem(
            'settings',
            'active_parcels',
          );
          if (localData != null) {
            return ApiResult.success(
              data: ParcelPaginateResponse.fromJson(localData),
            );
          }
        } catch (localError) {
          debugPrint('==> local active parcels fallback failure: $localError');
        }
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelPaginateResponse>> getHistoryParcel(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'statuses[0]': "delivered",
      "statuses[1]": "canceled",
      "order_statuses": true,
      "perPage": 10,
      "page": page,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      if (data['statuses[0]'] != null) {
        data['status'] = [data['statuses[0]'], data['statuses[1]']];
        data.removeWhere((key, value) => key.startsWith('statuses'));
      }
      final response = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.get_parcel_orders',
        data: data,
      );
      final responseData = ParcelPaginateResponse.fromJson(response.data);

      // Persistence: Cache history parcels
      if (page == 1) {
        await appDatabase.putItem(
          'settings',
          'history_parcels',
          responseData.toJson(),
        );
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get canceled parcel failure: $e');

      // Fallback
      if (page == 1) {
        try {
          final localData = await appDatabase.getItem(
            'settings',
            'history_parcels',
          );
          if (localData != null) {
            return ApiResult.success(
              data: ParcelPaginateResponse.fromJson(localData),
            );
          }
        } catch (localError) {
          debugPrint('==> local history parcels fallback failure: $localError');
        }
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelOrder>> getSingleParcel(String orderId) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.parcel.parcel.get_user_parcel_order',
        data: {'name': orderId},
      );
      return ApiResult.success(
        data: ParcelOrder.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get single parcel failure: $e');

      // Sync Queue check: if the orderId is an offline ID, return the queued request payload or a placeholder
      if (orderId.startsWith('OFFLINE-PARCEL-')) {
        return const ApiResult.failure(
          error: 'Order is pending synchronization...',
          statusCode: 202, // Accepted/Pending
        );
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> process(String orderId, String name) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      var res = await client.post(
        '/api/v1/method/paas.api.payment.payment.create_transaction',
        data: {'parcel_id': orderId, 'payment_sys_id': name},
      );
      return ApiResult.success(data: res.data["data"]["data"]["url"]);
    } catch (e) {
      debugPrint('==> add order review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateParcel(
    dynamic parcelId,
    String status,
  ) async {
    return const ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<void>> addReviewParcel(
    dynamic orderId, {
    required double rating,
    required String comment,
  }) async {
    return const ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<ParcelOrder>> setParcel(String parcelId) async {
    return ApiResult.success(data: ParcelOrder());
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.payment.payment.create_transaction',
        data: {...data, 'parcel_id': orderId},
      );
      return ApiResult.success(
        data: TransactionsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create transaction failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.payment.payment.create_transaction',
          method: 'POST',
          payload: {...data, 'parcel_id': orderId},
        );
        return ApiResult.success(data: TransactionsResponse());
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
