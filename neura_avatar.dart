import 'package:flutter/material.dart';
import 'dart:math';

class NeuraAvatar extends StatefulWidget {
  final Color glowColor;
  final bool isIdle;

  NeuraAvatar({this.glowColor = Colors.cyan, this.isIdle = true});

  @override
  _NeuraAvatarState createState() => _NeuraAvatarState();
}

class _NeuraAvatarState extends State<NeuraAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIdleAnimation() {
    return Transform.scale(
      scale: _pulse.value,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.glowColor.withOpacity(0.7),
              widget.glowColor.withOpacity(0.2),
            ],
            radius: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Center(
          child: Icon(Icons.face_retouching_natural,
              color: Colors.white, size: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) => _buildIdleAnimation(),
    );
  }
}