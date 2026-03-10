import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Central Hive database manager for offline-first storage.
/// Stores all data as JSON maps — compatible with existing model
/// toJson()/fromJson() and future Frappe backend migration.
class HiveDatabase {
  HiveDatabase._();

  // Box names
  static const String productsBoxName = 'products';
  static const String ordersBoxName = 'orders';
  static const String shopBoxName = 'shop';
  static const String categoriesBoxName = 'categories';
  static const String settingsBoxName = 'settings';
  static const String billingCartBoxName = 'billing_cart';

  static late HiveAesCipher _cipher;

  /// Initialize Hive with Flutter and encrypted storage.
  static Future<void> init() async {
    await Hive.initFlutter();

    // Generate or retrieve encryption key
    const secureStorage = FlutterSecureStorage();
    final encryptionKeyString = await secureStorage.read(
      key: 'hive_encryption_key',
    );
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'hive_encryption_key',
        value: base64UrlEncode(key),
      );
    }

    final keyString = await secureStorage.read(key: 'hive_encryption_key');
    final encryptionKeyUint8List = base64Url.decode(keyString!);
    _cipher = HiveAesCipher(encryptionKeyUint8List);

    // Open all boxes — store raw Map<dynamic, dynamic> values
    await Future.wait([
      Hive.openBox(productsBoxName, encryptionCipher: _cipher),
      Hive.openBox(ordersBoxName, encryptionCipher: _cipher),
      Hive.openBox(shopBoxName, encryptionCipher: _cipher),
      Hive.openBox(categoriesBoxName, encryptionCipher: _cipher),
      Hive.openBox(settingsBoxName, encryptionCipher: _cipher),
      Hive.openBox(billingCartBoxName, encryptionCipher: _cipher),
    ]);
  }

  // Box accessors
  static Box get productBox => Hive.box(productsBoxName);
  static Box get orderBox => Hive.box(ordersBoxName);
  static Box get shopBox => Hive.box(shopBoxName);
  static Box get categoryBox => Hive.box(categoriesBoxName);
  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box get billingCartBox => Hive.box(billingCartBoxName);

  // ─── Generic CRUD helpers ───

  /// Save a JSON-serializable item by key.
  static Future<void> putItem(Box box, String key, Map<String, dynamic> json) {
    return box.put(key, json);
  }

  /// Get an item as Map by key.
  static Map<String, dynamic>? getItem(Box box, String key) {
    final raw = box.get(key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  /// Get all items from a box as a list of Maps.
  static List<Map<String, dynamic>> getAll(Box box) {
    return box.values
        .map((raw) => Map<String, dynamic>.from(raw as Map))
        .toList();
  }

  /// Delete an item by key.
  static Future<void> deleteItem(Box box, String key) {
    return box.delete(key);
  }

  /// Clear all items in a box.
  static Future<int> clearBox(Box box) {
    return box.clear();
  }
}
