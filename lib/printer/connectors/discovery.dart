import 'package:rokctapp/printer/models/data/printer_device.dart';
import 'package:rokctapp/printer/connectors/bluetooth.dart';
import 'package:rokctapp/printer/connectors/tcp.dart';
import 'package:rokctapp/printer/connectors/usb.dart';

class PrinterDiscovery {
  static final PrinterDiscovery _instance = PrinterDiscovery._internal();
  factory PrinterDiscovery() => _instance;
  PrinterDiscovery._internal();

  final BluetoothConnector _bluetooth = BluetoothConnector();
  final TcpConnector _tcp = TcpConnector();
  final UsbConnector _usb = UsbConnector();

  Future<List<PrinterDevice>> discoverAll() async {
    final List<PrinterDevice> devices = [];

    // Scan all transports in parallel
    final results = await Future.wait([
      _bluetooth.getBondedDevices(),
      _tcp.discover(),
      _usb.getDevices(),
    ]);

    for (var list in results) {
      devices.addAll(list);
    }

    return devices;
  }
}
