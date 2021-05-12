import 'package:flutter/cupertino.dart';
import 'package:flutter_mqtt_exam/models/message_model.dart';

class MqtModel with ChangeNotifier {
  var _message = <MessageModel>[];

  List<MessageModel> get message => _message;

  void addMessage(MessageModel message) {
    _message.add(message);
    notifyListeners();
  }
}
