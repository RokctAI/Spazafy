import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:rokctapp/infrastructure/models/data/local_address_data.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/response/single_address_response.dart';
import 'package:rokctapp/infrastructure/models/response/addresses_response.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/address.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:rokctapp/infrastructure/models/data/local_address_data.dart';
import 'package:rokctapp/infrastructure/models/response/addresses_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_address_response.dart';

class AddressRepository implements AddressRepositoryFacade {
  @override
  Future<ApiResult<AddressesResponse>> getUserAddresses() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.get_user_addresses',
      );
      return ApiResult.success(data: AddressesResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get user addresses failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteAddress(int addressId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.delete_user_address',
        data: {'name': addressId.toString()},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete address failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.delete_user_address',
          method: 'POST',
          payload: {'name': addressId.toString()},
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
  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.add_user_address',
        data: {'address_data': address.toJson()},
      );
      return ApiResult.success(
        data: SingleAddressResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create address failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.add_user_address',
          method: 'POST',
          payload: {'address_data': address.toJson()},
        );
        // Return dummy response for offline success
        return ApiResult.success(
          data: SingleAddressResponse(
            data: AddressNewModel(
              id: address.id,
              title: address.title,
              location: [
                address.location?.latitude,
                address.location?.longitude,
              ],
            ),
          ),
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
}
