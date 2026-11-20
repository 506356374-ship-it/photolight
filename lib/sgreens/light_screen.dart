import 'package:flutter/material.dart';
import '../widgets/color_picker_rgb.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});
  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> with SingleTickerProviderStateMixin {
  Color _currentColor = Colors.white;
  int _mode = 0; // 0纯色 1频闪 2烛光 3自定义
  double _brightness = 1.0;
  double _strobeFreq = 10.0;
  double _candleSpeed = 1.0;
  int _colorTemp = 5000;
  bool _showControls = true;
  late AnimationController _animController;
  late Animation<Color?> _colorAnim;
  Color _oldColor = Colors.white;
  bool _strobeOn = true;

  final List<int> _temps = [2700, 3200, 4000, 5000, 6500, 9000];
  final List<String> _modeNames = ['纯色', '频闪', '烛光', '自定义'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _colorAnim = AlwaysStoppedAnimation(_currentColor);
  }

  void _updateColor(Color c) {
    _oldColor = _currentColor;
    _animController.reset();
    _colorAnim = ColorTween(begin: _oldColor, end: c).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );
    _animController.forward();
    setState(() => _currentColor = c);
  }

  Color _tempToColor(int t) {
    if (t <= 2700) return const Color(0xFFFF8B3A);
    if (t <= 3200) return const Color(0xFFFFA95C);
    if (t <= 4000) return const Color(0xFFFFD1A8);
    if (t <= 5000) return const Color(0xFFFFFFFF);
    if (t <= 6500) return const Color(0xFFD4E3FF);
    return const Color(0xFF9BC4FF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // 补光区域
            AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                Color display = _colorAnim.value ?? _currentColor;
                if (_mode == 1 && !_strobeOn) display = Colors.black;
                if (_mode == 2) {
                  // 烛光用透明度模拟
                  display = _currentColor.withOpacity(_brightness);
                }
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: display,
                );
              },
            ),
            // 控制面板
            if (_showControls)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter, end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 模式选择
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
                        // 色温
                        if (_mode != 3) ...[
                          const SizedBox(height: 8),
                          const Text('色温', style: TextStyle(color: Colors.white70)),
                          Slider(
                            value: _colorTemp.toDouble(),
                            min: 2700, max: 9000, divisions: 5,
                            label: '${_colorTemp}K',
                            onChanged: (v) {
                              setState(() { _colorTemp = v.round(); _updateColor(_tempToColor(v.round())); });
                            },
                          ),
                        ],
                        // 自定义颜色
                        if (_mode == 3) ...[
                          const SizedBox(height: 8),
                          ColorPickerRGB(
                            onColorChanged: _updateColor,
                            initialColor: _currentColor,
                          ),
                        ],
                        // 亮度
                        const SizedBox(height: 8),
                        const Text('亮度', style: TextStyle(color: Colors.white70)),
                        Slider(
                          value: _brightness, min: 0.1, max: 1,
                          onChanged: (v) => setState(() => _brightness = v),
                        ),
                        // 频闪
                        if (_mode == 1) ...[
                          const Text('频闪频率', style: TextStyle(color: Colors.white70)),
                          Slider(
                            value: _strobeFreq, min: 1, max: 30,
                            label: '${_strobeFreq.round()}Hz',
                            onChanged: (v) => setState(() => _strobeFreq = v),
                          ),
                        ],
                        // 烛光
                        if (_mode == 2) ...[
                          const Text('烛光速度', style: TextStyle(color: Colors.white70)),
                          Slider(
                            value: _candleSpeed, min: 0.5, max: 3,
                            label: _candleSpeed.toStringAsFixed(1),
                            onChanged: (v) => setState(() => _candleSpeed = v),
                          ),
                        ],
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
