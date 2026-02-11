import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/models/websocket_message.dart';
import 'package:pak_tani/src/core/services/device_ws_service.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service class for managing WebSocket connections.
/// This class handles the main WebSocket connection, device-specific stream,
/// reconnection logic, and caching of device handles.
/// It uses GetX for state management and provides streams for messages and connection status.
class WebSocketService extends GetxService {
  WebSocketChannel? _channel;

  // cache device handles per modulId
  final Map<String, DeviceWsService> _deviceHandles = {};

  //streams
  final _messageController = StreamController<WebSocketMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  //state
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _currentToken;

  //observables
  final RxBool isConnected = false.obs;

  //public streams
  Stream<WebSocketMessage> get messageStream => _messageController.stream;
  Stream<bool> get connectionStatus => _connectionController.stream;
  // bool get isOpen => _channel.closeCode == null && !_isClosed;

  @override
  void onClose() async {
    // close all device handles
    await closeAllDeviceStreams();
    super.onClose();
  }

  /// Connects to the WebSocket server using the access token.
  /// If alredy connected, does noting.
  /// Sets up listeners for messages, errors, and connection closure.
  /// Handles reconnection on failure.
  Future<void> connect(String accessToken) async {
    if (_isConnected) {
      LogUtils.d("web socket alredy connected");
      return;
    }

    try {
      _currentToken = accessToken;
      final wsUrl = Uri.parse(AppConfig.wsBaseUrl);

      _channel = IOWebSocketChannel.connect(
        wsUrl,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      _channel!.stream.listen(
        (event) {
          final message = WebSocketMessage.fromJson(jsonDecode(event));
          _messageController.add(message);
          LogUtils.d("ws datav, eent");
        },
        onError: (error) {
          LogUtils.d("ws errorr, eror");
          _setDisconnected();
          _handleReconnect();
        },
        onDone: () {
          LogUtils.d("ws closed");
          _setDisconnected();
          _handleReconnect();
        },
        cancelOnError: false,
      );
      _isConnected = true;
      isConnected.value = true;
      _connectionController.add(true);
      LogUtils.d("websocket connected (header auth)");
    } catch (e) {
      LogUtils.e("websocket connet failed", e);
      _setDisconnected();
      _handleReconnect();
    }
  }

  /// Open a modul-specific stream (creates a new connection per modulId).
  /// Creates a new connection and returns a DeviceWsService instance.
  /// The stream is broadcast and handles message decoding.
  Future<DeviceWsService> openDeviceStream({
    required String token,
    required String modulId,
  }) async {
    final uri = _buildWsUri("/device/$modulId/");
    LogUtils.d('OPEN WS -> $uri');
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
            LogUtils.d('WS[$modulId] broadcast: listener added');
          },
        );

    mapped.listen(
      (msg) => LogUtils.d('WS[$modulId] <- $msg'),
      onError: (err) => LogUtils.d('WS[$modulId] errorr, er'),
      onDone: () => LogUtils.d('WS[$modulId] done'),
      cancelOnError: false,
    );

    return DeviceWsService(ch, mapped);
  }

  /// Retrives an existing device stream for the modulId or opens a new one and caches it.
  Future<DeviceWsService> getOrOpenDeviceStream({
    required String token,
    required String modulId,
  }) async {
    final existing = _deviceHandles[modulId];
    // if (existing != null && existing.isOpen) return existing;

    if (existing != null) {
      if (existing.isOpen) {
        LogUtils.d("♻️ Menggunakan koneksi WS yang sudah ada untuk: $modulId");
        return existing;
      } else {
        await closeDeviceStream(modulId);
      }
    }

    final handle = await openDeviceStream(token: token, modulId: modulId);
    _deviceHandles[modulId] = handle;
    return handle;
  }

  /// Close and remove a cached device stream for the given modulId.
  Future<void> closeDeviceStream(String modulId) async {
    final h = _deviceHandles.remove(modulId);
    if (h != null) {
      try {
        await h.close();
      } catch (e) {
        LogUtils.e('closeDeviceStream error', e);
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

  /// Sets the connection state to disconnected and cancles timers.
  void _setDisconnected() {
    _isConnected = false;
    isConnected.value = false;
    _connectionController.add(false);
    _pingTimer?.cancel();
  }

  /// Handles reconnection by schedulling a reconnect attempt after 5 seconds.
  void _handleReconnect() {
    _reconnectTimer?.cancel();
    if (_currentToken == null) return;
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      LogUtils.d("reconnecting ws...");
      connect(_currentToken!);
    });
  }

  /// Disconnects from the WebSocket server and cleans up resources.
  void disconnect() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _setDisconnected();
  }

  /// Builds a WebSocket URI by combining the base URL with the given path.
  Uri _buildWsUri(String path) {
    final base = AppConfig.wsBaseUrl;
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$b$p');
  }
}
