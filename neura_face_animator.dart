import 'package:flutter/material.dart';

class NeuraFaceAnimator extends StatefulWidget {
  final bool reacting; // true if a joke is being told
  final bool happy;    // true for liked/favorite reaction

  NeuraFaceAnimator({required this.reacting, required this.happy});

  @override
  _NeuraFaceAnimatorState createState() => _NeuraFaceAnimatorState();
}

class _NeuraFaceAnimatorState extends State<NeuraFaceAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _glow = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.reacting) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NeuraFaceAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reacting && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.reacting && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getEmotionColor() {
    return widget.happy ? Colors.pinkAccent : Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Transform.scale(
          scale: _glow.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  getEmotionColor().withOpacity(0.8),
                  getEmotionColor().withOpacity(0.2)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: getEmotionColor().withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                )
              ],
            ),
            child: Icon(
              widget.happy ? Icons.emoji_emotions : Icons.emoji_neutral,
              color: Colors.white,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}