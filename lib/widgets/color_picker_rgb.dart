import 'package:flutter/material.dart';

class ColorPickerRGB extends StatefulWidget {
  final Function(Color) onColorChanged;
  final Color initialColor;
  const ColorPickerRGB({super.key, required this.onColorChanged, required this.initialColor});

  @override
  State<ColorPickerRGB> createState() => _ColorPickerRGBState();
}

class _ColorPickerRGBState extends State<ColorPickerRGB> {
  late int _r, _g, _b;
  final TextEditingController _hexCtrl = TextEditingController();

  final List<Color> _presets = [
    Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange,
    Colors.purple, Colors.pink, Colors.cyan, Colors.teal, Colors.amber, Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _r = widget.initialColor.red;
    _g = widget.initialColor.green;
    _b = widget.initialColor.blue;
    _updateHex();
  }

  void _updateHex() {
    _hexCtrl.text = '#${_r.toRadixString(16).padStart(2,'0')}${_g.toRadixString(16).padStart(2,'0')}${_b.toRadixString(16).padStart(2,'0')}';
  }

  void _notify() => widget.onColorChanged(Color.fromRGBO(_r, _g, _b, 1));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60, height: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(_r, _g, _b, 1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _hexCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'HEX', labelStyle: TextStyle(color: Colors.white70), isDense: true),
                onSubmitted: (hex) {
                  try {
                    var h = hex.replaceFirst('#', '');
                    if (h.length == 3) h = '${h[0]}${h[0]}${h[1]}${h[1]}${h[2]}${h[2]}';
                    setState(() {
                      _r = int.parse(h.substring(0, 2), radix: 16);
                      _g = int.parse(h.substring(2, 4), radix: 16);
                      _b = int.parse(h.substring(4, 6), radix: 16);
                    });
                    _notify();
                  } catch (_) {}
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _slider('R', _r, Colors.red, (v) { _r = v; _updateHex(); _notify(); }),
        _slider('G', _g, Colors.green, (v) { _g = v; _updateHex(); _notify(); }),
        _slider('B', _b, Colors.blue, (v) { _b = v; _updateHex(); _notify(); }),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: _presets.map((c) => GestureDetector(
            onTap: () {
              setState(() { _r = c.red; _g = c.green; _b = c.blue; _updateHex(); });
              _notify();
            },
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _slider(String label, int value, Color color, Function(int) onChanged) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label, style: TextStyle(color: color))),
        Expanded(child: Slider(value: value.toDouble(), min: 0, max: 255, onChanged: (v) => onChanged(v.round()))),
        SizedBox(width: 32, child: Text(value.toString(), style: const TextStyle(color: Colors.white70))),
      ],
    );
  }
}
