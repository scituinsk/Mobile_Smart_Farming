import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';

class RelayController extends GetxController {
  final RelayServices _relayServices;
  RelayController(this._relayServices);

  RxList<Relay> get relays => _relayServices.relays;
  RxList<GroupRelay> get groupsRelay => _relayServices.groupsRelay;

  RxBool get isLoading => _relayServices.isLoading;

  Future<void> initRelayAndGroup(String serialId) async {
    try {
      await _relayServices.loadRelaysAndAssignToGroupRelays(serialId);
    } catch (e) {
      rethrow;
    }
  }
}
