import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A service class for handling WebSocket connections for individual devices.
/// This class encapsulates a WebSocket channel and profied method to send data,
/// close the connection, and check if the connection is open.
class DeviceWsService {
  final WebSocketChannel _channel;
  final Stream<String> stream;

  DeviceWsService(this._channel, this.stream);

  bool _isClosed = false;

  /// Sends data over the WebSocket connection.
  /// If data is not a string, it converts it to a string.
  /// Logs the payload and rethrow any errors.
  void send(dynamic data) {
    try {
      final payload = data is String ? data : data.toString();
      print('DeviceWsHandle.send -> ${payload.replaceAll("\n", "\\n")}');
      _channel.sink.add(payload);
    } catch (e) {
      print('DeviceWsHandle.send error: $e');
      rethrow;
    }
  }

  /// Closes the WebSocket connection
  Future<void> close() async {
    _isClosed = true;
    await _channel.sink.close();
  }

  /// Checks if the WebSocket connection is open.
  /// Note: WebSocketChannel does not expose readyState, so this is a best-effort check.
  bool get isOpen => !_isClosed;
}
