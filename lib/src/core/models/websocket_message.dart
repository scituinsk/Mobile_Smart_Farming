/// Model class for WebSocket messages
/// Represent a structured message recived or sent via WebSocket, including type, data, and timestamp.

library;

import 'dart:convert';

/// Model for WebScoket messages.
class WebSocketMessage {
  /// The Type of the message (e.g., 'notification', 'update').
  final String type;

  /// The data payload of the mesage as a map.
  final Map<String, dynamic> data;

  /// The timestamp when the message was created or received.
  final DateTime timestamp;

  /// Creates a WebSocketMessage.
  /// [timestamp] defaults to the current time if not provided.
  WebSocketMessage({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Createds a WebSocketmessage from a JSON map.
  /// Parses 'type', 'data', and 'timestamp' fields. Defaults to current time if timestamp is missing.
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] ?? 'unknown',
      data: json['data'] ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  /// Creates a WebSocketMessage from raw string data.
  /// Attempts to decode JSON; falls back to a raw message if parsing fails.
  factory WebSocketMessage.fromRawData(String rawData) {
    try {
      final json = jsonDecode(rawData);
      return WebSocketMessage.fromJson(json);
    } catch (e) {
      return WebSocketMessage(type: "raw", data: {"message": rawData});
    }
  }

  /// Convert the WebSocketMessage to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "data": data,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  /// Converts the WebSocketMessage to a raw JSON string.
  String toRawData() => jsonEncode(toJson());

  @override
  String toString() => "webSocketMessage(type: $type, data: $data)";
}
