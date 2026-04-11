// ignore_for_file: depend_on_referenced_packages

import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ftoast/ftoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/models/data/addon_data.dart';
import 'package:rokctapp/infrastructure/models/data/order_detail.dart'
    hide Extras;
import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:rokctapp/infrastructure/models/data/manager/shop_data.dart';
import 'package:rokctapp/infrastructure/models/data/product_data.dart'
    hide Extras;
import 'package:rokctapp/infrastructure/models/response/global_settings_response.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/img_service.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/presentation/components/buttons/custom_button.dart';
import 'package:rokctapp/presentation/components/exports/components_driver.dart'
    show BlurWrap, ButtonsBouncingEffect;
import 'package:rokctapp/presentation/theme/app_style.dart';

/// Single unified AppHelpers used across user, driver, and manager flows.
class AppHelpers {
  AppHelpers._();

  // ─────────────────────────────────────────────────────────────────────────
  // NUMBER FORMATTING
  // ─────────────────────────────────────────────────────────────────────────

  /// Full-featured number formatter. [isOrder] suppresses the currency symbol
  /// (driver variant behaviour). When omitted the selected currency is used.
  static String numberFormat({
    num? number,
    String? symbol,
    bool? isOrder,
    int? maxLength,
  }) {
    symbol = (isOrder ?? false)
        ? (symbol ?? '')
        : (LocalStorage.getSelectedCurrency()?.symbol ?? '');

    final bool isBefore =
        LocalStorage.getSelectedCurrency()?.position == 'before';
    final String beforeSymbol = isBefore ? symbol : '';
    final String afterSymbol = isBefore ? '' : ' $symbol';

    if (number.toString().length > 12) {
      maxLength = maxLength;
    } else {
      maxLength = 16;
    }

    if ((number ?? 0) > 999999) {
      return beforeSymbol +
          NumberFormat.compact(
            locale: LocalStorage.getLanguage()?.locale,
          ).format(number) +
          afterSymbol;
    }

    if (number.toString().length > (maxLength ?? 16)) {
      return beforeSymbol +
          (number?.toStringAsExponential(maxLength ?? 10) ?? '') +
          afterSymbol;
    }

    if (isBefore) {
      return NumberFormat.currency(
        customPattern: '\u00a4#,###.#',
        symbol: symbol,
        decimalDigits: 2,
      ).format(number ?? 0);
    } else {
      return NumberFormat.currency(
        customPattern: '#,###.#\u00a4',
        symbol: symbol,
        decimalDigits: 2,
      ).format(number ?? 0);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SETTINGS HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  static SignUpType getAuthOption() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'auth_option') {
        switch (setting.value) {
          case 'phone':
            return SignUpType.phone;
          case 'email':
            return SignUpType.email;
          default:
            return SignUpType.both;
        }
      }
    }
    return SignUpType.both;
  }

  static String? getAppPhone() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'phone') {
        return setting.value;
      }
    }
    return '';
  }

  static String getAppName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'title') {
        return setting.value ?? '';
      }
    }
    return '';
  }

  static String? getAppAddressName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'address') {
        return setting.value;
      }
    }
    return '';
  }

  /// Returns true when the driver is NOT allowed to edit their own credentials.
  static bool getDriverCantEdit() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'driver_can_edit_credentials') {
        return setting.value == '0';
      }
    }
    return false;
  }

  static int getAppDeliveryTime() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'deliveryman_order_acceptance_time') {
        return int.tryParse(setting.value ?? '30') ?? 30;
      }
    }
    return 30;
  }

  static double? getInitialLatitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString = setting.value?.substring(
          0,
          setting.value?.indexOf(','),
        );
        if (latString == null) return null;
        return double.tryParse(latString);
      }
    }
    return null;
  }

  static double? getInitialLongitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString = setting.value?.substring(
          0,
          setting.value?.indexOf(','),
        );
        if (latString == null) return null;
        final String? lonString = setting.value?.substring(
          (latString.length) + 2,
          setting.value?.length,
        );
        if (lonString == null) return null;
        return double.tryParse(lonString);
      }
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SHOP / ORDER HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  static String getShopWorkingTimeForToday() {
    final shop = LocalStorage.getShop();
    if (shop == null) {
      return getTranslation(TrKeys.theRestaurantIsClosedToday);
    }
    final currentWeekday =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final List<ShopWorkingDays> workingDays = shop.shopWorkingDays ?? [];
    for (final day in workingDays) {
      if (day.day?.toLowerCase() == currentWeekday) {
        if (day.disabled ?? false) {
          return getTranslation(TrKeys.theRestaurantIsClosedToday);
        }
        return '${day.from?.substring(0, 2)}:${day.from?.substring(3, 5)}'
            ' - ${day.to?.substring(0, 2)}:${day.to?.substring(3, 5)}';
      }
    }
    return '';
  }

  /// Returns a comma-separated string of selected addon titles for [stock].
  static String? selectedAddonsTitles(Stock stock) {
    final List<AddonData> addons = stock.localAddons ?? [];
    if (addons.isEmpty) return null;
    String text = '${addons[0].product?.translation?.title}';
    for (int i = 1; i < addons.length; i++) {
      text =
          '$text${i != addons.length ? ',' : ''} ${addons[i].product?.translation?.title} ';
    }
    return text;
  }

  static String getInitialAddonQuantity(ProductData addon) {
    return addon.stock?.quantity == null
        ? ''
        : addon.stock?.quantity.toString() ?? '';
  }

  static String getInitialAddonPrice(ProductData addon) {
    return addon.stock?.price.toString() ?? '';
  }

  static String truncate(String value, int length) {
    return value.length > length ? value.substring(0, length) : value;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EXTRAS / ORDER STATUS HELPERS  (manager-specific)
  // ─────────────────────────────────────────────────────────────────────────

  static List<List<Extras>> cartesian(List<List<dynamic>> args) {
    final List<List<Extras>> r = [];
    final int max = args.length - 1;

    void helper(List<Extras> arr, int i) {
      for (int j = 0, l = args[i].length; j < l; j++) {
        final List<Extras> a = List.from(arr);
        a.add(args[i][j] as Extras);
        if (i == max) {
          r.add(a);
        } else {
          helper(a, i + 1);
        }
      }
    }

    helper([], 0);
    return r;
  }

  static ExtrasType getExtraTypeByValue(String? value) {
    switch (value) {
      case 'color':
        return ExtrasType.color;
      case 'image':
        return ExtrasType.image;
      case 'text':
      default:
        return ExtrasType.text;
    }
  }

  static OrderStatus getOrderStatus(String? value) {
    switch (value) {
      case 'new':
        return OrderStatus.newOrder;
      case 'accepted':
        return OrderStatus.accepted;
      case 'cooking':
        return OrderStatus.cooking;
      case 'ready':
        return OrderStatus.ready;
      case 'on_a_way':
        return OrderStatus.onAWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.newOrder;
    }
  }

  static OrderStatus getUpdatableStatus(String? value) {
    switch (value) {
      case 'new':
        return OrderStatus.accepted;
      case 'accepted':
        return OrderStatus.cooking;
      case 'cooking':
        return OrderStatus.ready;
      case 'ready':
        return OrderStatus.onAWay;
      case 'on_a_way':
        return OrderStatus.delivered;
      case 'delivered':
        return OrderStatus.newOrder;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.accepted;
    }
  }

  static String changeStatusButtonText(String? value) {
    switch (value) {
      case 'new':
        return getTranslation(TrKeys.swipeToAccept);
      case 'accepted':
        return getTranslation(TrKeys.swipeToCooking);
      case 'cooking':
        return getTranslation(TrKeys.swipeToReady);
      case 'ready':
        return getTranslation(TrKeys.swipeToWay);
      case 'on_a_way':
        return getTranslation(TrKeys.swipeToDelivered);
      case 'delivered':
      case 'canceled':
      default:
        return getTranslation(TrKeys.swipeToAccept);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TRANSLATION
  // ─────────────────────────────────────────────────────────────────────────

  /// Looks up [trKey] in stored translations.
  /// Falls back to a humanised version of the key when not found.
  static String getTranslation(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    if (AppConstants.autoTrn) {
      return translations[trKey] ??
          (trKey.isNotEmpty
              ? trKey
                    .replaceAll('.', ' ')
                    .replaceAll('_', ' ')
                    .replaceFirst(
                      trKey.substring(0, 1),
                      trKey.substring(0, 1).toUpperCase(),
                    )
              : '');
    } else {
      return translations[trKey] ?? trKey;
    }
  }

  static String getTranslationReverse(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    for (int i = 0; i < translations.values.length; i++) {
      if (trKey == translations.values.elementAt(i)) {
        return translations.keys.elementAt(i);
      }
    }
    return trKey;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SNACK BARS / TOASTS
  // ─────────────────────────────────────────────────────────────────────────

  static void showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Text(
          'No internet connection',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppStyle.white,
          ),
        ),
        action: SnackBarAction(
          label: 'Close',
          disabledTextColor: Colors.white,
          textColor: Colors.yellow,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Unified snack-bar that supports [SnackBarType] (manager style) **and**
  /// a plain positional [text] string (driver/user style).
  ///
  /// Usage examples:
  /// ```dart
  /// // manager style
  /// AppHelpers.showCheckTopSnackBar(context, type: SnackBarType.error, text: 'Oops');
  /// // driver / user style
  /// AppHelpers.showCheckTopSnackBar(context, text: 'Oops');
  /// ```
  static void showCheckTopSnackBar(
    BuildContext context, {
    String? text,
    SnackBarType type = SnackBarType.error,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      type == SnackBarType.success
          ? CustomSnackBar.success(
              message: text ??
                  getTranslation(TrKeys.successfullyCompleted),
            )
          : type == SnackBarType.info
              ? CustomSnackBar.info(
                  message:
                      text ?? getTranslation(TrKeys.infoMessage),
                )
              : CustomSnackBar.error(
                  message: text?.isNotEmpty == true
                      ? text!
                      : getTranslation(
                          TrKeys.somethingWentWrongWithTheServer,
                        ),
                ),
    );
  }

  /// Convenience wrapper — show a success snack bar.
  static void showCheckTopSnackBarInfo(BuildContext context, String text) {
    showTopSnackBar(Overlay.of(context), CustomSnackBar.success(message: text));
  }

  /// Manager-style ftoast error popup.
  static void errorSnackBar(BuildContext context, {String? text}) {
    FToast.toast(
      context,
      toast: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.only(
              bottom: MediaQuery.sizeOf(context).height / 1.5,
              left: 32.r,
              right: 32.r,
            ),
            decoration: BoxDecoration(
              color: AppStyle.primary,
              borderRadius: BorderRadius.circular(
                (AppConstants.radius / 2).r,
              ),
            ),
            child: Text(
              text ?? getTranslation(TrKeys.failed),
              style: AppStyle.interNormal(color: AppStyle.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DIALOGS / BOTTOM SHEETS
  // ─────────────────────────────────────────────────────────────────────────

  /// Simple info dialog with a close button (manager style).
  static Future<void> openDialog({
    required BuildContext context,
    required String title,
  }) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppStyle.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          margin: EdgeInsets.all(24.w),
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  getTranslation(title),
                  textAlign: TextAlign.center,
                  style: AppStyle.interNormal(size: 18),
                ),
                24.verticalSpace,
                CustomButton(
                  onPressed: () => Navigator.pop(context),
                  title: getTranslation(TrKeys.close),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Image-picker dialog (driver/user style) with BlurWrap bottom sheet.
  static Future<void> openDialogImagePicker({
    required BuildContext context,
    required ValueChanged<String> onSuccess,
  }) {
    return showDialog(
      context: context,
      builder: (_) => Builder(
        builder: (colors) => Dialog(
          backgroundColor: AppStyle.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            margin: EdgeInsets.all(24.w),
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getTranslation(TrKeys.selectPhoto),
                  textAlign: TextAlign.center,
                  style: AppStyle.interNormal(size: 18),
                ),
                const Divider(),
                8.verticalSpace,
                ButtonsBouncingEffect(
                  child: GestureDetector(
                    onTap: () => ImgService.getPhotoCamera(onSuccess),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 8.r,
                      ),
                      child: Row(
                        children: [
                          const Icon(FlutterRemix.camera_lens_line),
                          4.horizontalSpace,
                          Text(
                            getTranslation(TrKeys.takePhoto),
                            textAlign: TextAlign.center,
                            style: AppStyle.interNormal(size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                8.verticalSpace,
                ButtonsBouncingEffect(
                  child: GestureDetector(
                    onTap: () => ImgService.getPhotoGallery(onSuccess),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 8.r,
                      ),
                      child: Row(
                        children: [
                          const Icon(FlutterRemix.gallery_line),
                          4.horizontalSpace,
                          Text(
                            getTranslation(TrKeys.chooseFromLibrary),
                            textAlign: TextAlign.center,
                            style: AppStyle.interNormal(size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,
                CustomButton(
                  background: AppStyle.shimmerBase,
                  title: getTranslation(TrKeys.skip),
                  onPressed: () => onSuccess.call(''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Standard bottom sheet — uses [BlurWrap] for the driver/user glass effect.
  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    bool isDarkMode = false,
    double radius = 16,
    bool isDrag = true,
    bool isExpanded = false,
    bool isDismissible = true,
    double paddingTop = 200,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: AppStyle.transparent,
      context: context,
      builder: (context) => BlurWrap(
        radius: BorderRadius.only(
          topRight: Radius.circular(12.r),
          topLeft: Radius.circular(12.r),
        ),
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: AppStyle.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.r),
              topLeft: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppStyle.black.withValues(alpha: 0.25),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    color: AppStyle.dragElement,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
                ),
                modal,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Draggable scrollable bottom sheet (manager style).
  static void showCustomModalBottomDragSheet({
    required BuildContext context,
    required Function(ScrollController controller) modal,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 100,
    double maxChildSize = 0.9,
    double initSize = 0.9,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: AppStyle.transparent,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) =>
            modal(scrollController),
      ),
    );
  }

  /// Bottom sheet without the iOS drag indicator.
  static void showCustomModalBottomSheetWithoutIosIcon({
    required BuildContext context,
    required Widget modal,
    bool isDarkMode = false,
    double radius = 16,
    bool isDrag = true,
    double paddingTop = 200,
  }) {
    showModalBottomSheet(
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: AppStyle.transparent,
      context: context,
      builder: (context) => modal,
    );
  }

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    double radius = 16,
  }) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: AppStyle.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.r),
        ),
        insetPadding: EdgeInsets.all(16.r),
        child: child,
      ),
    );
  }

  /// Popup context menu anchored to [context]'s render box.
  static void showPopup({
    required BuildContext context,
    required Iterable<PopupMenuItem> items,
    double radius = AppConstants.radius,
    bool isRight = false,
  }) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + (isRight ? size.width : 0),
        position.dy + size.height / 3,
        position.dx,
        position.dy + (isRight ? size.width : 0),
      ),
      elevation: 3,
      constraints: BoxConstraints(
        minWidth: size.width / 2,
        maxWidth: size.width,
      ),
      shadowColor: AppStyle.differBorderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r),
      ),
      color: AppStyle.white,
      items: items.toList(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMAGE / SVG UTILITIES
  // ─────────────────────────────────────────────────────────────────────────

  static bool checkIsSvg(String? url) {
    if (url == null) return false;
    final length = url.length;
    return url.substring(length - 3, length) == 'svg';
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Uint8List> svgToPng(
    String svgString, {
    int? svgWidth,
    int? svgHeight,
  }) async {
    final PictureInfo pictureInfo = await vg.loadPicture(
      SvgAssetLoader(svgString),
      null,
    );
    final image = await pictureInfo.picture.toImage(
      svgWidth ?? pictureInfo.size.width.toInt(),
      svgHeight ?? pictureInfo.size.height.toInt(),
    );
    final ByteData? bytes =
        await image.toByteData(format: ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ERROR HANDLING
  // ─────────────────────────────────────────────────────────────────────────

  static String errorHandler(dynamic e) {
    try {
      return (e.runtimeType == DioException)
          ? ((e as DioException).response?.data['message'] == 'Bad request.'
                ? (e.response?.data['params'] as Map).values.first[0]
                : e.response?.data['message'])
          : e.toString();
    } catch (_) {
      try {
        return (e.runtimeType == DioException)
            ? ((e as DioException)
                    .response
                    ?.data
                    .toString()
                    .substring(
                      (e.response?.data.toString().indexOf('<title>') ?? 0) + 7,
                      e.response?.data.toString().indexOf('</title') ?? 0,
                    ))
                .toString()
            : e.toString();
      } catch (_) {
        return (e.runtimeType == DioException)
            ? ((e as DioException).response?.data['error']['message'])
                  .toString()
            : e.toString();
      }
    }
  }
}