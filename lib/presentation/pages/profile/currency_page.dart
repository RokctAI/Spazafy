import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/currency/currency_provider.dart';
import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/application/shop_order/shop_order_provider.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/keyboard_dismisser.dart';
import 'package:rokctapp/presentation/components/loading/loading.dart';
import 'package:rokctapp/presentation/components/title/title_icon.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/pages/profile/widgets/currency_item.dart';

class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguagePageState();
}

class _LanguagePageState extends ConsumerState<CurrencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currencyProvider.notifier).fetchCurrency(context);
    });
  }

  @override
  void deactivate() {
    ref
        .read(profileProvider.notifier)
        .fetchUser(context, refreshController: RefreshController());
    ref.read(shopOrderProvider.notifier).getCart(context, () {});
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final event = ref.read(currencyProvider.notifier);
    final state = ref.watch(currencyProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.bgGrey.withOpacity(0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height *
                0.3, // Use only 30% of screen height
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: state.isLoading
                ? const Loading()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Center(
                        child: Container(
                          height: 4.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: AppStyle.dragElement,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.r),
                            ),
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.currencies),
                        paddingHorizontalSize: 0,
                        titleSize: 18,
                      ),
                      24.verticalSpace,
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          return CurrencyItem(
                            onTap: () => event.change(index),
                            isActive: state.index == index,
                            title:
                                "${state.list[index].title ?? ""} - ${state.list[index].symbol ?? ""}",
                          );
                        },
                      ),
                      24.verticalSpace,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
