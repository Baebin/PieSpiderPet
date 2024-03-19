import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_spider_pet/utils/image_path.dart';
import 'package:window_manager/window_manager.dart';

class SpiderPage extends ConsumerStatefulWidget {
  const SpiderPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SpiderPageState();
}

class SpiderPageState extends ConsumerState<SpiderPage> {
  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      double x = Random().nextInt(1280).toDouble();
      double y = Random().nextInt(720).toDouble();
      windowManager.setPosition(
          Offset(x, y)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagePath.spider,
    );
  }
}