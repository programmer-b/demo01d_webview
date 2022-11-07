import 'package:demo01d_webview/provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key, required this.masterUrl});
  final Uri masterUrl;

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  late Uri url = widget.masterUrl;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => context.read<MyProvider>().init());
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("$url")).paddingAll(10));
  }
}
