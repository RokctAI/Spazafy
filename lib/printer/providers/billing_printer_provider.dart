import 'package:rokctapp/printer/printer_manager.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/printer/printer.dart';
import 'billing_printer_state.dart';

class BillingPrinterNotifier extends StateNotifier<BillingPrinterState> {
  final PrinterManager _printerManager = PrinterManager();

  BillingPrinterNotifier() : super(const BillingPrinterState()) {
    init();
  }

  void init() {
    final mac = LocalStorage.getPrinterMac();
    final name = LocalStorage.getPrinterName();
    state = state.copyWith(
      status: PrinterStatus.initial,
      connectedMac: mac,
      connectedName: name,
    );
  }

  Future<void> scanPrinters() async {
    state = state.copyWith(status: PrinterStatus.scanning, errorMessage: null);
    try {
      if (await _printerManager.checkPermission()) {
        final devices = await _printerManager.discoverPrinters();
        state = state.copyWith(
          status: PrinterStatus.scanSuccess,
          devices: devices,
        );
      } else {
        state = state.copyWith(
          status: PrinterStatus.scanFailure,
          errorMessage: 'Bluetooth permission denied',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PrinterStatus.scanFailure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> connect(String mac, String name) async {
    state = state.copyWith(
      status: PrinterStatus.connecting,
      errorMessage: null,
    );
    final response = await _printerManager.connect(mac);
    if (response.isSuccess) {
      LocalStorage.setPrinterMac(mac);
      LocalStorage.setPrinterName(name);
      state = state.copyWith(
        status: PrinterStatus.connected,
        connectedMac: mac,
        connectedName: name,
      );
    } else {
      state = state.copyWith(
        status: PrinterStatus.connectionFailure,
        errorMessage: response.message,
      );
    }
  }

  Future<void> disconnect() async {
    final response = await _printerManager.disconnect();
    if (response.isSuccess) {
      LocalStorage.removePrinterMac();
      LocalStorage.removePrinterName();
      state = state.copyWith(
        status: PrinterStatus.disconnected,
        connectedMac: null,
        connectedName: null,
      );
    }
  }

  Future<void> testPrint(String shopName) async {
    if (!_printerManager.isConnected) {
      state = state.copyWith(
        status: PrinterStatus.connectionFailure,
        errorMessage: 'Printer not connected',
      );
      return;
    }
    state = state.copyWith(status: PrinterStatus.testPrinting);
    await _printerManager.printText(
      "Test Print\n\n$shopName\n\n----------------\n\n",
    );
    state = state.copyWith(status: PrinterStatus.connected);
  }

  Future<void> printReceipt({
    required String shopName,
    required String address1,
    required String address2,
    required String phone,
    required List<Map<String, dynamic>> items,
    required double total,
    required String footer,
  }) async {
    if (!_printerManager.isConnected) return;

    await _printerManager.printReceipt(
      PrintReceiptRequest(
        shopName: shopName,
        address1: address1,
        address2: address2,
        phone: phone,
        items: items,
        total: total,
        footer: footer,
      ),
    );
  }
}

final billingPrinterProvider =
    StateNotifierProvider<BillingPrinterNotifier, BillingPrinterState>((ref) {
      return BillingPrinterNotifier();
    });
