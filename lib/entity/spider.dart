import 'dart:math';

import 'package:flutter_auto_gui/flutter_auto_gui.dart';
import 'package:pie_spider_pet/entity/location.dart';
import 'package:pie_spider_pet/entity/window.dart';

class Spider {
  Location location = Location();

  Window size = Window(
      width: 180 * 0.8,
      height: 90 * 0.8,
  );
  Window window = Window();

  double angle = 0.0;
  double walkSpeed = 12.0;
  double runSpeed = 30.0;

  int _count = 0;
  bool _isMoving = false;
  bool _isTargeting = false;

  bool get isMoving => _isMoving;
  bool get isTargeting => _isTargeting;

  Function(Location location) setLocation = (location) {};
  Function(double angle) setAngle = (angle) {};
  Function(double angle) setRotation = (rotation) {};

  Function(double weight) setLeftEyeXWeight = (weight) {};
  Function(double weight) setLeftEyeYWeight = (weight) {};
  Function(double weight) setRightEyeXWeight = (weight) {};
  Function(double weight) setRightEyeYWeight = (weight) {};

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

  bool isInSpider(Location location) {
    double x = this.location.x;
    double y = this.location.y;
    double dx = location.x;
    double dy = location.y;
    double width = this.size.width;
    double height = this.size.height;
    return (
        (x - width/2 <= dx && dx <= x + width/2)
            && (y - height/2 <= dy && dy <= y + height/2)
    );
  }

  Future<void> moveRadius({
    required double range,
  }) async {
    // x^2 + y^2 = range^2
    // y^2 = (range^2 - x^2);
    double dx = Random().nextDouble() * range;
    double dy = sqrt((range * range) - (dx * dx));

    print('dx: ${dx}, ${dy}');
    int rX = (location.x < window.width/2 ? 1 : -1);
    int rY = (location.y < window.height/2 ? 1 : -1);
    dx *= (Random().nextInt(10) < 6 ? rX : -rX);
    dy *= (Random().nextInt(10) < 6 ? rY : -rY);

    double x = min(max(location.x + dx, 0.0), window.width);
    double y = min(max(location.y + dy, 0.0), window.height);

    Location next = Location(x: x, y: y);
    move(
        next: next,
        speed: walkSpeed
    );
  }

  Future<void> _setAngle(double preAngle, double nextAngle, int count) async {
    double dR = (nextAngle - preAngle) / 100;
    for (double i = 0, angle = preAngle; i < 100 && count == _count; i++, angle += dR) {
      setAngle(this.angle = (angle / 5));
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> move({
    required Location next,
    // 1.0 ~ 100.0
    required double speed,
  }) async {
    speed = min(max(speed, 1.0), 100.0);

    double dx = (speed / 10) * (location.x < next.x ? 1 : -1);
    double dy = (speed / 10) * (location.y < next.y ? 1 : -1);

    // State
    _isMoving = true;
    int count = (++_count);

    // Rotation
    setRotation(location.x < next.x ? 0 : pi);

    // Angle
    double preAngle = this.angle;
    double nextAngle = location.getAngle(next);
    _setAngle(preAngle, nextAngle, count);

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
      // print('${dx}, ${dy}, ${(location.y - next.y).abs()}');
      if (dx == 0.0 && dy == 0.0) {
        _isMoving = false;
        break;
      }
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  Future<bool> _targeting() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < 1000; i++) {
      Point<int>? position = await FlutterAutoGUI.position();
      if (position == null)
        continue;
      Location cursor = Location.fromCursor(
        window,
        Location(x: position.x.toDouble(), y: position.y.toDouble()),
      );
      double dx = (runSpeed / 10) * (location.x < cursor.x ? 1 : -1);
      double dy = (runSpeed / 10) * (location.y < cursor.y ? 1 : -1);

      // Angle
      double angle = location.getAngle(cursor);
      print('angle: ${angle}');
      setAngle(this.angle = angle);

      // Rotation
      setRotation(dx > 0 ? 0 : pi);

      if ((location.x - cursor.x).abs() <= dx.abs()) {
        location.x = cursor.x;
        dx = 0.0;
      } else location.x += dx;
      if ((location.y - cursor.y).abs() <= dy.abs()) {
        location.y = cursor.y;
      } else location.y += dy;

      setLocation(location);

      if (isInSpider(cursor))
        return Future.value(true);
      await Future.delayed(const Duration(milliseconds: 20));
    }
    return Future.value(false);
  }

  Future<void> moveToCursor() async {
    Point<int>? position = await FlutterAutoGUI.position();
    if (position == null)
      return;
    if (_isTargeting)
      return;
    _isTargeting = true;
    if (!await _targeting()) {
      _isTargeting = false;
      return;
    }
    Location cursorLoc = Location.fromCursor(
      window,
      Location(
        x: position.x.toDouble(),
        y: position.y.toDouble(),
      ),
    );
    print('curLoc: ${location.x}, ${location.y}');
    print('cursorLoc: ${cursorLoc.x}, ${cursorLoc.y}');

    double tmpSpeed = this.walkSpeed;
    this.walkSpeed = this.runSpeed;

    moveRadius(range: 300);

    // Eye Motion Init
    setRightEyeXWeight(0.0);

    int i = 0;
    int times = Random().nextInt(500) + 500;
    while (i++ != 750) {
      Location cursor = Location.toCursor(window, location);
      await FlutterAutoGUI.moveTo(
        point: Point(cursor.x.toInt(), cursor.y.toInt()),
      );
      if (i % 50 == 0)
        moveRadius(range: 300);
      await Future.delayed(
        const Duration(milliseconds: 10),
      );
    }
    this.walkSpeed = tmpSpeed;
    this._isTargeting = false;
  }
}