import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/routes/driver/app_router.dart';
import 'package:rokctapp/presentation/theme/driver/app_style.dart';

@RoutePage()
class NoConnectionPage extends ConsumerWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppStyle.white,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FlutterRemix.wifi_off_fill,
              size: 120,
              color: AppStyle.black,
            ),
            const SizedBox(height: 20),
            Text(
              AppHelpers.getTranslation(TrKeys.noInternetConnection),
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                color: AppStyle.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.replaceRoute(const SplashRoute());
              },
              child: const Icon(
                FlutterRemix.restart_fill,
                color: AppStyle.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
