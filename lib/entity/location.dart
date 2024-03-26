import 'dart:math';

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
}