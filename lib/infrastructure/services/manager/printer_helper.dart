import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

class EscPos {
  static const List<int> init = [0x1B, 0x40];
  static const List<int> alignCenter = [0x1B, 0x61, 0x01];
  static const List<int> alignLeft = [0x1B, 0x61, 0x00];
  static const List<int> alignRight = [0x1B, 0x61, 0x02];
  static const List<int> boldOn = [0x1B, 0x45, 0x01];
  static const List<int> boldOff = [0x1B, 0x45, 0x00];
  static const List<int> textNormal = [0x1D, 0x21, 0x00];
  static const List<int> textLarge = [0x1D, 0x21, 0x11];
  static const List<int> lineFeed = [0x0A];
}

class PrinterHelper {
  static final PrinterHelper _instance = PrinterHelper._internal();
  factory PrinterHelper() => _instance;
  PrinterHelper._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<List<BluetoothInfo>> getBondedDevices() async {
    try {
      final List<BluetoothInfo> list =
          await PrintBluetoothThermal.pairedBluetooths;
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(String macAddress) async {
    try {
      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );
      _isConnected = result;
      return result;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      final bool result = await PrintBluetoothThermal.disconnect;
      _isConnected = !result;
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> printText(String text) async {
    if (!_isConnected) return;
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      List<int> bytes = text.codeUnits;
      await PrintBluetoothThermal.writeBytes(bytes);
    }
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
    if (!_isConnected) return;

    List<int> bytes = [];
    bytes += EscPos.init;

    // Shop Name
    bytes += EscPos.alignCenter;
    bytes += EscPos.boldOn;
    bytes += EscPos.textLarge;
    bytes += _textToBytes(shopName);
    bytes += EscPos.lineFeed;

    // Address & Phone
    bytes += EscPos.textNormal;
    bytes += EscPos.boldOff;
    if (address1.isNotEmpty) {
      bytes += _textToBytes(address1);
      bytes += EscPos.lineFeed;
    }
    if (address2.isNotEmpty) {
      bytes += _textToBytes(address2);
      bytes += EscPos.lineFeed;
    }
    bytes += _textToBytes(phone);
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
    for (final item in items) {
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
    bytes += _textToBytes('TOTAL: $total');
    bytes += EscPos.lineFeed;
    bytes += EscPos.boldOff;
    bytes += EscPos.lineFeed;

    // Footer
    bytes += EscPos.alignCenter;
    bytes += _textToBytes(footer);
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;
    bytes += EscPos.lineFeed;

    await PrintBluetoothThermal.writeBytes(bytes);
  }

  List<int> _textToBytes(String text) {
    return List.from(text.codeUnits);
  }
}
