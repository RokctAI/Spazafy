import 'package:flutter_test/flutter_test.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:billing_app/infrastructure/repository/printer_repository.dart';
import 'package:billing_app/application/settings/printer_event.dart';
import 'package:billing_app/application/settings/printer_state.dart';
import 'package:billing_app/application/settings/printer_bloc.dart';

class MockPrinterRepository implements PrinterRepository {
  @override
  Future<void> clearPrinterData() async {}

  @override
  Future<bool> connect(String macAddress) async {
    if (macAddress == 'MAC3') {
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    }
    await Future.delayed(Duration(milliseconds: 500));
    return false;
  }

  @override
  Future<bool> disconnect() async {
    return true;
  }

  @override
  String? getSavedPrinterMac() => null;

  @override
  String? getSavedPrinterName() => null;

  @override
  Future<void> savePrinterData(String mac, String name) async {}

  @override
  Future<List<BluetoothInfo>> scanDevices() async {
    return [
      BluetoothInfo(name: 'Printer1', macAdress: 'MAC1'),
      BluetoothInfo(name: 'Printer2', macAdress: 'MAC2'),
      BluetoothInfo(name: 'Printer3', macAdress: 'MAC3'),
    ];
  }

  @override
  Future<void> testPrint(String shopName) async {}
}

void main() {
  test('PrinterBloc benchmark', () async {
    final repo = MockPrinterRepository();
    final bloc = PrinterBloc(repository: repo);

    final start = DateTime.now();
    bloc.add(RefreshPrinterEvent());

    await bloc.stream
        .firstWhere((state) => state.status == PrinterStatus.connected);
    final end = DateTime.now();

    print('Time taken: ${end.difference(start).inMilliseconds} ms');
  });
}
