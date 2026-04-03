import 'package:rokctapp/infrastructure/models/data/currency_data.dart';
import 'package:rokctapp/infrastructure/models/data/profile_data.dart';
import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart' as driver;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:rokctapp/infrastructure/models/data/address_information.dart';
import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:rokctapp/infrastructure/models/models.dart' hide Wallet;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rokctapp/infrastructure/models/response/driver_show_response.dart';
import 'package:rokctapp/infrastructure/services/constants/storage_keys.dart';
import 'package:rokctapp/infrastructure/models/response/global_settings_response.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart';

abstract class LocalStorage {
  LocalStorage._();

  /*/Added
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<bool> isFirstAppLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstAppLaunch') ?? true;

    return isFirstLaunch;
  }


*/ //end
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String? token) async {
    await _preferences?.setString(StorageKeys.keyToken, token ?? '');
  }

  static String getToken() =>
      _preferences?.getString(StorageKeys.keyToken) ?? '';

  static void deleteToken() => _preferences?.remove(StorageKeys.keyToken);

  static Future<void> setUiType(int type) async {
    await _preferences?.setInt(StorageKeys.keyUiType, type);
  }

  static int? getUiType() => _preferences?.getInt(StorageKeys.keyUiType);

  static Future<void> setUser(ProfileData? user) async {
    if (_preferences != null) {
      final String userString = user != null ? jsonEncode(user.toJson()) : '';
      await _preferences!.setString(StorageKeys.keyUser, userString);
    }
  }

  static ProfileData? getUser() {
    final savedString = _preferences?.getString(StorageKeys.keyUser);
    if (savedString == null) {
      return null;
    }
    final map = jsonDecode(savedString);
    if (map == null) {
      return null;
    }
    return ProfileData.fromJson(map);
  }

  static driver.UserData? getDriver() {
    final savedString = _preferences?.getString(StorageKeys.keyUser);
    if (savedString == null) {
      return null;
    }
    final map = jsonDecode(savedString);
    if (map == null) {
      return null;
    }
    return driver.UserData.fromJson(map);
  }

  static void _deleteUser() => _preferences?.remove(StorageKeys.keyUser);

  static Future<void> setSearchHistory(List<String> list) async {
    final List<String> idsStrings = list.map((e) => e.toString()).toList();
    await _preferences?.setStringList(StorageKeys.keySearchStores, idsStrings);
  }

  static List<String> getSearchList() {
    final List<String> strings =
        _preferences?.getStringList(StorageKeys.keySearchStores) ?? [];
    return strings;
  }

  static void deleteSearchList() =>
      _preferences?.remove(StorageKeys.keySearchStores);

  static Future<void> setSavedShopsList(List<String> ids) async {
    await _preferences?.setStringList(StorageKeys.keySavedStores, ids);
  }

  static List<String> getSavedShopsList() {
    return _preferences?.getStringList(StorageKeys.keySavedStores) ?? [];
  }

  static void deleteSavedShopsList() =>
      _preferences?.remove(StorageKeys.keySavedStores);

  static Future<void> setAddressSelected(dynamic data) async {
    if (data is AddressData) {
      await _preferences?.setString(
        StorageKeys.keyAddressSelected,
        jsonEncode(data.toJson()),
      );
    } else if (data is LatLng) {
      await _preferences?.setString(
        StorageKeys.keyAddressSelected,
        jsonEncode(data.toJson()),
      );
    }
  }

  static AddressData? getAddressSelected() {
    String dataString =
        _preferences?.getString(StorageKeys.keyAddressSelected) ?? "";
    if (dataString.isNotEmpty) {
      final json = jsonDecode(dataString);
      if (json.containsKey('latitude') && json.containsKey('longitude')) {
        return AddressData(
          location: LocationModel(
            latitude: double.tryParse(json['latitude'].toString()),
            longitude: double.tryParse(json['longitude'].toString()),
          ),
        );
      }
      AddressData data = AddressData.fromJson(json);
      // Check if the address ends with a number
      RegExp numericRegex = RegExp(r'\d$');
      if (numericRegex.hasMatch(data.address ?? "")) {
        // Use null-aware operator
        // Reorder the address components
        List<String> addressParts = (data.address ?? "")
            .split(',')
            .map((part) => part.trim())
            .toList(); // Use null-aware operator
        if (addressParts.length >= 3) {
          String postalCode = addressParts
              .removeLast(); // Remove and store postal code
          addressParts.insert(
            0,
            postalCode,
          ); // Insert postal code at the beginning
          String formattedAddress = addressParts.join(
            ', ',
          ); // Join the parts back together

          // Update the address property in the AddressData object
          data = data.copyWith(address: formattedAddress);
        }
      }
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressSelected() =>
      _preferences?.remove(StorageKeys.keyAddressSelected);

  static Future<void> setAddressInformation(AddressInformation data) async {
    await _preferences?.setString(
      StorageKeys.keyAddressInformation,
      jsonEncode(data.toJson()),
    );
  }

  static AddressInformation? getAddressInformation() {
    String dataString =
        _preferences?.getString(StorageKeys.keyAddressInformation) ?? "";
    if (dataString.isNotEmpty) {
      AddressInformation data = AddressInformation.fromJson(
        jsonDecode(dataString),
      );
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressInformation() =>
      _preferences?.remove(StorageKeys.keyAddressInformation);

  static Future<void> setLanguageSelected(bool selected) async {
    await _preferences?.setBool(StorageKeys.keyLangSelected, selected);
  }

  static bool getLanguageSelected() =>
      _preferences?.getBool(StorageKeys.keyLangSelected) ?? false;

  static void deleteLangSelected() =>
      _preferences?.remove(StorageKeys.keyLangSelected);

  static Future<void> setSelectedCurrency(CurrencyData currency) async {
    final String currencyString = jsonEncode(currency.toJson());
    await _preferences?.setString(
      StorageKeys.keySelectedCurrency,
      currencyString,
    );
  }

  static CurrencyData? getSelectedCurrency() {
    String json =
        _preferences?.getString(StorageKeys.keySelectedCurrency) ?? '';
    if (json.isEmpty) {
      return null;
    } else {
      final map = jsonDecode(json);
      return CurrencyData.fromJson(map);
    }
  }

  static void deleteSelectedCurrency() =>
      _preferences?.remove(StorageKeys.keySelectedCurrency);

  static Future<void> setWalletData(Wallet? wallet) async {
    final String walletString = jsonEncode(wallet?.toJson());
    await _preferences?.setString(StorageKeys.keyWalletData, walletString);
  }

  static Wallet? getWalletData() {
    final wallet = _preferences?.getString(StorageKeys.keyWalletData);
    if (wallet == null) {
      return null;
    }
    final map = jsonDecode(wallet);
    if (map == null) {
      return null;
    }
    return Wallet.fromJson(map);
  }

  static void deleteWalletData() =>
      _preferences?.remove(StorageKeys.keyWalletData);

  static Future<void> setWallet(Wallet? wallet) async {
    final String walletString = wallet != null
        ? jsonEncode(wallet.toJson())
        : '';
    await _preferences?.setString(StorageKeys.keyWallet, walletString);
  }

  static Wallet? getWallet() {
    final savedString = _preferences?.getString(StorageKeys.keyWallet);
    if (savedString == null) return null;
    final map = jsonDecode(savedString);
    return Wallet.fromJson(map);
  }

  static void deleteWallet() => _preferences?.remove(StorageKeys.keyWallet);

  static Future<void> setSettingsList(List<SettingsData> settings) async {
    final List<String> strings = settings
        .map((setting) => jsonEncode(setting.toJson()))
        .toList();
    await _preferences?.setStringList(StorageKeys.keyGlobalSettings, strings);
  }

  static List<SettingsData> getSettingsList() {
    final List<String> settings =
        _preferences?.getStringList(StorageKeys.keyGlobalSettings) ?? [];
    final List<SettingsData> settingsList = settings
        .map((setting) => SettingsData.fromJson(jsonDecode(setting)))
        .toList();
    return settingsList;
  }

  static void deleteSettingsList() =>
      _preferences?.remove(StorageKeys.keyGlobalSettings);

  static Future<void> setTranslations(
    Map<String, dynamic>? translations,
  ) async {
    final String encoded = jsonEncode(translations);
    await _preferences?.setString(StorageKeys.keyTranslations, encoded);
  }

  static Map<String, dynamic> getTranslations() {
    final String encoded =
        _preferences?.getString(StorageKeys.keyTranslations) ?? '';
    if (encoded.isEmpty) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded;
  }

  static void deleteTranslations() =>
      _preferences?.remove(StorageKeys.keyTranslations);

  static Future<void> setIsGuest(bool isGuest) async {
    await _preferences?.setBool(StorageKeys.keyIsGuest, isGuest);
  }

  static bool getIsGuest() =>
      _preferences?.getBool(StorageKeys.keyIsGuest) ?? false;

  static void deleteIsGuest() => _preferences?.remove(StorageKeys.keyIsGuest);

  static Future<void> setOfflineUser(Map<String, dynamic>? data) async {
    await _preferences?.setString(StorageKeys.keyOfflineUser, jsonEncode(data));
  }

  static Map<String, dynamic>? getOfflineUser() {
    final data = _preferences?.getString(StorageKeys.keyOfflineUser);
    return data != null ? jsonDecode(data) : null;
  }

  static void deleteOfflineUser() =>
      _preferences?.remove(StorageKeys.keyOfflineUser);

  static Future<void> setRemoteConfig(Map<String, dynamic>? data) async {
    await _preferences?.setString(
      StorageKeys.keyRemoteConfig,
      jsonEncode(data),
    );
  }

  static Map<String, dynamic>? getRemoteConfig() {
    final data = _preferences?.getString(StorageKeys.keyRemoteConfig);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<void> setAppThemeMode(bool isDarkMode) async {
    await _preferences?.setBool(StorageKeys.keyAppThemeMode, isDarkMode);
  }

  static bool getAppThemeMode() =>
      _preferences?.getBool(StorageKeys.keyAppThemeMode) ?? false;

  static void deleteAppThemeMode() =>
      _preferences?.remove(StorageKeys.keyAppThemeMode);

  static Future<void> setSettingsFetched(bool fetched) async {
    await _preferences?.setBool(StorageKeys.keySettingsFetched, fetched);
  }

  static bool getSettingsFetched() =>
      _preferences?.getBool(StorageKeys.keySettingsFetched) ?? false;

  static void deleteSettingsFetched() =>
      _preferences?.remove(StorageKeys.keySettingsFetched);

  static Future<void> setLanguageData(LanguageData? langData) async {
    final String lang = jsonEncode(langData?.toJson());
    await _preferences?.setString(StorageKeys.keyLanguageData, lang);
  }

  static LanguageData? getLanguage() {
    final lang = _preferences?.getString(StorageKeys.keyLanguageData);
    if (lang == null) {
      return null;
    }
    final map = jsonDecode(lang);
    if (map == null) {
      return null;
    }
    return LanguageData.fromJson(map);
  }

  static void deleteLanguage() =>
      _preferences?.remove(StorageKeys.keyLanguageData);

  static Future<void> setLangLtr(bool? backward) async {
    await _preferences?.setBool(StorageKeys.keyLangLtr, (backward ?? false));
  }

  static bool getLangLtr() =>
      !(_preferences?.getBool(StorageKeys.keyLangLtr) ?? false);

  static void deleteLangLtr() => _preferences?.remove(StorageKeys.keyLangLtr);

  static deleteBoard() {
    return _preferences?.remove(StorageKeys.keyBoard);
  }

  static DeliveryResponse? getDeliveryInfo() {
    final savedString = _preferences?.getString(StorageKeys.keyCarInfo);
    if (savedString == null) {
      return null;
    }
    final map = jsonDecode(savedString);
    if (map == null) {
      return null;
    }
    return DeliveryResponse.fromJson(map);
  }

  static Future<void> setSyncErrorCount(int count) async {
    await _preferences?.setInt('sync_error_count', count);
  }

  static int getSyncErrorCount() =>
      _preferences?.getInt('sync_error_count') ?? 0;

  static Future<void> setLastSyncError(String? error) async {
    await _preferences?.setString('last_sync_error', error ?? '');
  }

  static String getLastSyncError() =>
      _preferences?.getString('last_sync_error') ?? '';

  static Future<void> setShop(ShopData? shop) async {
    final String shopString = shop != null ? jsonEncode(shop.toJson()) : '';
    await _preferences?.setString(StorageKeys.keyShop, shopString);
  }

  static ShopData? getShop() {
    final savedString = _preferences?.getString(StorageKeys.keyShop);
    if (savedString == null) return null;
    final map = jsonDecode(savedString);
    return ShopData.fromJson(map);
  }

  static void deleteShop() => _preferences?.remove(StorageKeys.keyShop);

  static Future<void> setSystemLanguage(LanguageData? lang) async {
    final String langString = jsonEncode(lang?.toJson());
    await _preferences?.setString(StorageKeys.keySystemLanguage, langString);
  }

  static LanguageData? getSystemLanguage() {
    final lang = _preferences?.getString(StorageKeys.keySystemLanguage);
    if (lang == null) return null;
    final map = jsonDecode(lang);
    return LanguageData.fromJson(map);
  }

  static Future<void> setOnline(bool online) async {
    if (_preferences != null) {
      await _preferences!.setBool(StorageKeys.keyOnline, online);
    }
  }

  static bool getOnline() {
    final online = _preferences?.getBool(StorageKeys.keyOnline);
    if (online == null) {
      return false;
    }
    return online;
  }

  static void _deleteOnline() => _preferences?.remove(StorageKeys.keyOnline);

  static Future<void> setDeliveryInfo(DeliveryResponse? info) async {
    if (_preferences != null) {
      final String infoString = (info != null ? jsonEncode(info.toJson()) : '');
      await _preferences!.setString(StorageKeys.keyCarInfo, infoString);
    }
  }

  static void logout() {
    deleteWalletData();
    deleteWallet();
    deleteSavedShopsList();
    deleteSearchList();
    _deleteUser();
    deleteToken();
    deleteAddressSelected();
    deleteAddressInformation();
    deleteBoard();
    deleteIsGuest();
    deleteOfflineUser();
    deleteShop();
    _deleteOnline();
  }
}
