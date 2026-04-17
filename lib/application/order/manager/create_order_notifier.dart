import 'package:rokctapp/infrastructure/models/data/location_data.dart';
import 'package:rokctapp/domain/interface/manager_orders.dart';
import 'package:rokctapp/infrastructure/models/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/create_order_state.dart';

import 'package:rokctapp/infrastructure/models/response/login_response.dart';

import 'package:rokctapp/infrastructure/models/models.dart' hide UserData;
import 'package:rokctapp/infrastructure/models/data/order_detail.dart' show Stock;


class CreateOrderNotifier extends StateNotifier<CreateOrderState> {
  final OrdersInterface _ordersRepository;

  CreateOrderNotifier(this._ordersRepository) : super(const CreateOrderState());

  Future<void> createOrder({
    required String deliveryType,
    UserData? user,
    required List<Stock> stocks,
    required String deliveryDate,
    required String address,
    required String? tableId,
    LocationData? location,
    required String entrance,
    required String floor,
    required String house,
    ValueChanged<int>? orderSuccess,
    Function(String)? failed,
  }) async {
    state = state.copyWith(isCreating: true);
    final response = await _ordersRepository.createOrder(
      deliveryType: deliveryType,
      user: user,
      stocks: stocks,
      deliveryTime: deliveryDate,
      address: address,
      location: location,
      tableId: tableId?.toString(),
      entrance: entrance.isEmpty ? null : entrance.trim(),
      house: house.isEmpty ? null : house.trim(),
      floor: floor.isEmpty ? null : floor.trim(),
    );
    response.when(
      success: (data) async {
        state = state.copyWith(isCreating: false);
        orderSuccess?.call(data.data?.id ?? 0);
      },
      failure: (failure, status) {
        debugPrint('===> create order fail $failure');
        failed?.call(failure.toString());
        state = state.copyWith(isCreating: false);
      },
    );
  }
}
