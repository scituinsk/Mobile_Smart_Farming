import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_item.dart';

class RelayGroup extends StatelessWidget {
  final List<Relay>? relays;
  final String groupName;
  const RelayGroup({super.key, required this.relays, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Grub: $groupName", style: AppTheme.h4),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: BoxBorder.all(color: AppTheme.titleSecondary, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),

            child: relays != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: relays!.length,
                    itemBuilder: (context, index) {
                      return RelayItem(
                        customIcon: MyCustomIcon.waterDrop,
                        title: relays![index].name,
                        description: "testing",
                      );
                    },
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
