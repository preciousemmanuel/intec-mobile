

// Import for Android features.
import 'package:intechpro/screens/progrees_hud.dart';
import 'package:intechpro/screens/verify_payment.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/material.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String paymentLink;
  const WebViewPaymentScreen({Key? key, required this.paymentLink})
      : super(key: key);

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  bool _loading = true;
  int _progress = 0;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();

  // @override
  // void initState() {
  //   super.initState();
  //   if (Platform.isAndroid) {
  //     WebView.platform = SurfaceAndroidWebView();
  //   }
  // }

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
print("linkdfkd${widget.paymentLink}");
    // #docregion platform_features
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
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress < 100) {
              setState(() {
                _loading = false;
              });
            }
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
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
            print("dpopop##${request.url}");
            if (request.url.contains('verify')) {
              debugPrint('blocking navigation to ${request.url}');
              var splittedString=request.url.split("&")[1];
              String reference=splittedString.replaceAll("reference=", "").trim();
               Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>  VerifyPayment(reference: reference,)));
             // Navigator.pushNamed(context, RouteLiterals.driverWallet);
              return NavigationDecision.prevent;
            }
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            // document.exitFullscreen();
           // Navigator.pushReplacementNamed(context, RouteLiterals.driverWallet);

            return NavigationDecision.prevent;
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.paymentLink));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: _loading,
      // context.watch<WalletProvider>().topUpViewState == ViewState.busy,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.leftToRight,
              //         child: const Menu()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebViewWidget(controller: _controller),
      )),
    );
  }
}
