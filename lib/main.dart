import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const _squareSize = 50.0;
  late AnimationController controller;
  late Animation<double> animation;
  bool disabledLeft = false;
  bool disabledRight = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initController();
    addListener();
  }

  void initController() {
    controller = AnimationController(
        value: 0.3, vsync: this, duration: const Duration(seconds: 1));
    Tween<double> tween = Tween<double>(begin: -1, end: 1);
    CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = tween.animate(curve);
  }

  void addListener() {
    return controller.addListener(() {
    if (controller.status.index == 0 || controller.status.index == 3) {
      setState(() {
        if (animation.value == -1) {
          disabledLeft = true;
          disabledRight = false;
        }
        if (animation.value == 1) {
          disabledLeft = false;
          disabledRight = true;
        }
      });
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Align(
            alignment: Alignment(animation.value, 1),
            child: Container(
              width: _squareSize,
              height: _squareSize,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: disabledLeft ? null : moveLeft,
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: disabledRight ? null : moveRight,
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }

  void moveLeft() async {
    setState(() {
      disabledLeft = true;
      disabledRight = true;
    });
    controller.reverse();
  }

  void moveRight() async {
    setState(() {
      disabledLeft = true;
      disabledRight = true;
    });
    controller.forward();
  }
}
