import 'package:flutter/cupertino.dart';

class Messages {
  Messages({
    this.id,
    this.msg,
    this.time,
  });

  final int? id;
  final String? msg;
  final String? time;

  @override
  bool operator ==(Object other) {
    return identical(this, other) &&
        (other is Messages) &&
        other.msg == msg &&
        other.id == id &&
        other.time == time;
  }

  @override
  int get hashCode =>
      msg.runtimeType.hashCode ^
      id.runtimeType.hashCode ^
      time.runtimeType.hashCode;
}
