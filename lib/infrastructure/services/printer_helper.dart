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
  // Singleton
  static final PrinterHelper _instance = PrinterHelper._internal();
  factory PrinterHelper() => _instance;
  PrinterHelper._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> checkPermission() async {
    // Request Bluetooth and Location permissions
    // Android 12+ needs BLUETOOTH_SCAN, BLUETOOTH_CONNECT
    // Older Android needs BLUETOOTH, BLUETOOTH_ADMIN, ACCESS_FINE_LOCATION

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
      _isConnected =
          !result; // If disconnected successfully, isConnected is false
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> printText(String text) async {
    if (!_isConnected) return;

    // Simple text printing
    // We can use bytes for advanced formatting
    // But plugin supports basic text or bytes

    // Checking battery or connection status
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      // Plugin allows sending bytes. We need ESC/POS commands for text.
      // However, the plugin might have helper.
      // Looking at doc, `writeBytes` or `writeString`?
      // The plugin `print_bluetooth_thermal` mainly exposes `writeBytes`.
      // We need a generator. `esc_pos_utils` is common but not requested.
      // But wait, `print_bluetooth_thermal` example often uses `capability_profile` and `generator`.
      // I don't have `esc_pos_utils` or similar in my pubspec.
      // The user requested `print_bluetooth_thermal`.
      // Let's assume we can send raw string bytes or use a simple helper.
      // Actually without `esc_pos_utils`, formatting is hard.
      // I will try to use `esc_pos_utils_plus` or similar if I can add it, but user gave specific packages.
      // Wait, user allowed "use required plugins".
      // "suggest barcode scanner ... and use required plugins".
      // So I can add `esc_pos_utils_plus`.

      // For now, I'll assume simple text printing by converting string to bytes.
      // ASCII bytes.
      List<int> bytes = text.codeUnits;
      await PrintBluetoothThermal.writeBytes(bytes);
    }
  }

  Future<void> printReceipt({
    required String shopName,
    required String address1,
    required String address2,
    required String phone,
    required List<Map<String, dynamic>> items, // Name, Qty, Price, Total
    required double total,
    required String footer,
  }) async {
    if (!_isConnected) return;

    // Construct ESC/POS bytes manually or using helper
    final List<int> bytes = [];

    // Init
    bytes.addAll(EscPos.init);

    // Shop Name (Center, Bold, Large)
    bytes.addAll(EscPos.alignCenter);
    bytes.addAll(EscPos.boldOn);
    bytes.addAll(EscPos.textLarge);
    bytes.addAll(shopName.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    // Address & Phone (Normal, Center)
    bytes.addAll(EscPos.textNormal);
    bytes.addAll(EscPos.boldOff);
    if (address1.isNotEmpty) {
      bytes.addAll(address1.codeUnits);
      bytes.addAll(EscPos.lineFeed);
    }
    if (address2.isNotEmpty) {
      bytes.addAll(address2.codeUnits);
      bytes.addAll(EscPos.lineFeed);
    }
    bytes.addAll(phone.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    // Date and Time
    final String formattedDate = DateFormat(
      'dd-MM-yyyy hh:mm a',
    ).format(DateTime.now());
    bytes.addAll(formattedDate.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    bytes.addAll('--------------------------------'.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    // Header (Align Left)
    bytes.addAll(EscPos.alignLeft);
    bytes.addAll('Item            Price   Total'.codeUnits);
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll('--------------------------------'.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    // Items
    for (final item in items) {
      final String name = item['name'].toString();
      final String qty = item['qty'].toString();
      final String price = item['price'].toString();
      final String totalItem = item['total'].toString();

      final String prefix = '${qty}x $name';
      final String truncatedPrefix = prefix.length > 16
          ? prefix.substring(0, 16)
          : prefix;

      final String line =
          truncatedPrefix.padRight(16) + price.padRight(8) + totalItem;
      bytes.addAll(line.codeUnits);
      bytes.addAll(EscPos.lineFeed);
    }

    bytes.addAll('--------------------------------'.codeUnits);
    bytes.addAll(EscPos.lineFeed);

    // Total (Align Right)
    bytes.addAll(EscPos.alignRight);
    bytes.addAll(EscPos.boldOn);
    bytes.addAll('TOTAL: $total'.codeUnits);
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll(EscPos.boldOff);
    bytes.addAll(EscPos.lineFeed);

    // Footer (Center)
    bytes.addAll(EscPos.alignCenter);
    bytes.addAll(footer.codeUnits);
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll(EscPos.lineFeed); // One line space after footer
    bytes.addAll(EscPos.lineFeed);
    bytes.addAll(EscPos.lineFeed); // Additional Feed

    await PrintBluetoothThermal.writeBytes(bytes);
  }
}
