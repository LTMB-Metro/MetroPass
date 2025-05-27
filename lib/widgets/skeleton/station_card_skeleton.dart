import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StationCardSkeleton extends StatelessWidget {
  const StationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 40,
                height: 16,
                color: Colors.grey[400],
              ),
            )
          ),
          const SizedBox(width: 30,),
          Expanded(
            flex: 3,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 20,
                height: 12,
                color: Colors.grey[400],
              ),
            )
          )
        ],
      ),
    );
  }
}