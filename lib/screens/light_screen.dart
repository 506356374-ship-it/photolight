import 'package:flutter/material.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});
  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  int r = 255, g = 255, b = 255;
  double bright = 1.0;
  bool showPanel = true;

  Color get fill => Color.fromRGBO(r, g, b, bright);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(() => showPanel = !showPanel),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: fill,
              width: double.infinity,
              height: double.infinity,
            ),
            if (showPanel)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _slider('R', r.toDouble(), Colors.red, (v) => setState(() => r = v.round())),
                      _slider('G', g.toDouble(), Colors.green, (v) => setState(() => g = v.round())),
                      _slider('B', b.toDouble(), Colors.blue, (v) => setState(() => b = v.round())),
                      _slider('亮度', bright, Colors.white, (v) => setState(() => bright = v)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _dot(Colors.white),
                          _dot(const Color(0xFFFFD8A8)),
                          _dot(const Color(0xFFFF8B3A)),
                          _dot(const Color(0xFF9BC4FF)),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double val, Color c, Function(double) on) {
    return Row(children: [
      SizedBox(width: 36, child: Text(label, style: TextStyle(color: c))),
      Expanded(child: Slider(value: val, min: 0, max: label == '亮度' ? 1 : 255, onChanged: on)),
      SizedBox(width: 40, child: Text(val.round().toString(), style: const TextStyle(color: Colors.white70))),
    ]);
  }

  Widget _dot(Color c) => GestureDetector(
        onTap: () => setState(() { r = c.red; g = c.green; b = c.blue; }),
        child: Container(width: 28, height: 28, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white24))),
      );
}
