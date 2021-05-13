import 'dart:developer';
import 'package:flutter_mqtt_exam/models/models.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MQTTService({
    this.host,
    this.port,
    this.topic,
    this.model,
    this.isMe = false,
  });

  final MQTTModel? model;

  final String? host;

  final int? port;

  final String? topic;

  late MqttServerClient _client;

  bool isMe;

  void initializeMQTTClient() {
    _client = MqttServerClient(host!, 'taylanyildz')
      ..port = port
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 20
      ..onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('taylanyildz')
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting....');
    _client.connectionMessage = connMess;
  }

  Future connectMQTT() async {
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      log(e.toString());
      _client.disconnect();
    }
  }

  void disConnectMQTT() {
    try {
      _client.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  void onConnected() {
    log('Connected');

    try {
      _client.subscribe(topic!, MqttQos.atLeastOnce);
      _client.updates!.listen((dynamic t) {
        final MqttPublishMessage recMess = t[0].payload;
        final message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

        print('message id : ${recMess.variableHeader?.messageIdentifier}');
        print('message : $message');
        int id = model!.message.length + 1;
        model!
            .addMessage(Messages(id: isMe ? 0 : id, msg: message, time: 'now'));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void onDisConnected() {
    log('Disconnected');
  }

  void puslish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client.publishMessage(
        'sensor/home', MqttQos.atLeastOnce, builder.payload!);
    builder.clear();
  }

  void onSubscribed(String topic) {
    log(topic);
  }
}
