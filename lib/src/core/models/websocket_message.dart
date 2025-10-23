import 'dart:convert';

import 'package:pak_tani/src/features/modul/domain/entities/modul_data.dart';

class WebsocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebsocketMessage({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebsocketMessage.fromJson(Map<String, dynamic> json) {
    return WebsocketMessage(
      type: json['type'] ?? 'unknown',
      data: json['data'] ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  factory WebsocketMessage.fromRawData(String rawData) {
    try {
      final json = jsonDecode(rawData);
      return WebsocketMessage.fromJson(json);
    } catch (e) {
      return WebsocketMessage(type: "raw", data: {"message": rawData});
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "data": data,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  String toRawData() => jsonEncode(toJson());

  ModulData? get deviceData {
    if (data.isNotEmpty) {
      return ModulData.fromJson(data);
    }
    return null;
  }

  @override
  String toString() => "webSocketMessage(type: $type, data: $data)";
}
