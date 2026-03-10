import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:billing_app/infrastructure/models/product_model.dart';
import 'package:billing_app/infrastructure/models/shop_model.dart';

class HiveDatabase {
  static const String productBoxName = 'products';
  static const String shopBoxName = 'shop';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(ShopModelAdapter());

    // Secure Storage for Encryption Key
    const secureStorage = FlutterSecureStorage();
    final encryptionKeyString =
        await secureStorage.read(key: 'hive_encryption_key');
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'hive_encryption_key',
        value: base64UrlEncode(key),
      );
    }

    final keyString = await secureStorage.read(key: 'hive_encryption_key');
    final encryptionKeyUint8List = base64Url.decode(keyString!);
    final cipher = HiveAesCipher(encryptionKeyUint8List);

    // Open Boxes
    await Hive.openBox<ProductModel>(productBoxName, encryptionCipher: cipher);
    await Hive.openBox<ShopModel>(shopBoxName, encryptionCipher: cipher);
    await Hive.openBox(settingsBoxName,
        encryptionCipher: cipher); // Generic box for simple key-value
  }

  static Box<ProductModel> get productBox =>
      Hive.box<ProductModel>(productBoxName);
  static Box<ShopModel> get shopBox => Hive.box<ShopModel>(shopBoxName);
  static Box get settingsBox => Hive.box(settingsBoxName);
}
