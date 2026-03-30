import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

final preloadedWebViewProvider = StateProvider<PreloadedWebViewState?>(
  (ref) => null,
);

class PreloadedWebViewState {
  final WebViewController controller;
  final String url;
  final bool isReady;

  PreloadedWebViewState({
    required this.controller,
    required this.url,
    this.isReady = false,
  });

  PreloadedWebViewState copyWith({
    WebViewController? controller,
    String? url,
    bool? isReady,
  }) {
    return PreloadedWebViewState(
      controller: controller ?? this.controller,
      url: url ?? this.url,
      isReady: isReady ?? this.isReady,
    );
  }
}

class PreloadedWebViewService {
  static void preloadWebView(WidgetRef ref, String url, BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            ref.read(preloadedWebViewProvider.notifier).state = ref
                .read(preloadedWebViewProvider)
                ?.copyWith(isReady: true);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppConstants.baseUrl)) {
              AppHelpers.goHome(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    ref.read(preloadedWebViewProvider.notifier).state = PreloadedWebViewState(
      controller: controller,
      url: url,
    );
  }
}
