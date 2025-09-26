import 'package:flutter/material.dart';

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
  //    var path = Path();
    
  //   // Start from top-left
  //   path.lineTo(0, size.height - 60);
    
  //   // Create curved bottom
  //  path.quadraticBezierTo(
  //     size.width / 2,        // Control point X (middle)
  //     size.height + 20,      // Control point Y (below bottom để tạo curve)
  //     size.width,            // End point X (right edge)
  //     size.height - 40,      // End point Y (same as start)
  //   );
    
  //   // Complete the path properly
  //   path.lineTo(size.width, 0);
  //   path.lineTo(0, 0);
  //   path.close();
    
  //   return path; // ✅ Return path, not Path()

    final w = size.width;
    final h = size.height;
    final dip = h * 0.30;

    final p = Path()
      ..lineTo(0, h - dip)
      ..arcToPoint(
        Offset(w, h - dip),
        radius: Radius.elliptical(w, dip * 2),
        clockwise: false, // arc lõm xuống
      )
      ..lineTo(w, 0)
      ..close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
