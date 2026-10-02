import 'package:flutter/material.dart';
class ChatBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 15;
    const double tailSize = 10;

    Path path = Path();
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius - tailSize);
    path.quadraticBezierTo(size.width, size.height - tailSize, size.width - radius, size.height - tailSize);

    // Create the "tail" on bottom right
    path.lineTo(size.width - 20, size.height - tailSize);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width - 30, size.height - tailSize);

    path.lineTo(radius, size.height - tailSize);
    path.quadraticBezierTo(0, size.height - tailSize, 0, size.height - radius - tailSize);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
