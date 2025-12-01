import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {
      if (!isConnected.value) {
        print("🌐 Internet Connection Restored");
        isConnected.value = true;
      }
    } else {
      if (isConnected.value) {
        print("🚫 Internet Connection Lost");
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
