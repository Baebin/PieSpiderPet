import 'dart:math';

import 'package:pie_spider_pet/entity/window.dart';

class Location {
  double x;
  double y;

  Location({
    this.x = 0,
    this.y = 0,
  });

  double getAngle(Location location) {
    double rx = (location.x - x);
    double ry = (location.y - y);
    double radian = atan(ry/rx);
    // Exception Handle
    return (radian != radian ? 0 : radian);
  }

  static Location fromCursor(Window window, Location cursor) {
    return Location(
        x: window.width * (cursor.x / 1920),
        y: window.height * (cursor.y / 1080),
    );
  }

  static Location toCursor(Window window, Location loc) {
    return Location(
        x: 1920 * (loc.x / window.width),
        y: 1080 * (loc.y / window.height),
    );
  }
}