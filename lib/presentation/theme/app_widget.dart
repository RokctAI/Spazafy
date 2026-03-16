import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/app/app_provider.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

import '../components/custom_range_slider.dart';
import '../routes/app_router.dart';

class AppWidget extends ConsumerWidget {
  AppWidget({super.key});

  final appRouter = AppRouter();

  Future fetchSetting() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect.contains(ConnectivityResult.mobile) ||
        connect.contains(ConnectivityResult.ethernet) ||
        connect.contains(ConnectivityResult.wifi)) {
      settingsRepository.getGlobalSettings();
      await settingsRepository.getLanguages();
      await settingsRepository.getMobileTranslations();
      await settingsRepository.getTranslations();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.refresh(appProvider);
    return FutureBuilder(
      future: Future.wait([
        FlutterDisplayMode.setHighRefreshRate(),
        setUpDependencies(),
        LocalStorage.init(),
        if (LocalStorage.getTranslations().isEmpty) fetchSetting(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(375, 812),
          builder: (context, child) {
            return RefreshConfiguration(
              footerBuilder: () => const ClassicFooter(
                idleIcon: SizedBox.shrink(),
                idleText: '',
                noDataText: '',
                noMoreIcon: null,
                loadingText: '',
                loadingIcon: CupertinoActivityIndicator(),
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              headerBuilder: () => const WaterDropMaterialHeader(
                backgroundColor: AppStyle.white,
                color: AppStyle.textGrey,
                distance: 30,
              ),
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerDelegate: appRouter.delegate(),
                routeInformationParser: appRouter.defaultRouteParser(),
                locale: Locale(state.activeLanguage?.locale ?? 'en'),
                theme: ThemeData(
                  useMaterial3: false,
                  sliderTheme: SliderThemeData(
                    overlayShape: SliderComponentShape.noOverlay,
                    rangeThumbShape: CustomRoundRangeSliderThumbShape(
                      enabledThumbRadius: 12.r,
                    ),
                  ),
                ),
                themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) => ScrollConfiguration(
                  behavior: CustomBehavior(),
                  child: child!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildChildLayout(BuildContext context, Widget child) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
