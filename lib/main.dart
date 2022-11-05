import 'package:demo01d_webview/prepare_screen.dart';
import 'package:demo01d_webview/provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide log;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        theme:
            ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  late TextEditingController controller;
  late String url = "https://ww1.goojara.to/mN9by4";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: url);

    setOrientationPortrait();
    exitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textForm(),
            _divide(),
            _playButton(),
            _divide(),
            _downloadButton()
          ],
        ).paddingAll(16),
      ),
    );
  }

  Widget _textForm() => TextFormField(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      );

  Widget _playButton() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () =>
              PreparingScreen(url: controller.text).launch(context),
          child: const Text("Watch Now")));

  Widget _downloadButton() => SizedBox(
      width: double.infinity,
      child:
          ElevatedButton(onPressed: () {}, child: const Text("Download Now")));

  Widget _divide() => 10.height;
}
