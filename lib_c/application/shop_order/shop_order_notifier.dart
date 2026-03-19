import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/cart.dart';
import 'package:rokctapp/infrastructure/models/data/addons_data.dart';
import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/infrastructure/models/request/cart_request.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/typing_delay.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'shop_order_state.dart';

class ShopOrderNotifier extends StateNotifier<ShopOrderState> {
  final CartRepositoryFacade _cartRepository;

  ShopOrderNotifier(this._cartRepository) : super(const ShopOrderState());
  final _delayed = Delayed(milliseconds: 700);

  Future<void> addCount(BuildContext context, int index, String shopId) async {
    state = state.copyWith(isAddAndRemoveLoading: true);
    final currentCart = state.carts[shopId];
    CartDetail oldDetail =
        currentCart?.userCarts?.first.cartDetails?[index] ?? CartDetail();
    CartDetail newDetail = oldDetail.copyWith(
      quantity: 1 + (oldDetail.quantity ?? 1),
    );
    if (!(((oldDetail.quantity ?? 1)) <
        (oldDetail.stock?.product?.maxQty ?? 1))) {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          "${AppHelpers.getTranslation(TrKeys.maxQty)} ${((oldDetail.quantity ?? 1))}",
        );
      }
      state = state.copyWith(isAddAndRemoveLoading: false);
      return;
    }
    List<CartDetail> newCartList = List.from(
      currentCart?.userCarts?.first.cartDetails ?? [],
    );
    newCartList.removeAt(index);
    newCartList.insert(index, newDetail);
    UserCart newCart = currentCart!.userCarts!.first.copyWith(
      cartDetails: newCartList,
    );
    List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
    newUserCart.removeAt(0);
    newUserCart.insert(0, newCart);
    Cart newDate = currentCart.copyWith(userCarts: newUserCart);

    final newCarts = Map<String, Cart?>.from(state.carts);
    newCarts[shopId] = newDate;
    state = state.copyWith(carts: newCarts);

    List<CartRequest> list = [
      CartRequest(
        stockId: newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
        quantity: newDate.userCarts?.first.cartDetails?[index].quantity ?? 1,
      ),
    ];
    for (Addons element
        in newDate.userCarts?.first.cartDetails?[index].addons ?? []) {
      list.add(
        CartRequest(
          stockId: element.stocks?.id,
          quantity: element.quantity,
          parentId:
              newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
        ),
      );
    }
    final response = await _cartRepository.insertCart(
      cart: CartRequest(
        shopId: shopId,
        stockId: newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
        quantity: newDate.userCarts?.first.cartDetails?[index].quantity ?? 1,
        carts: list,
      ),
    );
    response.when(
      success: (data) async {
        final updatedCarts = Map<String, Cart?>.from(state.carts);
        updatedCarts[shopId] = data.data;
        state = state.copyWith(
          carts: updatedCarts,
          isAddAndRemoveLoading: false,
        );
      },
      failure: (failure, status) {
        state = state.copyWith(isAddAndRemoveLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> removeCount(
    BuildContext context,
    int index,
    String shopId,
  ) async {
    state = state.copyWith(isAddAndRemoveLoading: true);
    final currentCart = state.carts[shopId];
    if ((currentCart?.userCarts?.first.cartDetails?[index].quantity ?? 1) > 1) {
      CartDetail oldDetail =
          currentCart?.userCarts?.first.cartDetails?[index] ?? CartDetail();
      CartDetail newDetail = oldDetail.copyWith(
        quantity: (oldDetail.quantity ?? 1) - 1,
      );
      List<CartDetail> newCartList = List.from(
        currentCart?.userCarts?.first.cartDetails ?? [],
      );
      newCartList.removeAt(index);
      newCartList.insert(index, newDetail);
      UserCart newCart = currentCart!.userCarts!.first.copyWith(
        cartDetails: newCartList,
      );
      List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
      newUserCart.removeAt(0);
      newUserCart.insert(0, newCart);
      Cart newDate = currentCart.copyWith(userCarts: newUserCart);

      final newCarts = Map<String, Cart?>.from(state.carts);
      newCarts[shopId] = newDate;
      state = state.copyWith(carts: newCarts);

      List<CartRequest> list = [
        CartRequest(
          stockId: newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
          quantity: newDate.userCarts?.first.cartDetails?[index].quantity ?? 1,
        ),
      ];
      for (Addons element
          in newDate.userCarts?.first.cartDetails?[index].addons ?? []) {
        list.add(
          CartRequest(
            stockId: element.stocks?.id,
            quantity: element.quantity,
            parentId:
                newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
          ),
        );
      }
      final response = await _cartRepository.insertCart(
        cart: CartRequest(
          shopId: shopId,
          stockId: newDate.userCarts?.first.cartDetails?[index].stock?.id ?? "",
          quantity: newDate.userCarts?.first.cartDetails?[index].quantity ?? 1,
          carts: list,
        ),
      );
      response.when(
        success: (data) async {
          final updatedCarts = Map<String, Cart?>.from(state.carts);
          updatedCarts[shopId] = data.data;
          state = state.copyWith(
            carts: updatedCarts,
            isAddAndRemoveLoading: false,
          );
          getCart(context, () {}, isShowLoading: false, shopId: shopId);
        },
        failure: (failure, status) {
          state = state.copyWith(isAddAndRemoveLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      final cartId = currentCart?.id ?? "";
      final cartDetailId =
          currentCart?.userCarts?.first.cartDetails?[index].id ?? "";
      List<CartDetail> newCartList = List.from(
        currentCart?.userCarts?.first.cartDetails ?? [],
      );
      newCartList.removeAt(index);
      UserCart newCart = currentCart!.userCarts!.first.copyWith(
        cartDetails: newCartList,
      );
      List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
      newUserCart.removeAt(0);
      newUserCart.insert(0, newCart);
      Cart newDate = currentCart.copyWith(userCarts: newUserCart);
      if (newDate.userCarts!.first.cartDetails!.isEmpty) {
        final responseDelete = await _cartRepository.deleteCart(cartId: cartId);
        responseDelete.when(
          success: (data) async {
            final updatedCarts = Map<String, Cart?>.from(state.carts);
            updatedCarts.remove(shopId);
            state = state.copyWith(
              isAddAndRemoveLoading: false,
              carts: updatedCarts,
            );
            context.maybePop();
            getCart(context, () {}, isShowLoading: false, shopId: shopId);
          },
          failure: (failure, status) {
            state = state.copyWith(isAddAndRemoveLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      } else {
        final newCarts = Map<String, Cart?>.from(state.carts);
        newCarts[shopId] = newDate;
        state = state.copyWith(carts: newCarts);

        final response = await _cartRepository.removeProductCart(
          cartDetailId: cartDetailId,
        );
        response.when(
          success: (data) async {
            state = state.copyWith(isAddAndRemoveLoading: false);
            getCart(context, () {}, isShowLoading: false, shopId: shopId);
          },
          failure: (failure, status) {
            state = state.copyWith(isAddAndRemoveLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(status.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> addCountWithGroup({
    required BuildContext context,
    required int productIndex,
    required int userIndex,
    required String shopId,
  }) async {
    final currentCart = state.carts[shopId];
    CartDetail oldDetail =
        currentCart?.userCarts?[userIndex].cartDetails?[productIndex] ??
        CartDetail();
    CartDetail newDetail = oldDetail.copyWith(
      quantity: 1 + (oldDetail.quantity ?? 1),
    );
    List<CartDetail> newCartList = List.from(
      currentCart?.userCarts?[userIndex].cartDetails ?? [],
    );
    newCartList.removeAt(productIndex);
    newCartList.insert(productIndex, newDetail);
    UserCart newCart = currentCart!.userCarts![userIndex].copyWith(
      cartDetails: newCartList,
    );
    List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
    newUserCart.removeAt(userIndex);
    newUserCart.insert(userIndex, newCart);
    Cart newDate = currentCart.copyWith(userCarts: newUserCart);

    final newCarts = Map<String, Cart?>.from(state.carts);
    newCarts[shopId] = newDate;
    state = state.copyWith(carts: newCarts);

    _delayed.run(() async {
      state = state.copyWith(isAddAndRemoveLoading: true);
      List<CartRequest> list = [
        CartRequest(
          stockId:
              newDate
                  .userCarts?[userIndex]
                  .cartDetails?[productIndex]
                  .stock
                  ?.id ??
              "",
          quantity:
              newDate
                  .userCarts?[userIndex]
                  .cartDetails?[productIndex]
                  .quantity ??
              1,
        ),
      ];
      for (Addons element
          in newDate.userCarts?[userIndex].cartDetails?[productIndex].addons ??
              []) {
        list.add(
          CartRequest(
            stockId: element.stocks?.id,
            quantity: element.quantity,
            parentId:
                newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .stock
                    ?.id ??
                "",
          ),
        );
      }
      final response = await _cartRepository.insertCartWithGroup(
        cart: CartRequest(
          cartId: newDate.id.toString(),
          userUuid: newDate.userCarts?[userIndex].uuid,
          shopId: shopId,
          stockId:
              newDate
                  .userCarts?[userIndex]
                  .cartDetails?[productIndex]
                  .stock
                  ?.id ??
              "",
          quantity:
              newDate
                  .userCarts?[userIndex]
                  .cartDetails?[productIndex]
                  .quantity ??
              1,
          carts: list,
        ),
      );
      response.when(
        success: (data) async {
          final updatedCarts = Map<String, Cart?>.from(state.carts);
          updatedCarts[shopId] = data.data;
          state = state.copyWith(
            carts: updatedCarts,
            isAddAndRemoveLoading: false,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isAddAndRemoveLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    });
  }

  Future<void> removeCountWithGroup({
    required BuildContext context,
    required int productIndex,
    required int userIndex,
    required String shopId,
  }) async {
    final currentCart = state.carts[shopId];
    if ((currentCart
                ?.userCarts?[userIndex]
                .cartDetails?[productIndex]
                .quantity ??
            1) >
        1) {
      CartDetail oldDetail =
          currentCart?.userCarts?[userIndex].cartDetails?[productIndex] ??
          CartDetail();
      CartDetail newDetail = oldDetail.copyWith(
        quantity: (oldDetail.quantity ?? 1) - 1,
      );
      List<CartDetail> newCartList = List.from(
        currentCart?.userCarts?[userIndex].cartDetails ?? [],
      );
      newCartList.removeAt(productIndex);
      newCartList.insert(productIndex, newDetail);
      UserCart newCart = currentCart!.userCarts![userIndex].copyWith(
        cartDetails: newCartList,
      );
      List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
      newUserCart.removeAt(userIndex);
      newUserCart.insert(userIndex, newCart);
      Cart newDate = currentCart.copyWith(userCarts: newUserCart);

      final newCarts = Map<String, Cart?>.from(state.carts);
      newCarts[shopId] = newDate;
      state = state.copyWith(carts: newCarts);

      _delayed.run(() async {
        state = state.copyWith(isAddAndRemoveLoading: true);
        List<CartRequest> list = [
          CartRequest(
            stockId:
                newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .stock
                    ?.id ??
                "",
            quantity:
                newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .quantity ??
                1,
          ),
        ];
        for (Addons element
            in newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .addons ??
                []) {
          list.add(
            CartRequest(
              stockId: element.stocks?.id,
              quantity: element.quantity,
              parentId:
                  newDate
                      .userCarts?[userIndex]
                      .cartDetails?[productIndex]
                      .stock
                      ?.id ??
                  "",
            ),
          );
        }
        final response = await _cartRepository.insertCartWithGroup(
          cart: CartRequest(
            cartId: newDate.id.toString(),
            userUuid: newDate.userCarts?[userIndex].uuid,
            shopId: shopId,
            stockId:
                newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .stock
                    ?.id ??
                "",
            quantity:
                newDate
                    .userCarts?[userIndex]
                    .cartDetails?[productIndex]
                    .quantity ??
                1,
            carts: list,
          ),
        );
        response.when(
          success: (data) async {
            final updatedCarts = Map<String, Cart?>.from(state.carts);
            updatedCarts[shopId] = data.data;
            state = state.copyWith(
              carts: updatedCarts,
              isAddAndRemoveLoading: false,
            );
            getCart(context, () {}, isShowLoading: false, shopId: shopId);
          },
          failure: (failure, status) {
            state = state.copyWith(isAddAndRemoveLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(status.toString()),
            );
          },
        );
      });
    } else {
      state = state.copyWith(isAddAndRemoveLoading: true);
      final cartId = currentCart?.id ?? "";
      final cartDetailId =
          currentCart?.userCarts?[userIndex].cartDetails?[productIndex].id ??
          "";
      List<CartDetail> newCartList = List.from(
        currentCart?.userCarts?[userIndex].cartDetails ?? [],
      );
      newCartList.removeAt(productIndex);
      UserCart newCart = currentCart!.userCarts![userIndex].copyWith(
        cartDetails: newCartList,
      );
      List<UserCart> newUserCart = List.from(currentCart.userCarts ?? []);
      newUserCart.removeAt(userIndex);
      newUserCart.insert(userIndex, newCart);
      Cart newDate = currentCart.copyWith(userCarts: newUserCart);
      if (newDate.userCarts![userIndex].cartDetails!.isEmpty) {
        final responseDelete = await _cartRepository.deleteCart(cartId: cartId);
        responseDelete.when(
          success: (data) async {
            final updatedCarts = Map<String, Cart?>.from(state.carts);
            updatedCarts.remove(shopId);
            state = state.copyWith(
              isAddAndRemoveLoading: false,
              carts: updatedCarts,
            );
            context.maybePop();
            getCart(context, () {}, isShowLoading: false, shopId: shopId);
          },
          failure: (failure, status) {
            state = state.copyWith(isAddAndRemoveLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(status.toString()),
            );
          },
        );
      } else {
        final newCarts = Map<String, Cart?>.from(state.carts);
        newCarts[shopId] = newDate;
        state = state.copyWith(carts: newCarts);

        final response = await _cartRepository.removeProductCart(
          cartDetailId: cartDetailId,
        );
        response.when(
          success: (data) async {
            state = state.copyWith(isAddAndRemoveLoading: false);
            getCart(context, () {}, isShowLoading: false, shopId: shopId);
          },
          failure: (failure, status) {
            state = state.copyWith(isAddAndRemoveLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(status.toString()),
            );
          },
        );
      }
    }
  }

  Future getCart(
    BuildContext context,
    VoidCallback onSuccess, {
    bool isShowLoading = true,
    String? shopId,
    String? cartId,
    String? userUuid,
  }) async {
    if (isShowLoading) {
      state = state.copyWith(isLoading: true);
    }
    final String activeShopId =
        shopId ?? (state.carts.keys.isNotEmpty ? state.carts.keys.first : "");
    final response = (userUuid == null || userUuid.isEmpty)
        ? await _cartRepository.getCart(activeShopId)
        : await _cartRepository.getCartInGroup(cartId, activeShopId, userUuid);
    response.when(
      success: (data) async {
        final newCarts = Map<String, Cart?>.from(state.carts);
        newCarts[activeShopId] = data.data;
        if (isShowLoading) {
          state = state.copyWith(carts: newCarts, isLoading: false);
          onSuccess();
        } else {
          state = state.copyWith(carts: newCarts);
        }
      },
      failure: (failure, status) {
        if (status == 404) {
          final newCarts = Map<String, Cart?>.from(state.carts);
          newCarts.remove(activeShopId);
          if (isShowLoading) {
            state = state.copyWith(isLoading: false, carts: newCarts);
          } else {
            state = state.copyWith(carts: newCarts);
          }
        } else if (status == 400 || status == 404) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            AppHelpers.getTranslation(TrKeys.thankYouForOrder),
          );
          final newCarts = Map<String, Cart?>.from(state.carts);
          newCarts.remove(activeShopId);
          state = state.copyWith(carts: newCarts, isStartGroup: false);
          Navigator.pop(context);
        } else if (status != 401) {
          if (isShowLoading) {
            state = state.copyWith(isLoading: false);
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        } else {
          if (isShowLoading) {
            state = state.copyWith(isLoading: false);
          }
          LocalStorage.logout();
          context.router.popUntilRoot();
          context.replaceRoute(const LoginRoute());
        }
      },
    );
  }

  Future changeStatus(
    BuildContext context,
    String? userUuid,
    String shopId,
  ) async {
    state = state.copyWith(isEditOrder: !state.isEditOrder);
    final response = await _cartRepository.changeStatus(
      userUuid: userUuid,
      cartId: state.carts[shopId]?.id.toString(),
    );
    response.when(success: (data) async {}, failure: (failure, status) {});
  }

  Future deleteCart(BuildContext context, String shopId) async {
    state = state.copyWith(isDeleteLoading: true);
    final response = await _cartRepository.deleteCart(
      cartId: state.carts[shopId]?.id ?? "",
    );
    response.when(
      success: (data) async {
        final newCarts = Map<String, Cart?>.from(state.carts);
        newCarts.remove(shopId);
        state = state.copyWith(isDeleteLoading: false, carts: newCarts);
        Navigator.pop(context);
        return;
      },
      failure: (failure, status) {
        state = state.copyWith(isDeleteLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(status.toString()),
        );
        return;
      },
    );
  }

  Future<void> deleteUser(
    BuildContext context,
    int index,
    String shopId, {
    String? userId,
  }) async {
    final currentCart = state.carts[shopId];
    if (userId == null) {
      _cartRepository.deleteUser(
        cartId: currentCart?.id ?? "",
        userId: currentCart?.userCarts?[index].uuid ?? "",
      );
      List<UserCart> list = List.from(currentCart?.userCarts ?? []);
      list.removeAt(index);
      Cart? newCart = currentCart?.copyWith(userCarts: list);

      final updatedCarts = Map<String, Cart?>.from(state.carts);
      updatedCarts[shopId] = newCart;
      state = state.copyWith(carts: updatedCarts);
    } else {
      if (context.mounted) {
        context.maybePop();
      }
      _cartRepository.deleteUser(cartId: currentCart?.id ?? "", userId: userId);
      final updatedCarts = Map<String, Cart?>.from(state.carts);
      updatedCarts.remove(shopId);
      state = state.copyWith(isStartGroup: false, carts: updatedCarts);
    }
  }

  void joinGroupOrder(BuildContext context) async {
    state = state.copyWith(isStartGroup: false);
    state = state.copyWith(isStartGroup: true);
  }

  Future<void> startGroupOrder(
    BuildContext context,
    String cartId,
    String shopId,
  ) async {
    state = state.copyWith(isStartGroup: false, isStartGroupLoading: true);
    final response = await _cartRepository.startGroupOrder(cartId: cartId);
    response.when(
      success: (data) async {
        final currentCart = state.carts[shopId];
        Cart? newCart = currentCart?.copyWith(group: true);
        final updatedCarts = Map<String, Cart?>.from(state.carts);
        updatedCarts[shopId] = newCart;
        state = state.copyWith(
          carts: updatedCarts,
          isStartGroup: true,
          isStartGroupLoading: false,
        );
      },
      failure: (failure, status) {
        state = state.copyWith(isStartGroup: false, isStartGroupLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(status.toString()),
        );
      },
    );
  }

  void createCart(BuildContext context, String shopId) async {
    state = state.copyWith(isCheckShopOrder: false, isOtherShop: false);
    state = state.copyWith(isCheckShopOrder: true);
    final response = await _cartRepository.createCart(
      cart: CartRequest(shopId: shopId),
    );
    response.when(
      success: (data) {
        final updatedCarts = Map<String, Cart?>.from(state.carts);
        updatedCarts[shopId] = data.data;
        state = state.copyWith(isCheckShopOrder: false, carts: updatedCarts);
        startGroupOrder(context, data.data?.id ?? "", shopId);
      },
      failure: (failure, status) {
        state = state.copyWith(isCheckShopOrder: false);
        if (status == 400) {
          // In multi-shop mode, 400 doesn't mean "Clear cart", but we handle it gracefully
          state = state.copyWith(isOtherShop: true);
        } else {
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        }
      },
    );
  }

  generateShareLink(
    String shopId,
    String shopName,
    String shopLogo,
    String? type,
  ) async {
    final currentCart = state.carts[shopId];
    final productLink =
        "${AppConstants.webUrl}/group/${shopId}?g=${currentCart?.id}&o=${currentCart?.ownerId}&t=${type ?? 'shop'}";

    final dynamicLink =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${AppConstants.firebaseWebKey}';

    final dataShare = {
      "dynamicLinkInfo": {
        "domainUriPrefix": AppConstants.uriPrefix,
        "link": productLink,
        "androidInfo": {
          "androidPackageName": AppConstants.androidPackageName,
          "androidFallbackLink":
              "${AppConstants.webUrl}/group/${shopId}?g=${currentCart?.id}&o=${currentCart?.ownerId}&t=${type ?? 'shop'}",
        },
        "iosInfo": {
          "iosBundleId": AppConstants.iosPackageName,
          "iosFallbackLink":
              "${AppConstants.webUrl}/group/${shopId}?g=${currentCart?.id}&o=${currentCart?.ownerId}&t=${type ?? 'shop'}",
        },
        "socialMetaTagInfo": {
          "socialTitle": AppHelpers.getTranslation(TrKeys.groupOrder),
          "socialDescription": shopName,
          "socialImageLink": shopLogo,
        },
      },
    };

    final client = dioHttp.client(requireAuth: false);
    final res = await client.post(
      'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${AppConstants.firebaseWebKey}',
      data: dataShare,
    );

    state = state.copyWith(shareLink: res.data['shortLink']);
  }
}
