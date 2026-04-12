import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/foods/foods_body.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/extras/extras_body.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/addons/addons_body.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/buttons/manager/buttons_bouncing_effect.dart';
import 'package:rokctapp/presentation/components/helper/keyboard_disable.dart';
import 'package:rokctapp/presentation/components/tab_bars/custom_app_bar.dart';
import 'package:rokctapp/presentation/components/text_fields/manager/search_text_field.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class FoodsPage extends ConsumerStatefulWidget {
  const FoodsPage({super.key});

  @override
  ConsumerState<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends ConsumerState<FoodsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late RefreshController _categoryController;
  late RefreshController _productController;
  late RefreshController _addonsController;
  late RefreshController _extrasController;
  late RefreshController _comboController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            ref.read(foodTabsProvider.notifier).setSelectedIndex(0);
            break;
          case 1:
            ref.read(foodTabsProvider.notifier).setSelectedIndex(1);
            break;
          case 2:
            ref.read(foodTabsProvider.notifier).setSelectedIndex(2);
            break;
          default:
            ref.read(foodTabsProvider.notifier).setSelectedIndex(0);
            break;
        }
      }
    });
    _scrollController = ScrollController();
    _categoryController = RefreshController();
    _productController = RefreshController();
    _comboController = RefreshController();
    _addonsController = RefreshController();
    _extrasController = RefreshController();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse) {
        ref.read(mainProvider.notifier).changeScrolling(true);
      } else {
        ref.read(mainProvider.notifier).changeScrolling(false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(categoriesProvider.notifier)
          .fetchCategories(context, isRefresh: true);
      ref.read(foodsProvider.notifier).initialFetchFoods();
      ref.read(addonsProvider.notifier).initialFetchAddons();
      ref.read(extrasProvider.notifier).fetchGroups();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _categoryController.dispose();
    _productController.dispose();
    _comboController.dispose();
    _addonsController.dispose();
    _extrasController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDisable(
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CustomAppBar(
              bottomPadding: 4.h,
              child: Consumer(
                builder: (context, ref, child) {
                  final foodsEvent = ref.read(foodsProvider.notifier);
                  final categoriesState = ref.watch(allCategoriesProvider);
                  return SearchTextField(
                    onChanged: (value) => foodsEvent.setQuery(
                      query: value,
                      categoryId: categoriesState.activeIndex == 1
                          ? null
                          : categoriesState
                                .categories[categoriesState.activeIndex - 2]
                                .id,
                    ),
                    suffixIcon: ButtonsBouncingEffect(
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FlutterRemix.equalizer_fill,
                          color: AppStyle.blackColor,
                          size: 20.r,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          floating: true,
                          backgroundColor: AppStyle.transparent,
                          elevation: 0,
                          titleSpacing: 0,
                          toolbarHeight: 48.h,
                          title: Container(
                            padding: REdgeInsets.all(6),
                            margin: REdgeInsets.symmetric(horizontal: 16),
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: AppStyle.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppStyle.tabBarBorderColor,
                              ),
                            ),
                            child: TabBar(
                              onTap: (index) {},
                              controller: _tabController,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppStyle.blackColor,
                              ),
                              labelColor: AppStyle.white,
                              unselectedLabelColor: AppStyle.textGrey,
                              unselectedLabelStyle: AppStyle.interRegular(
                                size: 14,
                              ),
                              labelStyle: AppStyle.interSemi(size: 14),
                              tabs: [
                                Tab(
                                  child: Text(
                                    help.AppHelpers.getTranslation(
                                      TrKeys.foods,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    help.AppHelpers.getTranslation(
                                      TrKeys.addons,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    help.AppHelpers.getTranslation(
                                      TrKeys.extras,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                body: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    FoodsBody(
                      categoryController: _categoryController,
                      productController: _productController,
                    ),
                    AddonsBody(addonsController: _addonsController),
                    ExtrasBody(refreshController: _extrasController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
