import 'package:flutter/material.dart';
import 'package:pie_spider_pet/spider_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(100, 100),
    center: true,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    backgroundColor: Colors.transparent,
    windowButtonVisibility: false,
    alwaysOnTop: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setResizable(false);
    await windowManager.setHasShadow(false);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpiderPage();
  }
}
