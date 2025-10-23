import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/models/websocket_message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DeviceWsHandle {
  final WebSocketChannel _channel;
  final Stream<dynamic> stream;

  DeviceWsHandle._(this._channel, this.stream);

  void send(dynamic data) => _channel.sink.add(data);
  Future<void> close() async => _channel.sink.close();
}

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;

  //streams
  final _messageController = StreamController<WebsocketMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  //state
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _currentToken;

  //observables
  final RxBool isConnected = false.obs;

  //public streams
  Stream<WebsocketMessage> get messageStream => _messageController.stream;
  Stream<bool> get connectionStatus => _connectionController.stream;

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> connect(String token) async {
    if (_isConnected) {
      print("web socket alredy connected");
      return;
    }

    try {
      _currentToken = token;
      final wsUrl = Uri.parse(AppConfig.wsBaseUrl);

      _channel = IOWebSocketChannel.connect(
        wsUrl,
        headers: {"Authorization": "Bearer $token"},
      );

      _channel!.stream.listen(
        (event) {
          // _messageController.add(event);
          print("ws data: $event");
        },
        onError: (error) {
          print("ws error: $error");
          _setDisconnected();
          _handleReconnect();
        },
        onDone: () {
          print("ws closed");
          _setDisconnected();
          _handleReconnect();
        },
        cancelOnError: false,
      );
      _isConnected = true;
      isConnected.value = true;
      _connectionController.add(true);
      print("websocket connected (header auth)");
    } catch (e) {
      print("websocket connet failed: $e");
      _setDisconnected();
      _handleReconnect();
    }
  }

  Future<DeviceWsHandle> openDeviceStream({
    required String token,
    required String modulId,
  }) async {
    final uri = _buildWsUri("/ws/device/$modulId/");
    final ch = IOWebSocketChannel.connect(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    final mapped = ch.stream.map((event) {
      if (event is List<int>) return utf8.decode(event);
      if (event is String) return event;
      return event?.toString() ?? '';
    });

    return DeviceWsHandle._(ch, mapped);
  }

  void _setDisconnected() {
    _isConnected = false;
    isConnected.value = false;
    _connectionController.add(false);
    _pingTimer?.cancel();
  }

  void _handleReconnect() {
    _reconnectTimer?.cancel();
    if (_currentToken == null) return;
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      print("reconnecting ws...");
      connect(_currentToken!);
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _setDisconnected();
  }

  Uri _buildWsUri(String path) {
    final base = AppConfig.wsBaseUrl; // contoh: wss://api.example.com
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$b$p');
  }
}
