import 'dart:async';
import 'package:flutter/foundation.dart';

class ToastProvider extends ChangeNotifier{
  String? _message;
  Timer? _timer;

  String? get message => _message;

  void show(String text) {
    _timer?.cancel();
    _message = text;
    notifyListeners();
    _timer = Timer(const Duration(milliseconds: 2600), (){
      _message = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}