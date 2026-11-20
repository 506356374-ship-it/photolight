import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../widgets/color_picker_rgb.dart';
import '../utils/color_storage.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});
  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> with TickerProviderStateMixin {
  Color _currentColor = Colors.white;
  int _mode = 0;
  double _brightness = 1.0;
  double _strobeFreq = 10.0;
  double _candleSpeed = 1.0;
  int _colorTemp = 5000;
  bool _showControls = true;
  late AnimationController _colorAnimController;
  late Animation<Color?> _colorAnimation;
  Color _oldColor = Colors.white;

  final List<int> _colorTemps = [2700, 3200, 4000, 5000, 6500, 9000];
  final List<String> _modeNames = ['纯色', '渐变', '频闪', '烛光', '自定义'];

  @override
  void initState() {
    super.initState();
    _colorAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _colorAnimation = AlwaysStoppedAnimation(_currentColor);
    _setMaxBrightness();
  }

  Future<void> _setMaxBrightness() async {
    try { await ScreenBrightness().setScreenBrightness(1.0); } catch (_) {}
  }

  void _updateColor(Color newColor) {
    _oldColor = _currentColor;
    _colorAnimController.reset();
    _colorAnimation = ColorTween(begin: _oldColor, end: newColor).animate(
      CurvedAnimation(parent: _colorAnimController, curve: Curves.easeInOutCubic),
    );
    _colorAnimController.forward();
    setState(() => _currentColor = newColor);
  }

  Color _tempToColor(int temp) {
    if (temp <= 2700) return const Color(0xFFFF8B3A);
    if (temp <= 3200) return const Color(0xFFFFA95C);
    if (temp <= 4000) return const Color(0xFFFFD1A8);
    if (temp <= 5000) return const Color(0xFFFFFFFF);
    if (temp <= 6500) return const Color(0xFFD4E3FF);
    return const Color(0xFF9BC4FF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _colorAnimController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: _colorAnimation.value ?? _currentColor,
                );
              },
            ),
            if (_showControls)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.85), Colors.transparent]),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _modeNames.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(_modeNames[i]),
                                selected: _mode == i,
                                onSelected: (_) => setState(() => _mode = i),
                              ),
                            ),
                          ),
                        ),
                        if (_mode != 4) ...[
                          const SizedBox(height: 8),
                          const Text('色温', style: TextStyle(color: Colors.white70)),
                          Slider(
                            value: _colorTemp.toDouble(),
                            min: 2700, max: 9000, divisions: 5,
                            label: '${_colorTemp}K',
                            onChanged: (v) { setState(() { _colorTemp = v.round(); _updateColor(_tempToColor(v.round())); }); },
                          ),
                        ],
                        if (_mode == 4) ...[
                          const SizedBox(height: 8),
                          ColorPickerRGB(onColorChanged: _updateColor, initialColor: _currentColor),
                        ],
                        const SizedBox(height: 8),
                        const Text('亮度', style: TextStyle(color: Colors.white70)),
                        Slider(value: _brightness, min: 0.1, max: 1, onChanged: (v) => setState(() => _brightness = v)),
                        if (_mode == 2)
                          Slider(value: _strobeFreq, min: 1, max: 30, label: '频闪 ${_strobeFreq.round()}Hz', onChanged: (v) => setState(() => _strobeFreq = v)),
                        if (_mode == 3)
                          Slider(value: _candleSpeed, min: 0.5, max: 3, label: '速度 ${_candleSpeed.toStringAsFixed(1)}', onChanged: (v) => setState(() => _candleSpeed = v)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
