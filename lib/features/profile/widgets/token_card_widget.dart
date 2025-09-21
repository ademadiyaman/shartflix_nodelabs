import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🔹 Kırmızı Badge (Primary Dark)
class DiscountBadge extends StatelessWidget {
  final String text;
  const DiscountBadge( {super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: [
        Shadow(
          color: Colors.white.withOpacity(0.9),
          blurRadius: 8.33,
          offset: const Offset(0, 0),
        ),
      ],
      child: Container(
        width: 61.sp,
        height: 23.sp,
        decoration: BoxDecoration(
          color: const Color(0xFF6F060B),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Mor Discount
class DiscountBadgeSecondary extends StatelessWidget {
  final String text;
  const DiscountBadgeSecondary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      shadows: [
        Shadow(
          color: Colors.white.withOpacity(0.9),
          blurRadius: 8.33, // Figma blur
          offset: const Offset(0, 0),
        ),
      ],
      child: Container(
        width: 61.sp,
        height: 23.sp,
        decoration: BoxDecoration(
          color: const Color(0xFF5949E6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
