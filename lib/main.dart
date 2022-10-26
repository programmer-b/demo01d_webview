import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter web demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  InAppWebViewController? webViewController;
  InAppWebViewController? webViewPopupController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
          supportMultipleWindows: true, useShouldInterceptRequest: true));
  InAppWebViewGroupOptions options2 = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          // javaScriptCanOpenWindowsAutomatically: true,
          useShouldInterceptAjaxRequest: true,
          useShouldInterceptFetchRequest: true),
      android: AndroidInAppWebViewOptions(
          // supportMultipleWindows: true,
          useShouldInterceptRequest: true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://www.wootly.ch/g/yld1SwAYm9vkSY_4rGWmxw/1666793155/2360585336/F5SAEEE4")),
        initialOptions: options2,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        androidShouldInterceptRequest: (controller, request) async {
          log(" androidShouldInterceptRequest: $request");
          return null;
        },
        onAjaxReadyStateChange: (controller, ajaxRequest) async {
          log("onAjaxReadyStateChange: $ajaxRequest");
          return AjaxRequestAction.PROCEED;
        },
        shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
          log("shouldInterceptAjaxRequest: $ajaxRequest");
          return ajaxRequest;
        },
        onAjaxProgress:
            (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
          log("STATUS CODE", error: ajaxRequest.status);
          return AjaxRequestAction.PROCEED;
        },
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          log("shouldInterceptFetchRequest: $fetchRequest");
          return fetchRequest;
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          log("onReceivedServerTrustAuthRequest: $challenge");
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
        onCreateWindow: (controller, createWindowRequest) async {
          log("onCreateWindow");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: InAppWebView(
                    // Setting the windowId property is important here!
                    windowId: createWindowRequest.windowId,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewPopupController = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, Uri? url) {
                      log("onLoadStart popup $url");
                    },
                    onLoadStop: (InAppWebViewController controller, Uri? url) {
                      log("onLoadStop popup $url");
                    },
                  ),
                ),
              );
            },
          );

          return true;
        },
        onLoadStart: (controller, url) {},
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.body;
          log("shouldOverrideUrlLoading: $uri");

          return NavigationActionPolicy.CANCEL;
        },
        onLoadStop: (controller, url) async {},
        onProgressChanged: (controller, progress) {},
        onUpdateVisitedHistory: (controller, url, androidIsReload) {},
        onConsoleMessage: (controller, consoleMessage) {
          log("onConsoleMessage: ${jsonDecode("$consoleMessage")}");
        },
      ),

    );
  }
}
