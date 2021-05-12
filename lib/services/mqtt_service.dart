import 'dart:developer';

import 'package:flutter_mqtt_exam/models/message_model.dart';
import 'package:flutter_mqtt_exam/models/models.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;

  MqtModel? state;

  MqttService({this.state});

  void initializeMQTTClient(String? host, String topic) {
    _client = MqttServerClient('77.245.151.85', 'taylanyildz')
      ..secure = false
      ..port = 1883
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..onConnected = onConnected
      ..onDisconnected = onDisConnected
      ..onSubscribed = onSubscribed;

    _connection();
  }

  void onConnected() async {
    log('connected');
  }

  void onDisConnected() {
    log('disconected');
  }

  void onSubscribed(String topic) {
    log('subscribed : $topic');
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      print('payload is ==> $pt');
      if (state != null) {
        state!.addMessage(MessageModel(
            id: 1,
            message: pt,
            time: '${DateTime.now().hour}:${DateTime.now().minute}'));
      }
    });
  }

  void publish(String message, String? topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic!, MqttQos.atMostOnce, builder.payload!);
    if (state != null) {
      state!.addMessage(MessageModel(
          id: 0,
          message: message,
          time: '${DateTime.now().hour}:${DateTime.now().minute}'));
    }
  }

  void _connection() async {
    try {
      await _client!.connect();
    } on NoConnectionException catch (e) {
      log('error : ${e.toString()}');
    }
    _client!.subscribe('sensor/home', MqttQos.atLeastOnce);
  }
}
