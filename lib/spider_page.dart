import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouse_event/mouse_event.dart';
import 'package:pie_spider_pet/entity/location.dart';
import 'package:pie_spider_pet/entity/spider.dart';
import 'package:pie_spider_pet/entity/window.dart';
import 'package:pie_spider_pet/utils/image_path.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

class SpiderPage extends ConsumerStatefulWidget {
  const SpiderPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SpiderPageState();
}

class SpiderPageState extends ConsumerState<SpiderPage> {
  Spider spider = Spider();

  // Used instead of Riverpod for better performance
  Location spiderLoc = Location();

  final _rotationProvider = StateProvider<double>((ref) => 0.0);
  final _angleProvider = StateProvider<double>((ref) => 0.0);

  void _setSpiderLocation(Location location) {
    setState(() {
      spiderLoc = location;
    });
  }

  @override
  void initState() {
    super.initState();

    spider.setLocation = (Location location) =>
        _setSpiderLocation(location);
    screenRetriever.getPrimaryDisplay().then((display) async {
      Size size = display.size;
      spider.window.width = size.width;
      spider.window.height = size.height;
      print('size: ${size.width} ${size.height}');

      spider.location.x = spider.window.width / 2;
      spider.location.y = spider.window.height / 2;

      await windowManager.setPosition(
        Offset(spider.location.x, spider.location.y),
      );
      while (true) {
        if (spider.isMoving) {
          await Future.delayed(const Duration(milliseconds: 100));
          continue;
        }
        double range = Random().nextDouble() * 100.0 + 50.0;
        // Long Move
        if (Random().nextInt(3) == 0)
          range += Random().nextDouble() * 150.0;
        print('range: ${range}');
        Location next = await spider.moveRadius(range: range);

        double preAngle = ref.read(_angleProvider);
        double nextAngle = spider.location.getAngle(next);
        double dR = (nextAngle - preAngle) / 100;

        if (spider.location.x < next.x)
          ref.read(_rotationProvider.notifier)
              .update((state) => pi);
        else
          ref.read(_rotationProvider.notifier)
              .update((state) => 0);
        for (double i = 0, angle = preAngle; i < 100; i++, angle += dR) {
          spider.angle = angle / 5;
          ref.read(_angleProvider.notifier)
              .update((state) => angle / 5);
          await Future.delayed(const Duration(milliseconds: 10));
        }
        // Break Time
        int waitMillis = Random().nextInt(100);
        await Future.delayed(Duration(milliseconds: waitMillis));
      }
    });
    MouseEventPlugin.startListening((mouseEvent) {
      String event = mouseEvent.toString();
      if (!event.contains('WM_LBUTTONDOWN'))
        return;
      List<String> coordinates = event.split('WM_LBUTTONDOWN')[1]
          .replaceAll('(', '').replaceAll(')', '')
          .split('x');
      Location cursorLoc = Location.fromCursor(
        spider.window,
        Location(
          x: double.parse(coordinates[0]),
          y: double.parse(coordinates[1]),
        ),
      );
      if (spider.isInSpider(cursorLoc))
        spider.moveToCursor();
      print('spiderLoc: ${spider.location.x} ${spiderLoc.y}, ${spider.window.width}, ${spider.window.height}');
      print('mouseEvent: ${coordinates} -> ${cursorLoc.x}, ${cursorLoc.y}');
      print('isInSpider: ${spider.isInSpider(cursorLoc)}');
      print('${MediaQuery.sizeOf(context).width} !! ${MediaQuery.sizeOf(context).height}');
    });
  }

  @override
  void dispose() {
    super.dispose();

    MouseEventPlugin.cancelListening();
  }

  @override
  Widget build(BuildContext context) {
    Window size = spider.size;
    return Stack(
      children: [
        Positioned(
          left: spiderLoc.x,
          child: Container(
            width: 2,
            height: spiderLoc.y,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: spiderLoc.y - size.height/2,
          left: spiderLoc.x - size.width/2,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                ref.watch(_rotationProvider),
              ),
              child: Transform.rotate(
                angle: ref.watch(_angleProvider),
                child:Image.asset(
                  ImagePath.spider,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}