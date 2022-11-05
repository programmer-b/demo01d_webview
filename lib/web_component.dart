import 'dart:developer';

import 'package:demo01d_webview/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

class WebComponent extends StatefulWidget {
  const WebComponent(
      {super.key, this.webViewPopupController, required this.url});

  final InAppWebViewController? webViewPopupController;
  final String url;

  @override
  State<WebComponent> createState() => _WebComponentState();
}

class _WebComponentState extends State<WebComponent> {
  late String url = widget.url;

  InAppWebViewController? webViewController;
  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
          supportMultipleWindows: false, useShouldInterceptRequest: true));

  final InAppWebViewGroupOptions options2 = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        // javaScriptCanOpenWindowsAutomatically: true,
        useShouldInterceptAjaxRequest: true,
        // useShouldInterceptFetchRequest: true
      ),
      android: AndroidInAppWebViewOptions(
          // supportMultipleWindows: true,
          useShouldInterceptRequest: true));

  Widget _web() => InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        initialOptions: options2,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        androidShouldInterceptRequest: (controller, request) async {
          // log(" androidShouldInterceptRequest: $request");
          final uri = request.url;
          final params = uri.queryParameters;

          if (params["usr"] != null) {
            log("$uri");
            context.read<MyProvider>().masterUrlSet(uri);
          }

          return null;
        },
        onAjaxReadyStateChange: (controller, ajaxRequest) async {
          // log("onAjaxReadyStateChange: ${ajaxRequest.responseText}");
          String response = ajaxRequest.responseText ?? "";
          if (response != "") {
            var document = parse(response);

            final iframe = document.getElementsByTagName("iframe");
            if (iframe.isNotEmpty) {
              final srcDoc = iframe[0].attributes["src"];

              final masterUrl = srcDoc;
              // log('MASTER URL: $masterUrl');
              if (Uri.tryParse(masterUrl ?? "")?.hasAbsolutePath ?? false) {
                controller
                    .loadUrl(
                        urlRequest: URLRequest(url: Uri.parse(masterUrl ?? "")))
                    .then((value) => controller.setOptions(options: options));
              }
            }
          }
          return AjaxRequestAction.PROCEED;
        },
        shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
          // log("shouldInterceptAjaxRequest: $ajaxRequest");
          return ajaxRequest;
        },
        onAjaxProgress:
            (InAppWebViewController controller, AjaxRequest ajaxRequest) async {
          // log("STATUS CODE", error: ajaxRequest.status);
          return AjaxRequestAction.PROCEED;
        },
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          // log("shouldInterceptFetchRequest: $fetchRequest");
          return fetchRequest;
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          // log("onReceivedServerTrustAuthRequest: $challenge");
          return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED);
        },
        onLoadStart: (controller, url) {},
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          // var uri = navigationAction.request.body;
          // log("shouldOverrideUrlLoading: $uri");

          return NavigationActionPolicy.CANCEL;
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: '''
document.getElementById('prime').click()
''');
        },
        onProgressChanged: (controller, progress) {},
        onUpdateVisitedHistory: (controller, url, androidIsReload) {},
        onConsoleMessage: (controller, consoleMessage) {
          // log("onConsoleMessage: ${jsonDecode("$consoleMessage")}");
        },
      );

  @override
  Widget build(BuildContext context) {
    log("running web");
    return _web();
  }
}
