import 'package:flutter/material.dart';
import 'package:metropass/themes/colors/colors.dart';
import 'package:shimmer/shimmer.dart';

class HelloUserSkeleton extends StatelessWidget {
  const HelloUserSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(MyColor.pr7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16,
                width: 150,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
