import 'dart:isolate';
import 'dart:ui';

import 'package:demo01d_webview/commons.dart';
import 'package:demo01d_webview/functions.dart';
import 'package:demo01d_webview/playing_screen.dart';
import 'package:demo01d_webview/provider.dart';
import 'package:demo01d_webview/web_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterDownloader.registerCallback(MyHomePage.downloadCallback);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        title: 'Flutter web demo',
        theme: ThemeData(
            brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send([id, status, progress]);
    }
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController controller;
  late String url = "https://ww1.goojara.to/mN9by4";

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: url);

    Future.delayed(Duration.zero, () => context.read<MyProvider>().init());

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
      // int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(MyHomePage.downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  bool _playPressed = false;
  get playPressed => _playPressed;

  @override
  Widget build(BuildContext context) {
    final masterUrl = context.watch<MyProvider>().masterUrl;

    if (masterUrl != null && playPressed) {
      finish(context);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PlayingScreen(
          masterUrl: masterUrl,
        ).launch(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDownloadTiles(),
            _divide(),
            _playButton(),
          ],
        ).paddingAll(16),
      ),
    );
  }

  Widget _buildDownloadTiles() => Column(
        children: List<Widget>.generate(
            downloadVideos.length,
            (index) => ListTile(
                  onTap: () {},
                  dense: true,
                  title: Text(downloadVideos[index]["title"] ?? ""),
                  trailing: IconButton(
                      onPressed: () => downloadFile(
                          url: downloadVideos[index]["url"] ?? "",
                          fileName: downloadVideos[index]["title"] ?? ""),
                      icon: const Icon(Icons.download)),
                )),
      );

  Widget _playButton() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            setState(() => _playPressed = true);
            showDialog(
              context: context,
              builder: (context) => _loadingWidget(context),
            );
          },
          child: const Text("WATCH GOOJARA MOVIE")));

  Widget _divide() => 10.height;

  final _spinkit = const SpinKitFadingCircle(
    color: Colors.white,
  );

  Widget _loadingWidget(context) => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: _spinkit.center(),
          ).center(),
          _web()
        ],
      );

  Widget _web() => Offstage(
        offstage: true,
        child: WebComponent(url: controller.text),
      );
}
