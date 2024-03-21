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

  @override
  void initState() {
    screenRetriever.getPrimaryDisplay().then((display) {
      Size size = display.size;
      spider.window.width = size.width;
      spider.window.height = size.height;
      print('size: ${size.width} ${size.height}');

      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        Display display = await screenRetriever.getPrimaryDisplay();
        print('${display.size.width}');

        double range = Random().nextDouble() * 500.0 + 50.0;
        spider.moveRadius(
          range: range,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagePath.spider,
    );
  }
}