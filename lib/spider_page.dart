import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_spider_pet/entity/location.dart';
import 'package:pie_spider_pet/entity/spider.dart';
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

  final _rotationProvider = StateProvider<double>((ref) => 0.0);
  final _angleProvider = StateProvider<double>((ref) => 0.0);

  @override
  void initState() {
    screenRetriever.getPrimaryDisplay().then((display) async {
      Size size = display.size;
      spider.window.width = size.width;
      spider.window.height = size.height;
      print('size: ${size.width} ${size.height}');

      spider.location.x = spider.window.width/2;
      spider.location.y = spider.window.height/2;

      await windowManager.setPosition(
        Offset(spider.location.x, spider.location.y),
      );
      while (true) {
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
        else ref.read(_rotationProvider.notifier)
            .update((state) => 0);
        for (double i = 0, angle = preAngle; i < 100; i++, angle += dR) {
          ref.read(_angleProvider.notifier)
              .update((state) => angle/2);
          await Future.delayed(const Duration(milliseconds: 10));
        }
        // Break Time
        int waitMillis = Random().nextInt(500);
        await Future.delayed(Duration(milliseconds: waitMillis));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(
        ref.watch(_rotationProvider),
      ),
      child: Transform.rotate(
        angle: ref.watch(_angleProvider),
        child: Image.asset(
          ImagePath.spider,
        ),
      ),
    );
  }
}