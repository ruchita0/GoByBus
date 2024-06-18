import 'package:flutter/material.dart';

class Routedisplay extends StatelessWidget {
  const Routedisplay({super.key, required this.n});
  final int n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Routes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: CustomPaint(
            size: const Size(800, 900),
            painter: LineWithLabeledPointsPainter(n),
          ),
        ),
      ),
    );
  }
}

class LineWithLabeledPointsPainter extends CustomPainter {
  final int l;
  LineWithLabeledPointsPainter(this.l);
  List<List<String>> list = [
    [
      'MIDC Chowk \n   - 9.00 AM',
      'Kumthekar Hospital \n   - 9.05 AM',
      'Nadgeri Petrol Pump \n   - 9.10 AM',
      'Saiful \n   - 9.15 AM',
      'Attar Nagar \n   - 9.20 AM',
      'Jigjeni Petrol Pump \n   - 9.20 AM',
      'Mantri chandak(Vijapur Road) \n   - 9.25 AM',
      'Orchid College \n   - 9.45 AM'
    ],
    [
      'Nehru Nagar \n   - 9.05 AM',
      'ITI \n   - 9.10 AM',
      'Rasul Hotel \n   - 9.15 AM',
      'Patrakar Bhavan \n   - 9.25 AM',
      'Doodh Dairy \n   - 9.30 AM',
      'Orchid College \n   - 9.45 AM'
    ],
    [
      'DMart(Jule Solapur) \n   - 9.00 AM',
      'Govindshree \n   - 9.05 AM',
      'Bharati Vidyapeeth \n   - 9.10 AM',
      'Khambar Talav \n   - 9.20 AM',
      'Orchid College \n   - 9.45 AM'
    ],
    [
      'Saat Rasta \n   - 9.10 AM',
      'Modi \n   - 9.15 AM',
      'DRM office \n   - 9.15 AM',
      'Railway Station \n   - 9.30 AM',
      'Samrat Chowk  \n   - 9.35 AM',
      'Mantri Chandak\n(Rupa Bhavani) \n   - 9.40 AM',
      'Orchid College \n   - 9.45 AM'
    ],
  ];

  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final points = [
      const Offset(180, 60),
      const Offset(180, 160),
      const Offset(180, 260),
      const Offset(180, 360),
      const Offset(180, 460),
      const Offset(180, 560),
      const Offset(180, 660),
      const Offset(180, 760),
      const Offset(180, 860),
    ];

    // Draw the line
    canvas.drawLine(points[0], points[list[l - 1].length - 1], paint);

    // Draw the points with labels
    for (int i = 0; i < list[l - 1].length; i++) {
      final pointPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      final textPainter = TextPainter(
        text: TextSpan(
          text: list[l - 1][i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Determine the label offset
      final double labelOffsetX = (i % 2 == 0) ? 20 : -textPainter.width - 10;

      // Draw the point label
      final labelOffset = Offset(
        points[i].dx + labelOffsetX,
        points[i].dy,
      );

      canvas.drawCircle(points[i], 10, pointPaint);

      textPainter.paint(canvas, labelOffset);

      {
        for (int i = 0; i < list[l - 1].length; i++) {
          final pointPaint = Paint()
            ..color = Colors.black
            ..style = PaintingStyle.fill;

          final textPainter = TextPainter(
            text: TextSpan(
              text: '${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();

          final textOffset = Offset(
            points[i].dx - (textPainter.width / 2),
            points[i].dy - (textPainter.height / 2),
          );

          // Draw the point
          canvas.drawCircle(points[i], 10, pointPaint);

          // Draw the point label
          textPainter.paint(canvas, textOffset);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
