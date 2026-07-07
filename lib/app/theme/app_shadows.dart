import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> none = <BoxShadow>[];

  static const List<BoxShadow> sm = <BoxShadow>[
    BoxShadow(
      blurRadius: 8,
      color: Color(0x14101114),
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> md = <BoxShadow>[
    BoxShadow(
      blurRadius: 18,
      color: Color(0x1A101114),
      offset: Offset(0, 8),
    ),
  ];
}
