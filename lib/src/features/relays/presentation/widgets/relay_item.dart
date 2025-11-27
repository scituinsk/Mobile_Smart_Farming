import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';
import 'package:pak_tani/src/features/relays/presentation/widgets/relay_modals.dart';

class RelayItem extends StatelessWidget {
  final Relay relay;
  final bool isEditMode;
  const RelayItem({super.key, required this.relay, this.isEditMode = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: relay.status
            ? AppTheme.waterPumpColor.withValues(alpha: 0.1)
            : AppTheme.temperatureColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(
          color: relay.status
              ? AppTheme.waterPumpColor.withValues(alpha: 0.4)
              : AppTheme.temperatureColor.withValues(alpha: 0.4),
        ),
      ),
      // margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyIcon(
            customIcon: relay.type.icon,
            backgroundColor: AppTheme.primaryColor,
            iconColor: Colors.white,
            iconSize: 30,
            padding: 4,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(relay.name, style: AppTheme.h4),
                if (relay.descriptions != null)
                  Text(
                    relay.descriptions!,
                    style: AppTheme.textAction,
                    softWrap: true,
                  ),
              ],
            ),
          ),
          if (isEditMode)
            MyIcon(
              icon: Icons.edit_outlined,
              backgroundColor: AppTheme.primaryColor,
              iconColor: Colors.white,
              iconSize: 19,
              padding: 5,
              onPressed: () {
                RelayModals.showEditRelayModal(context, relay);
              },
            ),
        ],
      ),
    );
  }
}
