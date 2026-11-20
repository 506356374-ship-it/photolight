import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'screens/light_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WakelockPlus.enable();
  runApp(const PhotoLightApp());
}

class PhotoLightApp extends StatelessWidget {
  const PhotoLightApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoLight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const LightScreen(),
    );
  }
}
