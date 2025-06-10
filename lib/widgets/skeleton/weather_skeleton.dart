import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherSkeleton extends StatelessWidget {
  const WeatherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 25,
        width: 25,
        color: Colors.grey[400],
      ),
    );
  }
}
