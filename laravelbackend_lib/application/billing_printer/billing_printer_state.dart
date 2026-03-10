import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

part 'billing_printer_state.freezed.dart';

enum PrinterStatus {
  initial,
  scanning,
  scanSuccess,
  scanFailure,
  connecting,
  connected,
  connectionFailure,
  disconnected,
  testPrinting,
}

@freezed
class BillingPrinterState with _$BillingPrinterState {
  const factory BillingPrinterState({
    @Default(PrinterStatus.initial) PrinterStatus status,
    @Default([]) List<BluetoothInfo> devices,
    String? connectedMac,
    String? connectedName,
    String? errorMessage,
  }) = _BillingPrinterState;

  const BillingPrinterState._();
}
