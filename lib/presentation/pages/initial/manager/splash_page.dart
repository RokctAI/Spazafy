import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:venderfoodyman/presentation/theme/manager/app_assets.dart';
import 'package:venderfoodyman/presentation/routes/manager/app_router.dart';
import 'package:venderfoodyman/application/providers/manager/providers.dart';

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
            noConnection: () {
              // Even if no connection, we allow offline usage with PIN
              context.replaceRoute(const PinLoginRoute());
            },
            goMain: () => context.replaceRoute(const PinLoginRoute()),
            goLogin: () => context.replaceRoute(const PinLoginRoute()),
            goBecome: () => context.replaceRoute(const PinLoginRoute()),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Image.asset(Assets.imageSplash, fit: BoxFit.cover);
  }
}




