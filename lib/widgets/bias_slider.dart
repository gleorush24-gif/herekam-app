import 'package:flutter/material.dart';

class BiasSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const BiasSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String get _biasLabel {
    if (value <= -0.6) return 'Far Left';
    if (value <= -0.2) return 'Moderate Left';
    if (value <= 0.2) return 'Center';
    if (value <= 0.6) return 'Moderate Right';
    return 'Far Right';
  }

  Color get _biasColor {
    if (value <= -0.6) return const Color(0xFF1565C0);
    if (value <= -0.2) return const Color(0xFF42A5F5);
    if (value <= 0.2) return const Color(0xFF66BB6A);
    if (value <= 0.6) return const Color(0xFFEF5350);
    return const Color(0xFFB71C1C);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Left',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _biasColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _biasColor),
                ),
                child: Text(
                  _biasLabel,
                  style: TextStyle(
                    color: _biasColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Text(
                'Right',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _biasColor,
              inactiveTrackColor: const Color(0xFF161B22),
              thumbColor: _biasColor,
              overlayColor: _biasColor.withOpacity(0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: -1.0,
              max: 1.0,
              divisions: 20,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}