import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:venderfoodyman/application/billing/billing_provider.dart';
import 'package:venderfoodyman/application/providers.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';
import 'package:venderfoodyman/presentation/component/components.dart';
import 'package:venderfoodyman/presentation/styles/style.dart';

class BillingBrowseModal extends ConsumerStatefulWidget {
  final ScrollController controller;

  const BillingBrowseModal({super.key, required this.controller});

  @override
  ConsumerState<BillingBrowseModal> createState() => _BillingBrowseModalState();
}

class _BillingBrowseModalState extends ConsumerState<BillingBrowseModal> {
  late RefreshController _categoryController;
  late RefreshController _productController;

  @override
  void initState() {
    super.initState();
    _categoryController = RefreshController();
    _productController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(orderProductsProvider.notifier)
          .fetchProducts(
            categoryId: null,
            isRefresh: true,
            isOpeningPage: true,
          );
      ref
          .read(categoriesProvider.notifier)
          .fetchCategories(context, isRefresh: true);
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billingState = ref.watch(billingProvider);
    final List<Stock> cartStocks = billingState.cartItems
        .map((e) => e.product.stock?.copyWith(cartCount: e.quantity) ?? Stock())
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppStyle.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          8.verticalSpace,
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppStyle.greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          16.verticalSpace,
          _buildSearch(cartStocks),
          16.verticalSpace,
          _buildCategories(cartStocks),
          Expanded(child: _buildProducts(cartStocks)),
        ],
      ),
    );
  }

  Widget _buildSearch(List<Stock> cartStocks) {
    return SearchTextField(
      onChanged: (value) {
        final categoriesState = ref.read(categoriesProvider);
        ref.read(orderProductsProvider.notifier).setQuery(
              query: value,
              cartStocks: cartStocks,
              categoryId: categoriesState.activeIndex == 1
                  ? null
                  : categoriesState
                      .categories[categoriesState.activeIndex - 2]
                      .id,
            );
      },
    );
  }

  Widget _buildCategories(List<Stock> cartStocks) {
    final categoriesState = ref.watch(categoriesProvider);
    final categoriesEvent = ref.read(categoriesProvider.notifier);
    final productsEvent = ref.read(orderProductsProvider.notifier);

    return SizedBox(
      height: 36.h,
      child: CategoriesTabBar(
        categories: categoriesState.categories,
        activeIndex: categoriesState.activeIndex,
        refreshController: _categoryController,
        onChangeTab: (index) {
          categoriesEvent.setActiveIndex(index);
          productsEvent.fetchProducts(
            refreshController: _productController,
            categoryId:
                index == 1 ? null : categoriesState.categories[index - 2].id,
            isRefresh: true,
            cartStocks: cartStocks,
          );
        },
        onLoading: () => categoriesEvent.fetchCategories(
          context,
          controller: _categoryController,
        ),
      ),
    );
  }

  Widget _buildProducts(List<Stock> cartStocks) {
    final productsState = ref.watch(orderProductsProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final productsEvent = ref.read(orderProductsProvider.notifier);
    final billingEvent = ref.read(billingProvider.notifier);

    return ProductsBody(
      isLoading: productsState.isLoading,
      products: productsState.products,
      refreshController: _productController,
      onRefreshing: () => productsEvent.fetchProducts(
        refreshController: _productController,
        isRefresh: true,
        cartStocks: cartStocks,
        categoryId: categoriesState.activeIndex == 1
            ? null
            : categoriesState.categories[categoriesState.activeIndex - 2].id,
      ),
      onLoading: () => productsEvent.fetchProducts(
        refreshController: _productController,
        cartStocks: cartStocks,
        categoryId: categoriesState.activeIndex == 1
            ? null
            : categoriesState.categories[categoriesState.activeIndex - 2].id,
      ),
      onProductTap: (index) {
        final product = productsState.products[index];
        billingEvent.addToCart(product);
        AppHelpers.showCheckTopSnackBar(
          context,
          text: '${product.translation?.title} added to cart',
          type: SnackBarType.success,
        );
      },
    );
  }
}
