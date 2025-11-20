import 'package:flutter/material.dart';

class AppShadows {
  static const List<Shadow> blackFade = [
    // Shadow pertama, paling gelap dan dekat dengan teks
    Shadow(offset: Offset(0, 0), blurRadius: 2, color: Colors.black87),
    // Shadow kedua, sedikit lebih blur
    Shadow(offset: Offset(0, 0), blurRadius: 4, color: Colors.black54),
    // Shadow ketiga, makin blur untuk efek dissolve
    Shadow(offset: Offset(0, 0), blurRadius: 8, color: Colors.black38),
    // Shadow terakhir, paling halus
    Shadow(offset: Offset(0, 0), blurRadius: 12, color: Colors.black26),
    Shadow(offset: Offset(0, 0), blurRadius: 18, color: Colors.black12),
    Shadow(offset: Offset(0, 0), blurRadius: 26, color: Colors.black),
  ];
}
