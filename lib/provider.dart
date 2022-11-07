import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  Uri? _masterUrl;
  Uri? get masterUrl => _masterUrl;

  void init() {
    _masterUrl = null;
    notifyListeners();
  }

  void masterUrlSet(Uri url) {
    _masterUrl = url;
    notifyListeners();
  }
}
