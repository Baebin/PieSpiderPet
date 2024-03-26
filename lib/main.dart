import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_spider_pet/spider_page.dart';
import 'package:pie_spider_pet/utils/image_path.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    backgroundColor: Colors.transparent,
    windowButtonVisibility: false,
    alwaysOnTop: true,
    fullScreen: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setIgnoreMouseEvents(true);
    await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setIcon(ImagePath.spiderIcon);
    await windowManager.setResizable(false);
    await windowManager.setHasShadow(false);
  });

  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const SpiderPage(),
    );
  }
}
