import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const TruthOrDareApp());
}

class TruthOrDareApp extends StatelessWidget {
  const TruthOrDareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TruthOrDareScreen(),
    );
  }
}

class TruthOrDareScreen extends StatefulWidget {
  const TruthOrDareScreen({super.key});

  @override
  State<TruthOrDareScreen> createState() => _TruthOrDareScreenState();
}

class _TruthOrDareScreenState extends State<TruthOrDareScreen> with TickerProviderStateMixin {
  final randomizer = Random();
  String truthOrDare = "";
  List<String> truthList = [
    "What's your biggest fear?",
    "Who is your celebrity crush?",
  ];
  List<String> dareList = [
    "Sing a song in front of everyone.",
    "Do your best animal impression.",
  ];
  AnimationController? _animationController;
  double _bottleRotation = 0.0; // Track bottle rotation angle

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Spin for 15 seconds
    )..addListener(() {
      setState(() {
        // Adjust rotation speed using a custom curve
        _bottleRotation = _animationController!.value * 360.0 * (1.0 + _animationController!.value); // Exponential curve
      });
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void spinBottle() {
    setState(() {
      truthOrDare = randomizer.nextBool() ? "Truth" : "Dare";
      _animationController!.forward(from: 0.0); // Start animation
    });
  }

  void stopAnimation() {
    _animationController?.stop(canceled: false); // Stop at a random position
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truth or Dare'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_bottleRotation * pi / 180),
              child: Image.asset(
                'assets/images/bottle.png', // Replace with your bottle image
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              truthOrDare.isEmpty ? 'Spin the bottle!' : truthOrDare,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                spinBottle();
                // Stop animation after a random delay between 12-15 seconds
                Future.delayed(Duration(seconds: randomizer.nextInt(3) + 12), stopAnimation);
              },
              child: const Text('Spin Bottle'),
            ),
          ],
        ),
      ),
    );
  }
}
