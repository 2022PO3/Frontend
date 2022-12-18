// Flutter imports:
import 'package:flutter/rendering.dart';

class Constants {
  const Constants._();

  static const double borderRadius = 15.0;
  static ShapeBorder cardBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      Constants.borderRadius,
    ),
  );
}
