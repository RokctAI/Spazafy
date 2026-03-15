import '../models/printer_device.dart';

class TcpConnector {
  static final TcpConnector _instance = TcpConnector._internal();
  factory TcpConnector() => _instance;
  TcpConnector._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<List<PrinterDevice>> discover() async {
    // TODO: Implement TCP discovery logic
    return [];
  }

  Future<bool> connect(String ipAddress, {int port = 9100}) async {
    // TODO: Implement TCP connection logic
    return false;
  }

  Future<void> sendBytes(List<int> bytes) async {
    // TODO: Implement TCP byte transmission
  }
}
