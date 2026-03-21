import 'package:flutter/material.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/domain/interface/cart.dart';
import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

import 'dart:convert';
import 'package:rokctapp/infrastructure/models/request/cart_request.dart';

class CartRepository implements CartRepositoryFacade {
  @override
  Future<ApiResult<CartModel>> getCart(String shopId) async {
    CartModel? cart;
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.cart.cart.get_cart',
        queryParameters: {'shop_id': shopId},
      );
      cart = CartModel.fromJson(response.data);

      // Persistence: Cache the cart details
      await appDatabase.putItem('billing_cart', shopId, cart.toJson());
    } catch (e) {
      debugPrint('==> getCart failure: $e');

      // Fallback to local cache
      try {
        final localCart = await appDatabase.getItem('billing_cart', shopId);
        if (localCart != null) {
          cart = CartModel.fromJson(localCart);
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }
    }

    // Merge logic: If we have a cart (online or cached), merge pending sync requests
    if (cart != null) {
      try {
        // Handle removals/deletions
        final pendingRemoveRequests = await appDatabase.getSyncRequestsByMethod(
          '/api/v1/method/paas.api.cart.cart.remove_product_cart',
        );
        final pendingDeleteRequests = await appDatabase.getSyncRequestsByMethod(
          '/api/v1/method/paas.api.cart.cart.delete_cart',
        );

        // If a total cart deletion is pending, the cart is effectively null
        for (final request in pendingDeleteRequests) {
          final requestData = jsonDecode(request.data);
          if (requestData['cart_id'] == cart.id.toString()) {
            return ApiResult.failure(
              error: "Cart is being deleted",
              statusCode: 404,
            );
          }
        }

        final List<CartDetail> details = List.from(
          cart.data?.cartDetails ?? [],
        );

        // Process additions
        for (final request in pendingAddRequests) {
          final requestData = jsonDecode(request.data);
          if (requestData['shop_id'] == shopId) {
            final String itemCode = requestData['item_code'];
            final int qty = requestData['qty'];
            bool found = false;
            for (int i = 0; i < details.length; i++) {
              if (details[i].itemCode == itemCode) {
                details[i] = details[i].copyWith(
                  qty: (details[i].qty ?? 0) + qty,
                );
                found = true;
                break;
              }
            }
            if (!found) {
              details.add(CartDetail(itemCode: itemCode, qty: qty));
            }
          }
        }

        // Process removals
        for (final request in pendingRemoveRequests) {
          final requestData = jsonDecode(request.data);
          final String cartDetailId = requestData['cart_detail_id'];
          details.removeWhere(
            (element) => element.id.toString() == cartDetailId,
          );
        }

        cart = cart.copyWith(data: cart.data?.copyWith(cartDetails: details));
      } catch (mergeError) {
        debugPrint('==> sync merge failure: $mergeError');
      }
      return ApiResult.success(data: cart);
    }

    return ApiResult.failure(
      error: "Could not retrieve cart data",
      statusCode: 404,
    );
  }

  Future<ApiResult<CartModel>> addToCart({
    required String itemCode,
    required int qty,
    required String shopId,
  }) async {
    return insertCart(
      cart: CartRequest(productId: itemCode, quantity: qty, shopId: shopId),
    );
  }

  @override
  Future<ApiResult<CartModel>> getCartInGroup(
    String? cartId,
    String? shopId,
    String? cartUuid,
  ) async {
    final params = {
      if (cartId != null) 'cart_id': cartId,
      if (shopId != null) 'shop_id': shopId,
      if (cartUuid != null) 'cart_uuid': cartUuid,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.cart.cart.get_cart_in_group',
        queryParameters: params,
      );
      return ApiResult.success(data: CartModel.fromJson(response.data));
    } catch (e) {
      debugPrint('==> getCartInGroup failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> startGroupOrder({required String cartId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.start_group_order',
        data: {'cart_id': cartId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> startGroupOrder failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> changeStatus({
    required String? userUuid,
    required String? cartId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.cart.cart.change_status',
        data: {'user_uuid': userUuid, 'cart_id': cartId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> changeStatus failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CartModel>> deleteCart({required String cartId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.cart.cart.delete_cart',
        data: {'cart_id': cartId},
      );
      final responseData = CartModel.fromJson(response.data);
      // Persistence: Remove entry from local cache
      final String? shopId = responseData.data?.shopId?.toString();
      if (shopId != null) {
        await appDatabase.deleteItem('billing_cart', shopId);
      }
      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> deleteCart failure: $e');

      // Persistence: Queue the deletion
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.cart.cart.delete_cart',
          method: 'POST',
          payload: {'cart_id': cartId},
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> deleteCart sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteUser({
    required String cartId,
    required String userId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.cart.cart.delete_user',
        data: {'cart_id': cartId, 'user_id': userId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> deleteUser failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CartModel>> removeProductCart({
    required String cartDetailId,
    List<String>? listOfId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.cart.cart.remove_product_cart',
        data: {'cart_detail_id': cartDetailId},
      );
      final responseData = CartModel.fromJson(response.data);
      // Persistence: Cache result
      final String? shopId = responseData.data?.shopId?.toString();
      if (shopId != null) {
        await appDatabase.putItem(
          'billing_cart',
          shopId,
          responseData.toJson(),
        );
      }
      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> removeProductCart failure: $e');

      // Persistence: Queue the removal
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.cart.cart.remove_product_cart',
          method: 'POST',
          payload: {'cart_detail_id': cartDetailId},
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> removeProductCart sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CartModel>> createAndCart({
    required CartRequest cart,
  }) async {
    return insertCart(cart: cart);
  }

  @override
  Future<ApiResult<CartModel>> insertCart({required CartRequest cart}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final params = cart.toJson();
      // Ensure specific keys are used for the add_to_cart endpoint if needed
      if (cart.productId != null) params['item_code'] = cart.productId;
      if (cart.quantity != null) params['qty'] = cart.quantity;

      if (cart.carts != null) {
        params['addons'] = jsonEncode(cart.toJsonCart());
      }
      final response = await client.post(
        '/api/v1/method/paas.api.cart.cart.add_to_cart',
        data: params,
      );
      final responseData = CartModel.fromJson(response.data);
      // Persistence: Cache the cart details
      final String? shopId = responseData.data?.shopId?.toString();
      if (shopId != null) {
        await appDatabase.putItem(
          'billing_cart',
          shopId,
          responseData.toJson(),
        );
      }
      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> insertCart failure: $e');

      // Persistence: If network fails, queue the request for later
      try {
        final params = cart.toJson();
        if (cart.productId != null) params['item_code'] = cart.productId;
        if (cart.quantity != null) params['qty'] = cart.quantity;
        if (cart.carts != null) {
          params['addons'] = jsonEncode(cart.toJsonCart());
        }

        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.cart.cart.add_to_cart',
          method: 'POST',
          payload: params,
        );

        // Return a dummy success to keep UI flow moving (it will sync later)
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
  Future<ApiResult<CartModel>> insertCartWithGroup({
    required CartRequest cart,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.add_to_cart_group',
        data: cart.toJson(),
      );
      final responseData = CartModel.fromJson(response.data);
      // Persistence: Cache the cart details
      final String? shopId = responseData.data?.shopId?.toString();
      if (shopId != null) {
        await appDatabase.putItem(
          'billing_cart',
          shopId,
          responseData.toJson(),
        );
      }
      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> insertCartWithGroup failure: $e');

      // Persistence: If network fails, queue the request for later
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.cart.cart.insert_cart',
          method: 'POST',
          payload: cart.toJson(),
        );

        // Return a dummy success to keep UI flow moving (it will sync later)
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
  Future<ApiResult<CartModel>> createCart({required CartRequest cart}) async {
    if (cart.shopId != null) {
      return getCart(cart.shopId!);
    }
    return ApiResult.failure(error: "Shop ID is required", statusCode: 400);
  }
}







