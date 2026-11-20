import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class PhotoLightApp extends StatelessWidget {
  const PhotoLightApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoLight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amberAccent,
          surface: const Color(0xFF1A1A2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
