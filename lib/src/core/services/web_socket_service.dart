import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/models/websocket_message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DeviceWsHandle {
  final WebSocketChannel _channel;
  final Stream<String> stream;

  DeviceWsHandle._(this._channel, this.stream);

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

  Future<void> close() async {
    await _channel.sink.close();
  }

  bool get isOpen {
    try {
      // web_socket_channel doesn't expose readyState; best-effort check
      return true;
    } catch (_) {
      return false;
    }
  }
}

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;

  // cache device handles per modulId
  final Map<String, DeviceWsHandle> _deviceHandles = {};

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
    // close all device handles
    closeAllDeviceStreams();
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

  /// Open a device-specific stream (creates a new connection per modulId).
  /// Returned stream is broadcast so many listeners (controllers) can listen safely.
  Future<DeviceWsHandle> openDeviceStream({
    required String token,
    required String modulId,
  }) async {
    final uri = _buildWsUri("/ws/device/$modulId/");
    print('OPEN WS -> $uri');
    final ch = IOWebSocketChannel.connect(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    final mapped = ch.stream
        .map((event) {
          if (event is List<int>) return utf8.decode(event);
          if (event is String) return event;
          return event?.toString() ?? '';
        })
        .asBroadcastStream(
          onListen: (sub) {
            print('WS[$modulId] broadcast: listener added');
          },
        );

    mapped.listen(
      (msg) => print('WS[$modulId] <- $msg'),
      onError: (err) => print('WS[$modulId] error: $err'),
      onDone: () => print('WS[$modulId] done'),
      cancelOnError: false,
    );

    return DeviceWsHandle._(ch, mapped);
  }

  /// Get existing handle for modulId or open a new one and cache it.
  Future<DeviceWsHandle> getOrOpenDeviceStream({
    required String token,
    required String modulId,
  }) async {
    final existing = _deviceHandles[modulId];
    if (existing != null) return existing;

    final handle = await openDeviceStream(token: token, modulId: modulId);
    _deviceHandles[modulId] = handle;
    return handle;
  }

  /// Close and remove a cached device stream
  Future<void> closeDeviceStream(String modulId) async {
    final h = _deviceHandles.remove(modulId);
    if (h != null) {
      try {
        await h.close();
      } catch (e) {
        print('closeDeviceStream error: $e');
      }
    }
  }

  /// Close all cached device streams
  Future<void> closeAllDeviceStreams() async {
    final keys = _deviceHandles.keys.toList();
    for (final k in keys) {
      await closeDeviceStream(k);
    }
    _deviceHandles.clear();
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
    final base = AppConfig.wsBaseUrl;
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$b$p');
  }
}
