import 'package:flutter/material.dart';

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color shapeColor;
  final Color iconColor;

  const ClickableIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.shapeColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: shapeColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
