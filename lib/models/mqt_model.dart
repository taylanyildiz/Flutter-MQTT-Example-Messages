import 'package:flutter/cupertino.dart';
import 'package:flutter_mqtt_exam/models/message_model.dart';

class MQTTModel with ChangeNotifier {
  var _message = <Messages>[];

  List<Messages> get message => _message;

  void addMessage(Messages message) {
    _message.add(message);
    notifyListeners();
  }
}
