import 'package:flutter/material.dart';

//Genel sayfa paddingleri
class ScreenPadding {
  static const EdgeInsets extraSmallPadding = const EdgeInsets.all(5);
  static const EdgeInsets smallPadding = const EdgeInsets.all(10);
  static const EdgeInsets mediumPadding = const EdgeInsets.all(15);
  static const EdgeInsets largePadding = const EdgeInsets.all(20);

  //Top-Bottom sayfa paddingleri
  static const EdgeInsets extraSmallPaddingTopBottom = const EdgeInsets.only(
    top: 5,
    bottom: 5,
  );
  static const EdgeInsets smallPaddingTopBottom = const EdgeInsets.only(
    top: 10,
    bottom: 10,
  );
  static const EdgeInsets mediumPaddingTopBottom = const EdgeInsets.only(
    top: 15,
    bottom: 15,
  );
  static const EdgeInsets largePaddingTopBottom = const EdgeInsets.only(
    top: 20,
    bottom: 20,
  );
}
