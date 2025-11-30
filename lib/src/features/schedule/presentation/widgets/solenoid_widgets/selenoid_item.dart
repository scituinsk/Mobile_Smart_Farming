import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/solenoid_status_chip.dart';

class SolenoidItem extends StatelessWidget {
  final Relay relay;
  const SolenoidItem({super.key, required this.relay});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIcon(
            type: relay.type.icon2,
            color: relay.type == RelayType.lamp ? AppTheme.primaryColor : null,
            size: relay.type == RelayType.lamp ? 34 : 28,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(relay.name, style: AppTheme.text.copyWith(fontSize: 16)),
              SizedBox(height: 4),
              // Wrap dengan Align untuk positioning
              SolenoidStatusChip(status: relay.status),
            ],
          ),
        ],
      ),
    );
  }
}
