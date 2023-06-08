import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports
import 'package:shared_preferences/shared_preferences.dart';

class WebViewExample extends StatefulWidget {
  final String webViewURL;
  const WebViewExample({super.key, required this.webViewURL});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  late SharedPreferences _preferences; // SharedPreferences instance
  String _loggedInUsername = '';

  @override
  void initState() {
    super.initState();
    _initSharedPreferences(); // Initialize SharedPreferences

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            {
              // Check if the USER cookie exists
              final cookieExists =
                  await controller.runJavaScriptReturningResult('''
              document.cookie.includes('USER=');
            ''');

              if (cookieExists == true) {
                // Fetch the cookie value
                final loggedInUsername =
                    await controller.runJavaScriptReturningResult('''
                document.cookie
                  .split('; ')
                  .find(row => row.startsWith('USER='))
                  .split('=')[1];
              ''');
                debugPrint('LOGGED IN USER IS: ${loggedInUsername.toString()}');
                setState(() {
                  _loggedInUsername = loggedInUsername.toString();
                });
                // Save _loggedInUsername to SharedPreferences
                await _saveLoggedInUsername(loggedInUsername.toString());
              } else {
                await _saveLoggedInUsername("Unauthorized");
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('Blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('Allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'ToFlutter',
        onMessageReceived: (JavaScriptMessage message) {
          final username = message.message;
          debugPrint('Received username from WebView: $username');
          setState(() {
            _loggedInUsername = username;
          });
        },
      )
      ..loadRequest(Uri.parse(widget.webViewURL));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    _controller = controller;
  }

// Initialize SharedPreferences instance
  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save the _loggedInUsername value to SharedPreferences
  Future<void> _saveLoggedInUsername(String username) async {
    await _preferences.setString('loggedInUsername', username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: _controller),
    );
  }

  // void _fetchLoggedInUsername(WebViewController controller) async {
  //   final loggedInUsername = await controller.runJavaScriptReturningResult('''
  //   // Replace 'getLoggedInUsername()' with the JavaScript function
  //   // that returns the logged-in username from your website.
  //   getLoggedInUsername();
  // ''');
  //   debugPrint('Fetched logged-in username from WebView: $loggedInUsername');
  //   setState(() {
  //     _loggedInUsername = loggedInUsername.toString();
  //   });
  // }
}
