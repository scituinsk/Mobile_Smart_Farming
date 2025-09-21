import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

class SelenoidItem extends StatelessWidget {
  final String title;
  final bool status;
  const SelenoidItem({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIcon(type: MyCustomIcon.selenoid),
      title: Text(title),
      trailing: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: status
                  ? Colors.green.withValues(alpha: 0.4)
                  : Colors.red.withValues(alpha: 0.4),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.circle,
          color: status ? Colors.green : Colors.red,
          size: 16,
        ),
      ),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
