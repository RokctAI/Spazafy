import 'package:auto_route/auto_route.dart';
import 'package:rokctapp/presentation/driver/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/providers_driver.dart';
import 'package:rokctapp/presentation/routes/driver/app_router.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(splashProvider.notifier)
          .fetchTranslations(
            context: context,
            noConnection: () => context.replaceRoute(const NoConnectionRoute()),
            goMain: () => context.replaceRoute(const HomeRoute()),
            goLogin: () => context.replaceRoute(const LoginRoute()),
            setDriverData: ref.read(driverProvider.notifier).setDriverData,
            onBecome: () => context.replaceRoute(const BecomeDriverRoute()),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Image.asset(Assets.imageSplash, fit: BoxFit.cover);
  }
}
