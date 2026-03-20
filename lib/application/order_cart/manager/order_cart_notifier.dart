import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_cart_state.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

import 'dart:convert';
import 'package:rokctapp/domain/di/dependency_manager.dart';

class OrderCartNotifier extends StateNotifier<OrderCartState> {
  OrderCartNotifier() : super(const OrderCartState());

  void deleteStockFromCart({
    required Stock stock,
    Function(List<Stock>)? updateProducts,
  }) {
    List<Stock> stocks = List.from(state.stocks);
    num price = state.totalPrice;
    price -= stock.totalPrice ?? 0;
    final addons = stock.addons?.where((e) => e.active ?? false).toList() ?? [];
    for (var e in addons) {
      price -= e.product?.stock?.totalPrice ?? 0;
    }
    stocks.remove(stock);
    stocks = stocks.toSet().toList();
    state = state.copyWith(stocks: stocks, totalPrice: price);
    _persist();
    if (updateProducts != null) {
      updateProducts(stocks);
    }
  }

  void clearAll() {
    state = state.copyWith(stocks: []);
    _persist();
  }

  void addStockToCart({
    required int count,
    ProductData? product,
    Stock? stock,
    Function(List<Stock>)? updateProducts,
  }) {
    debugPrint('===> add stock to cart count $count');
    debugPrint('===> add stock to cart product ${product?.translation?.title}');
    List<Stock> stocks = List.from(state.stocks);
    int? index;
    for (int i = 0; i < stocks.length; i++) {
      if (stocks[i].id == stock?.id) {
        bool next = true;
        List<AddonData> lastAddons =
            stocks[i].addons?.where((e) => e.active ?? false).toList() ?? [];
        List<AddonData> newAddons =
            stock?.addons?.where((e) => e.active ?? false).toList() ?? [];
        for (var element in lastAddons) {
          if (!(newAddons.any((e) => e.id == element.id && e.quantity ==element.quantity) ) ) {
            next = false;
          }
        }
        if (lastAddons.isEmpty && newAddons.isEmpty) {
          index = i;
          break;
        } else if (lastAddons.length != newAddons.length) {
          index = null;
        } else if (next) {
          index = i;
          break;
        } else {
          index = null;
        }
      }
    }
    if (index != null) {
      if (count == 0) {
        stocks.removeAt(index);
      } else {
        stocks[index] = stocks[index].copyWith(cartCount: count);
      }
    } else {
      stock = stock?.copyWith(product: product, cartCount: count);
      if (stock != null) {
        stocks.insert(0, stock);
      }
    }
    stocks = stocks.toList();
    num sum = 0;
    for (final stock in stocks) {
      sum += (stock.totalPrice ?? 0) * (stock.cartCount ?? 0);
      for (AddonData addon in stock.addons ?? []) {
        if (addon.active ?? false) {
          sum +=
              (addon.product?.stock?.totalPrice ?? 0) * (addon.quantity ?? 1);
        }
      }
    }
    state = state.copyWith(stocks: stocks, totalPrice: sum);
    _persist();
    if (updateProducts != null) {
      updateProducts(stocks);
    }
  }

  Future<void> addStockByBarcode(String barcode) async {
    final result = await productsRepository.searchProducts(text: barcode);
    result.when(
      success: (data) {
        if (data.data != null && data.data!.isNotEmpty) {
          final product = data.data!.first;
          final stock = product.stock ?? (product.stocks?.isNotEmpty == true ? product.stocks!.first : null);
          if (stock != null) {
            addStockToCart(count: 1, product: product, stock: stock);
          }
        }
      },
      failure: (failure, status) {
        debugPrint('==> barcode search failure: $failure');
      },
    );
  }

  void _persist() {
    final List<Map<String, dynamic>> stocksJson = state.stocks.map((s) => s.toJson()).toList();
    appDatabase.putItem('billing_cart', 'active_cart', {'stocks': stocksJson});
  }

  Future<void> loadCart() async {
    final data = await appDatabase.getItem('billing_cart', 'active_cart');
    if (data != null && data['stocks'] != null) {
      final List<dynamic> stocksRaw = data['stocks'];
      final List<Stock> stocks = stocksRaw.map((s) => Stock.fromJson(s)).toList();
      
      num sum = 0;
      for (final stock in stocks) {
        sum += (stock.totalPrice ?? 0) * (stock.cartCount ?? 0);
        for (AddonData addon in stock.addons ?? []) {
          if (addon.active ?? false) {
            sum += (addon.product?.stock?.totalPrice ?? 0) * (addon.quantity ?? 1);
          }
        }
      }
      state = state.copyWith(stocks: stocks, totalPrice: sum);
    }
  }
}
