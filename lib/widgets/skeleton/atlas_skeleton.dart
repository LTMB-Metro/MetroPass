import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AtlasSkeleton extends StatelessWidget {
  const AtlasSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.grey[200]),
            ),
            Center(
              child: Icon(Icons.map, size: 48, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
