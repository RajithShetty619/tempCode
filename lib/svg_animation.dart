import 'dart:async';

import 'package:flutter/material.dart';

class SVGanimation extends StatefulWidget {
  const SVGanimation({Key? key}) : super(key: key);

  @override
  State<SVGanimation> createState() => _SVGanimationState();
}

class _SVGanimationState extends State<SVGanimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: SvgSwitcher(
            svgAssets: [
              'assets/1.png',
              'assets/2.png',
              'assets/3.png',
            ],
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );
  }
}

class SvgSwitcher extends StatefulWidget {
  final List<String> svgAssets;
  final Duration duration;

  const SvgSwitcher({super.key, required this.svgAssets, required this.duration});

  @override
  _SvgSwitcherState createState() => _SvgSwitcherState();
}

class _SvgSwitcherState extends State<SvgSwitcher> {
  int _currentSvgIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentSvgIndex = (_currentSvgIndex + 1) % widget.svgAssets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.svgAssets[_currentSvgIndex],
      height: 20.0,
      width: 20.0,
    );
  }
}

class RotatingAnimation extends StatefulWidget {
  const RotatingAnimation({super.key});

  @override
  _RotatingAnimationState createState() => _RotatingAnimationState();
}

class _RotatingAnimationState extends State<RotatingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Center(
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: Image.asset('assets/1.png'),
        ),
      ),
    );
  }
}
