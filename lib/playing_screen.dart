import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
    init();
  }

  void init() {
    setOrientationLandscape();
    enterFullScreen();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("$url")).paddingAll(10));
  }
}
