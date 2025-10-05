import 'package:flutter/material.dart';

class MySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double scale;
  const MySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: SwitchTheme(
        data: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return null; // Gunakan default border saat aktif
            }
            return Colors.transparent; // Hilangkan border saat false
          }),
          trackColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return null; // Gunakan default color saat aktif
            }
            return Colors.grey.shade300; // Background color saat false
          }),
          thumbColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return null; // Gunakan default thumb color saat aktif
            }
            return Colors.white; // Warna lingkaran lebih terang saat false
          }),
        ),
        child: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}
