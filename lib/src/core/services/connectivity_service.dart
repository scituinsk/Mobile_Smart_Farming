/// Service for connectivity.
/// Use streamSubscription to provide update connectivity status

library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';

/// Service class for connectivity service.
/// Check connectivity status in user device.
class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    checkInitialConnection();
    // create stream subscription that listen on connectivityChanged to updateConnectionStatus.
    _subscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Check initial device connection then send the result to [_updateConnectionStatus] function.
  Future<void> checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  /// update connection status if conectivity result contains mobile, wifi, or ethernet.
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {
      if (!isConnected.value) {
        LogUtils.d("🌐 Internet Connection Restored");
        isConnected.value = true;
      }
    } else {
      if (isConnected.value) {
        LogUtils.d("🚫 Internet Connection Lost");
        isConnected.value = false;
      }
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
