import 'dart:math';
import 'dart:ui';

import 'package:pie_spider_pet/entity/location.dart';
import 'package:pie_spider_pet/entity/window.dart';
import 'package:window_manager/window_manager.dart';

class Spider {
  Location location = Location();
  Window window = Window();

  double walkSpeed = 12.0;
  double runSpeed = 30.0;

  int _count = 0;
  bool _isMoving = false;

  bool get isMoving => _isMoving;

  Function(Location location) setLocation = (location) {};

  Spider({
    Location? location,
    Window? window,
    double? walkSpeed,
    double? runSpeed,
  }) {
    this.location = location ?? this.location;
    this.window = window ?? this.window;
    this.walkSpeed = walkSpeed ?? this.walkSpeed;
    this.runSpeed = runSpeed ?? this.runSpeed;
  }

  Future<Location> moveRadius({
    required double range,
  }) async {
    // x^2 + y^2 = range^2
    // y^2 = (range^2 - x^2);
    double dx = Random().nextDouble() * range;
    double dy = sqrt((range * range) - (dx * dx));

    print('dx: ${dx}, ${dy}');
    dx *= (Random().nextBool() ? 1 : -1);
    dy *= (Random().nextBool() ? 1 : -1);

    double x = min(max(location.x + dx, 0.0), window.width);
    double y = min(max(location.y + dy, 0.0), window.height);

    Location next = Location(x: x, y: y);
    move(
        next: next,
        speed: walkSpeed
    );
    return next;
  }

  Future<void> move({
    required Location next,
    // 1.0 ~ 100.0
    required double speed,
  }) async {
    if (_isMoving)
      return;
    speed = min(max(speed, 1.0), 100.0);

    double dx = (speed / 10) * (location.x < next.x ? 1 : -1);
    double dy = (speed / 10) * (location.y < next.y ? 1 : -1);

    _isMoving = true;
    int count = (++_count);
    while (_isMoving && count == _count) {
      if ((location.x - next.x).abs() <= dx.abs()) {
        location.x = next.x;
        dx = 0.0;
      } else location.x += dx;
      if ((location.y - next.y).abs() <= dy.abs()) {
        location.y = next.y;
        dy = 0.0;
      } else location.y += dy;

      setLocation(location);

      print('${dx}, ${dy}, ${(location.y - next.y).abs()}');
      if (dx == 0.0 && dy == 0.0) {
        _isMoving = false;
        break;
      }
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }
}