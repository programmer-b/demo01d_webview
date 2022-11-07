import 'package:demo01d_webview/playing_screen.dart';
import 'package:demo01d_webview/provider.dart';
import 'package:demo01d_webview/web_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class PreparingScreen extends StatefulWidget {
  const PreparingScreen({super.key, required this.url});

  final String url;

  @override
  State<PreparingScreen> createState() => _PreparingScreenState();
}

class _PreparingScreenState extends State<PreparingScreen> {


  late String url = widget.url;
  @override
  Widget build(BuildContext context) {
    final masterUrl = context.watch<MyProvider>().masterUrl;

    if (masterUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        finish(context);
        PlayingScreen(
          masterUrl: masterUrl,
        ).launch(context);
      });
    }

    return Stack(
      children: [
        WebComponent(url: url),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Center(
              child: _spinkit,
            ))
      ],
    );
  }

  final _spinkit = const SpinKitFadingCircle(
    color: Colors.white,
  );
}
