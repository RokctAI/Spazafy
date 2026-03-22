import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'connectors/bluetooth.dart';
import 'connectors/discovery.dart';
import 'package:intl/intl.dart';

class PrinterManager {
  static final PrinterManager _instance = PrinterManager._internal();
  factory PrinterManager() => _instance;
  PrinterManager._internal();

  final BluetoothConnector _bluetooth = BluetoothConnector();
  final PrinterDiscovery _discovery = PrinterDiscovery();

  bool get isConnected => _bluetooth.isConnected;

  Future<bool> checkPermission() => _bluetooth.checkPermission();

  Future<List<PrinterDevice>> discoverPrinters() => _discovery.discoverAll();

  Future<PrinterResponse> connect(String macAddress) async {
    final success = await _bluetooth.connect(macAddress);
    return success
        ? PrinterResponse.success()
        : PrinterResponse.failure('Failed to connect to Bluetooth printer');
  }

  Future<PrinterResponse> disconnect() async {
    final success = await _bluetooth.disconnect();
    return success
        ? PrinterResponse.success()
        : PrinterResponse.failure('Failed to disconnect');
  }

  Future<PrinterResponse> printText(String text) async {
    if (!isConnected) return PrinterResponse.failure('Printer not connected');
    await _bluetooth.sendBytes(text.codeUnits);
    return PrinterResponse.success();
  }

  Future<PrinterResponse> printReceipt(PrintReceiptRequest request) async {
    if (!isConnected) return PrinterResponse.failure('Printer not connected');

    List<int> bytes = [];
    bytes += EscPos.init;

    // Shop Name
    bytes += EscPos.alignCenter;
    bytes += EscPos.boldOn;
    bytes += EscPos.textLarge;
    bytes += _textToBytes(request.shopName);
    bytes += EscPos.lineFeed;

    // Address & Phone
    bytes += EscPos.textNormal;
    bytes += EscPos.boldOff;
    if (request.address1.isNotEmpty) {
      bytes += _textToBytes(request.address1);
      bytes += EscPos.lineFeed;
    }
    if (request.address2.isNotEmpty) {
      bytes += _textToBytes(request.address2);
      bytes += EscPos.lineFeed;
    }
    bytes += _textToBytes(request.phone);
    bytes += EscPos.lineFeed;

    // Date
    String formattedDate = DateFormat(
      'dd-MM-yyyy hh:mm a',
    ).format(DateTime.now());
    bytes += _textToBytes(formattedDate);
    bytes += EscPos.lineFeed;

    bytes += _textToBytes('--------------------------------');
    bytes += EscPos.lineFeed;

    // Header
    bytes += EscPos.alignLeft;
    bytes += _textToBytes('Item            Price   Total');
    bytes += EscPos.lineFeed;
    bytes += _textToBytes('--------------------------------');
    bytes += EscPos.lineFeed;

    // Items
    for (final item in request.items) {
      final String name = item['name'].toString();
      final String qty = item['qty'].toString();
      final String price = item['price'].toString();
      final String totalItem = item['total'].toString();

      final String prefix = '${qty}x $name';
      final int prefixLen = prefix.length;
      final int truncLen = prefixLen > 16 ? 16 : prefixLen;

      for (int i = 0; i < truncLen; i++) {
        bytes.add(prefix.codeUnitAt(i));
      }
      for (int i = truncLen; i < 16; i++) {
        bytes.add(32);
      }

      final int priceLen = price.length;
      for (int i = 0; i < priceLen; i++) {
        bytes.add(price.codeUnitAt(i));
      }
      for (int i = priceLen; i < 8; i++) {
        bytes.add(32);
      }

      bytes.addAll(totalItem.codeUnits);
      bytes.addAll(EscPos.lineFeed);
    }

    bytes += _textToBytes('--------------------------------');
    bytes += EscPos.lineFeed;

    // Total
    bytes += EscPos.alignRight;
    bytes += EscPos.boldOn;
    bytes += _textToBytes('TOTAL: ${request.total}');
    bytes += EscPos.lineFeed;
    bytes += EscPos.boldOff;
    bytes += EscPos.lineFeed;

    // Footer
    bytes += EscPos.alignCenter;
    bytes += _textToBytes(request.footer);
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;

    await _bluetooth.sendBytes(bytes);
    return PrinterResponse.success();
  }

  List<int> _textToBytes(String text) {
    return List.from(text.codeUnits);
  }
}
