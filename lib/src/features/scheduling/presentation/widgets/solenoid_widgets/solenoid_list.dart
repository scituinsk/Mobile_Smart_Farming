import 'package:flutter/material.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/solenoid_widgets/selenoid_item.dart';

class SolenoidList extends StatelessWidget {
  const SolenoidList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: 6,
        itemBuilder: (context, index) => Column(
          children: [
            SolenoidItem(
              title: "Solenoid ${index + 1}",
              status: index % 2 == 0 ? true : false,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
