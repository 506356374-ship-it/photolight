import 'package:flutter/material.dart';
import 'screens/light_screen.dart';

void main() => runApp(const PhotoLightApp());

class PhotoLightApp extends StatelessWidget {
  const PhotoLightApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoLight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const LightScreen(),
    );
  }
}
