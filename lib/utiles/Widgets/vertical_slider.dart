import 'package:flutter/material.dart';

class VerticalSlider extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  const VerticalSlider({super.key, 
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Update the slider value based on drag position
        double newValue = value - details.primaryDelta! / context.size!.height * (max - min);
        newValue = newValue.clamp(min, max);
        onChanged(newValue);
      },
      child: CustomPaint(
        size: const Size(50, 300), // Adjust the size as needed
        painter: VerticalSliderPainter(min: min, max: max, value: value),
        child: Container(),
      ),
    );
  }
}

class VerticalSliderPainter extends CustomPainter {
  final double min;
  final double max;
  final double value;

  VerticalSliderPainter({
    required this.min,
    required this.max,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final double height = size.height;
    final double trackHeight = height * (value - min) / (max - min);

    // Draw track
    canvas.drawRect(Rect.fromLTWH(0, height - trackHeight, size.width, trackHeight), paint);

    // Draw tick marks
    final Paint tickPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    const int tickCount = 11;
    final double tickSpacing = height / (tickCount - 1);

    for (int i = 0; i < tickCount; i++) {
      final double tickPosition = i * tickSpacing;
      canvas.drawLine(
        Offset(0, height - tickPosition),
        Offset(size.width, height - tickPosition),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class VerticalSliderDemo extends StatefulWidget {
  const VerticalSliderDemo({super.key});

  @override
  _VerticalSliderDemoState createState() => _VerticalSliderDemoState();
}

class _VerticalSliderDemoState extends State<VerticalSliderDemo> {
  double _currentValue = 34.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Vertical Slider'),
      ),
      body: Center(
        child: VerticalSlider(
          min: -20.0,
          max: 80.0,
          value: _currentValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
      ),
    );
  }
}

