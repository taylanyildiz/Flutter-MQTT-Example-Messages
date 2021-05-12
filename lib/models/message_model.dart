import 'package:flutter/cupertino.dart';

class MessageModel {
  MessageModel({
    this.id,
    this.message,
    this.time,
  });

  final int? id;
  final String? message;
  final String? time;

  @override
  bool operator ==(Object other) {
    return identical(this, other) &&
        (other is MessageModel) &&
        other.message == message &&
        other.id == id &&
        other.time == time;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => message.runtimeType.hashCode;
}
