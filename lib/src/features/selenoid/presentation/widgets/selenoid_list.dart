import 'package:flutter/material.dart';
import 'package:pak_tani/src/features/selenoid/presentation/widgets/selenoid_item.dart';

class SelenoidList extends StatelessWidget {
  const SelenoidList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        itemCount: 6,
        itemBuilder: (context, index) => Column(
          children: [
            SelenoidItem(
              title: "Selenoid ${index + 1}",
              status: index % 2 == 0 ? true : false,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
