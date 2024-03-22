import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        Display display = await screenRetriever.getPrimaryDisplay();
        double range = Random().nextDouble() * 500.0 + 50.0;
        spider.moveRadius(
          range: range,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        ImagePath.spider,
      ),
    );
  }
}