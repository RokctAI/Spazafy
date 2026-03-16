import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/repositories/offline/offline_products_repository.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'billing_state.dart';

class BillingNotifier extends StateNotifier<BillingState> {
  Timer? _dismissTimer;

  BillingNotifier() : super(const BillingState());

  // ─── Scanning Logic ───

  Future<void> onBarcodeScanned(String barcode) async {
    if (state.isPrinting) return;

    // Check if it's the same as the last scanned within the prompt window
    if (state.promptType == ScanPromptType.found ||
        state.promptType == ScanPromptType.repeat) {
      if (state.lastScannedBarcode == barcode) {
        // Repeat scan
        _handleRepeatScan(barcode);
        return;
      }
    }

    // Lookup product in Hive
    final result = await productRepository.getProducts(query: barcode);

    result.when(
      success: (response) {
        final products = response.data ?? [];
        if (products.isEmpty) {
          _handleUnknownBarcode(barcode);
        } else {
          final product = products.first;
          _handleProductFound(product, barcode);
        }
      },
      failure: (error, statusCode) {
        _handleUnknownBarcode(barcode);
      },
    );
  }

  void _handleProductFound(ProductData product, String barcode) {
    // Check for extras/options
    final hasExtras =
        product.stocks?.any((s) => s.extras?.isNotEmpty ?? false) ?? false;

    if (hasExtras) {
      state = state.copyWith(
        promptType: ScanPromptType.extras,
        selectedProduct: product,
        lastScannedBarcode: barcode,
        scanCount: 1,
      );
      _cancelTimer();
    } else {
      // Check for low stock
      final stockCount = product.stock?.quantity ?? 0;
      final isLowStock = stockCount <= (product.minQty ?? 5) && stockCount > 0;

      if (isLowStock) {
        state = state.copyWith(
          promptType: ScanPromptType.lowStock,
          selectedProduct: product,
          lastScannedBarcode: barcode,
          scanCount: 1,
        );
        _cancelTimer();
      } else {
        // Normal found
        addToCart(product);
        state = state.copyWith(
          promptType: ScanPromptType.found,
          selectedProduct: product,
          lastScannedBarcode: barcode,
          scanCount: 1,
        );
        _startDismissTimer();
      }
    }
  }

  void _handleRepeatScan(String barcode) {
    if (state.selectedProduct != null) {
      addToCart(state.selectedProduct!);
      state = state.copyWith(
        promptType: ScanPromptType.repeat,
        scanCount: state.scanCount + 1,
      );
      _startDismissTimer(); // Reset timer
    }
  }

  void _handleUnknownBarcode(String barcode) {
    state = state.copyWith(
      promptType: ScanPromptType.unknown,
      lastScannedBarcode: barcode,
      selectedProduct: null,
      scanCount: 0,
    );
    _cancelTimer();
  }

  // ─── Cart Operations ───

  void addToCart(ProductData product, {int quantity = 1}) {
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> newItems;
    if (existingIndex != -1) {
      final item = state.cartItems[existingIndex];
      newItems = List<CartItem>.from(state.cartItems);
      newItems[existingIndex] = item.copyWith(
        quantity: item.quantity + quantity,
      );
    } else {
      newItems = [
        ...state.cartItems,
        CartItem(product: product, quantity: quantity),
      ];
    }

    state = state.copyWith(cartItems: newItems);
    _updateTotal();
  }

  void updateQuantity(ProductData product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
      return;
    }

    final newItems = state.cartItems.map((item) {
      if (item.product.id == product.id) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(cartItems: newItems);
    _updateTotal();
  }

  void removeFromCart(ProductData product) {
    final newItems = state.cartItems
        .where((item) => item.product.id != product.id)
        .toList();
    state = state.copyWith(cartItems: newItems);
    _updateTotal();
  }

  void clearCart() {
    state = state.copyWith(cartItems: [], totalAmount: 0.0);
  }

  // ─── Helper Methods ───

  void setScanning(bool value) {
    state = state.copyWith(isScanning: value);
  }

  void dismissPrompt() {
    state = state.copyWith(
      promptType: ScanPromptType.none,
      selectedProduct: null,
    );
    _cancelTimer();
  }

  void _startDismissTimer() {
    _cancelTimer();
    _dismissTimer = Timer(const Duration(seconds: 3), () {
      dismissPrompt();
    });
  }

  void _cancelTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
  }

  void _updateTotal() {
    final total = state.cartItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    state = state.copyWith(totalAmount: total);
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

final billingProvider = StateNotifierProvider<BillingNotifier, BillingState>((
  ref,
) {
  return BillingNotifier();
});
