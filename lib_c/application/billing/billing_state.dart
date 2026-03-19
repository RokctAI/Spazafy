import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

part 'billing_state.freezed.dart';

enum ScanPromptType { none, found, repeat, extras, unknown, lowStock }

@freezed
class BillingState with _$BillingState {
  const factory BillingState({
    @Default([]) List<CartItem> cartItems,
    @Default(false) bool isScanning,
    String? lastScannedBarcode,
    @Default(ScanPromptType.none) ScanPromptType promptType,
    ProductData? selectedProduct,
    @Default(1) int scanCount,
    @Default(false) bool isPrinting,
    @Default(false) bool printSuccess,
    @Default(0.0) double totalAmount,
  }) = _BillingState;

  const BillingState._();
}
