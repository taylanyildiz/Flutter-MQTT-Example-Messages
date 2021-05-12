import 'package:flutter/cupertino.dart';

class InputModel with ChangeNotifier {
  bool _visibility = true;

  bool get visibility => _visibility;

  void setVisibility() {
    _visibility = !_visibility;
    notifyListeners();
  }
}
