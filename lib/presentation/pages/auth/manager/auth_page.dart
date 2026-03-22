import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/app_assets.dart';
import 'package:rokctapp/presentation/pages/profile/language_page.dart';
import 'package:rokctapp/presentation/pages/auth/register/register_page.dart';
import 'package:rokctapp/presentation/pages/auth/login/login_screen.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'package:rokctapp/application/providers_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';


@RoutePage()
class ManagerAuthPage extends ConsumerStatefulWidget {
  const ManagerAuthPage({super.key});

  @override
  ConsumerState<ManagerAuthPage> createState() => _ManagerAuthPageState();
}

class _ManagerAuthPageState extends ConsumerState<ManagerAuthPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(languagesProvider.notifier).checkLanguage(context),
    );
  }

  void selectLanguage() {
    AppHelpers.showCustomModalBottomSheet(
      isDismissible: false,
      isDrag: false,
      context: context,
      modal: LanguageScreen(
        onSave: () => Navigator.pop(context),
        afterUpdate: (lang) {},
      ),
      isDarkMode: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    ref.listen(languagesProvider, (previous, next) {
      if (!next.isSelectLanguage &&
          !((previous?.isSelectLanguage ?? false) == next.isSelectLanguage)) {
        selectLanguage();
      }
    });
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imageSplash),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  30.verticalSpace,
                  Row(
                    children: [
                      Text(
                        AppHelpers.getAppName(),
                        style: AppStyle.interBold(
                          color: AppStyle.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Consumer(
                    builder: (context, ref, child) {
                      ref.watch(languagesProvider);
                      return Column(
                        children: [
                          CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.login),
                            onPressed: () =>
                                AppHelpers.showCustomModalBottomSheetWithoutIosIcon(
                                  context: context,
                                  modal: const LoginScreen(role: 'seller'),
                                  isDarkMode: false,
                                ),
                          ),
                          10.verticalSpace,
                          CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.register),
                            onPressed: () {
                              AppHelpers.showCustomModalBottomSheetWithoutIosIcon(
                                context: context,
                                modal: const RegisterPage(
                                  isOnlyEmail: true,
                                  role: 'seller',
                                ),
                                isDarkMode: false,
                              );
                            },
                            background: AppStyle.transparent,
                            textColor: AppStyle.white,
                            borderColor: AppStyle.white,
                          ),
                        ],
                      );
                    },
                  ),
                  30.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
