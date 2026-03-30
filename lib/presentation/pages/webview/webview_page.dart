import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/application/webview/preloaded_webview_provider.dart';

class WebViewPage extends ConsumerStatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final preloadedState = ref.read(preloadedWebViewProvider);

    // Check if we have a preloaded webview for this URL
    if (preloadedState != null && preloadedState.url == widget.url) {
      controller = preloadedState.controller;
      isLoading = !preloadedState.isReady;
    } else {
      // If not preloaded or URL doesn't match, initialize a new controller
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
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
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // The WebView is always present but initially invisible if still loading
          Opacity(
            opacity: isLoading ? 0.0 : 1.0,
            child: WebViewWidget(controller: controller),
          ),
          // Loading indicator shows while content is loading
          if (isLoading)
            Center(child: CircularProgressIndicator(color: AppStyle.primary)),
        ],
      ),
    );
  }
}
