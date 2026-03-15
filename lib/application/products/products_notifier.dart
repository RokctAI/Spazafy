import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import 'package:venderfoodyman/domain/interface/products.dart';
import 'package:venderfoodyman/domain/interface/cart.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/models/customer/request/cart_request.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
import 'package:venderfoodyman/customer/app_constants.dart';

import 'products_state.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsFacade _productsRepository;
  final CartFacade _cartRepository;

  ProductsNotifier(this._productsRepository, this._cartRepository)
    : super(const ProductsState());

  String? shareLink;

  void change(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void changeImage(Galleries image) {
    state = state.copyWith(selectImage: image);
  }

  // --- Fetching Logic ---

  Future<void> getProductDetails(
    BuildContext context,
    ProductData productData, {
    String? shopType,
    String? shopId,
  }) async {
    final List<Stocks> stocks = productData.stocks ?? <Stocks>[];
    state = state.copyWith(
      count: productData.minQty ?? 1,
      isCheckShopOrder: false,
      productData: productData,
      activeImageUrl: '${productData.img}',
      selectImage: Galleries(path: productData.img),
      initialStocks: stocks,
    );
    generateShareLink(shopId);
    if (stocks.isNotEmpty) {
      final int groupsCount = stocks[0].extras?.length ?? 0;
      final List<int> selectedIndexes = List.filled(groupsCount, 0);
      initialSetSelectedIndexes(context, selectedIndexes);
    }
    getProductDetailsById(
      context,
      productData.uuid ?? "",
      shopId,
      isLoading: true,
    );
  }

  Future<void> getProductDetailsById(
    BuildContext context,
    String productId,
    String? shopId, {
    bool isLoading = true,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isLoading) {
        state = state.copyWith(
          isLoading: true,
          productData: null,
          activeImageUrl: '',
        );
      }
      final response = await _productsRepository.getProductDetails(productId);
      response.when(
        success: (data) async {
          final List<Stocks> stocks = data.data?.stocks ?? <Stocks>[];
          state = state.copyWith(
            count: state.count == 1 ? data.data?.minQty ?? 1 : state.count,
            productData: data.data,
            activeImageUrl: '${data.data?.img}',
            initialStocks: stocks,
            isLoading: false,
          );
          generateShareLink(shopId);
          if (stocks.isNotEmpty) {
            final int groupsCount = stocks[0].extras?.length ?? 0;
            final List<int> selectedIndexes = List.filled(groupsCount, 0);
            initialSetSelectedIndexes(context, selectedIndexes);
          }
        },
        failure: (failure, s) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  // --- Count/Quantity Management ---

  void addCount(BuildContext context) {
    int count = state.count;
    if (count < (state.productData?.maxQty ?? 1)) {
      state = state.copyWith(count: ++count);
    } else {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        "${AppHelpers.getTranslation(TrKeys.maxQty)} ${state.count}",
      );
    }
  }

  void disCount(BuildContext context) {
    int count = state.count;
    if (count > (state.productData?.minQty ?? 1)) {
      state = state.copyWith(count: --count);
    } else {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.minQty),
      );
    }
  }

  // --- Extras & Stock Selection Logic (Merged) ---

  void updateSelectedIndexes(BuildContext context, int index, int value) {
    final newList = state.selectedIndexes.sublist(0, index);
    newList.add(value);
    final postList = List.filled(
      state.selectedIndexes.length - newList.length,
      0,
    );
    newList.addAll(postList);
    initialSetSelectedIndexes(context, newList);
  }

  void initialSetSelectedIndexes(BuildContext context, List<int> indexes) {
    state = state.copyWith(selectedIndexes: indexes);
    updateExtras(context);
  }

  void updateExtras(BuildContext context) {
    if (state.initialStocks.isEmpty) return;
    final int groupsCount = state.initialStocks[0].extras?.length ?? 0;
    final List<TypedExtra> groupExtras = [];
    for (int i = 0; i < groupsCount; i++) {
      if (i == 0) {
        final TypedExtra extras = getFirstExtras(state.selectedIndexes[0]);
        groupExtras.add(extras);
      } else {
        final TypedExtra extras = getUniqueExtras(
          groupExtras,
          state.selectedIndexes,
          i,
        );
        groupExtras.add(extras);
      }
    }
    final Stocks? selectedStock = getSelectedStock(groupExtras);
    state = state.copyWith(
      typedExtras: groupExtras,
      selectedStock: selectedStock,
    );
  }

  Stocks? getSelectedStock(List<TypedExtra> groupExtras) {
    List<Stocks> stocks = List.from(state.initialStocks);
    for (int i = 0; i < groupExtras.length; i++) {
      if (state.selectedIndexes[i] < groupExtras[i].uiExtras.length) {
        String selectedExtrasValue =
            groupExtras[i].uiExtras[state.selectedIndexes[i]].value;
        stocks = getSelectedStocks(stocks, selectedExtrasValue, i);
      }
    }
    return stocks.isNotEmpty ? stocks[0] : null;
  }

  List<Stocks> getSelectedStocks(List<Stocks> stocks, String value, int index) {
    List<Stocks> included = [];
    for (int i = 0; i < stocks.length; i++) {
      if (stocks[i].extras != null && stocks[i].extras!.length > index) {
        if (stocks[i].extras?[index].value == value) {
          included.add(stocks[i]);
        }
      }
    }
    return included;
  }

  TypedExtra getFirstExtras(int selectedIndex) {
    ExtrasType type = ExtrasType.text;
    String title = '';
    final List<String> uniques = [];
    for (int i = 0; i < state.initialStocks.length; i++) {
      if (state.initialStocks[i].extras?.isNotEmpty ?? false) {
        uniques.add(state.initialStocks[i].extras?[0].value ?? '');
        title =
            state.initialStocks[i].extras?[0].group?.translation?.title ?? '';
        type = AppHelpers.getExtraTypeByValue(
          state.initialStocks[i].extras?[0].group?.type,
        );
      }
    }
    final setOfUniques = uniques.toSet().toList();
    final List<UiExtra> extras = [];
    for (int i = 0; i < setOfUniques.length; i++) {
      extras.add(UiExtra(setOfUniques[i], selectedIndex == i, i));
    }
    return TypedExtra(type, extras, title, 0);
  }

  TypedExtra getUniqueExtras(
    List<TypedExtra> groupExtras,
    List<int> selectedIndexes,
    int index,
  ) {
    List<Stocks> includedStocks = List.from(state.initialStocks);
    for (int i = 0; i < groupExtras.length; i++) {
      final String includedValue =
          groupExtras[i].uiExtras[selectedIndexes[i]].value;
      includedStocks = getIncludedStocks(includedStocks, i, includedValue);
    }
    final List<String> uniques = [];
    String title = '';
    ExtrasType type = ExtrasType.text;
    for (int i = 0; i < includedStocks.length; i++) {
      if (includedStocks[i].extras != null &&
          includedStocks[i].extras!.length > index) {
        uniques.add(includedStocks[i].extras?[index].value ?? '');
        title =
            includedStocks[i].extras?[index].group?.translation?.title ?? '';
        type = AppHelpers.getExtraTypeByValue(
          includedStocks[i].extras?[index].group?.type ?? '',
        );
      }
    }
    final setOfUniques = uniques.toSet().toList();
    final List<UiExtra> extras = [];
    for (int i = 0; i < setOfUniques.length; i++) {
      extras.add(
        UiExtra(setOfUniques[i], selectedIndexes[groupExtras.length] == i, i),
      );
    }
    return TypedExtra(type, extras, title, index);
  }

  List<Stocks> getIncludedStocks(
    List<Stocks> includedStocks,
    int index,
    String includedValue,
  ) {
    List<Stocks> stocks = [];
    for (int i = 0; i < includedStocks.length; i++) {
      if (includedStocks[i].extras != null &&
          includedStocks[i].extras!.length > index) {
        if (includedStocks[i].extras?[index].value == includedValue) {
          stocks.add(includedStocks[i]);
        }
      }
    }
    return stocks;
  }

  // --- Addons/Ingredients Management ---

  void updateIngredient(BuildContext context, int selectIndex) {
    List<Addons>? data = state.selectedStock?.addons;
    if (data != null && data.length > selectIndex) {
      data[selectIndex].active = !(data[selectIndex].active ?? false);
      Stocks? newStock = state.selectedStock?.copyWith(addons: data);
      state = state.copyWith(selectedStock: newStock);
    }
  }

  void addIngredient(BuildContext context, int selectIndex) {
    List<Addons>? data = state.selectedStock?.addons;
    if (data != null && data.length > selectIndex) {
      final addon = data[selectIndex];
      if ((addon.product?.maxQty ?? 0) > (addon.quantity ?? 0)) {
        addon.quantity = (addon.quantity ?? 0) + 1;
        state = state.copyWith(
          selectedStock: state.selectedStock?.copyWith(addons: data),
        );
      }
    }
  }

  void removeIngredient(BuildContext context, int selectIndex) {
    List<Addons>? data = state.selectedStock?.addons;
    if (data != null && data.length > selectIndex) {
      final addon = data[selectIndex];
      if ((addon.product?.minQty ?? 0) < (addon.quantity ?? 0)) {
        addon.quantity = (addon.quantity ?? 0) - 1;
        state = state.copyWith(
          selectedStock: state.selectedStock?.copyWith(addons: data),
        );
      }
    }
  }

  // --- Cart & Share ---

  void createCart(
    BuildContext context,
    String shopId,
    VoidCallback onSuccess, {
    String? stockId,
    int? count,
    VoidCallback? onError,
    bool isGroupOrder = false,
    String? cartId,
    String? userUuid,
  }) async {
    state = state.copyWith(isCheckShopOrder: false);
    if (shopId != state.productData?.shopId) {
      state = state.copyWith(isCheckShopOrder: true);
      return;
    }
    final connected = await AppConnectivity.connectivity();
    if (!connected) {
      AppHelpers.showNoConnectionSnackBar(context);
      return;
    }
    state = state.copyWith(isAddLoading: true);
    List<CartRequest> list = [
      CartRequest(
        stockId: stockId ?? state.selectedStock?.id ?? "",
        quantity: count ?? state.count,
      ),
    ];
    for (Addons element in state.selectedStock?.addons ?? []) {
      if (element.active ?? false) {
        list.add(
          CartRequest(
            stockId: element.product?.stock?.id,
            quantity: element.quantity,
            parentId: stockId ?? state.selectedStock?.id ?? "",
          ),
        );
      }
    }

    final response = isGroupOrder
        ? await _cartRepository.insertCartWithGroup(
            cart: CartRequest(
              shopId: state.productData?.shopId ?? "",
              cartId: cartId,
              userUuid: userUuid,
              productId: state.productData?.uuid,
              stockId: stockId ?? state.selectedStock?.id ?? "",
              quantity: count ?? state.count,
              carts: list,
            ),
          )
        : await _cartRepository.insertCart(
            cart: CartRequest(
              shopId: state.productData?.shopId ?? "",
              productId: state.productData?.uuid,
              stockId: stockId ?? state.selectedStock?.id ?? "",
              quantity: count ?? state.count,
              carts: list,
            ),
          );

    response.when(
      success: (data) {
        state = state.copyWith(isAddLoading: false);
        onSuccess();
      },
      failure: (failure, status) {
        state = state.copyWith(isAddLoading: false);
        if (status == 400) {
          onError?.call();
        } else {
          AppHelpers.showCheckTopSnackBar(context, failure);
        }
      },
    );
  }

  void generateShareLink(String? shopId) async {
    if (state.productData?.uuid == null) return;
    final productLink =
        '${AppConstants.webUrl}/shop/$shopId?product=${state.productData?.uuid}/';
    // Simplified: in real app, call Firebase API as shown in original
    shareLink = productLink;
  }

  Future shareProduct() async {
    await Share.share(
      shareLink ?? '',
      subject: state.productData?.translation?.title ?? "Spazafy",
    );
  }
}
