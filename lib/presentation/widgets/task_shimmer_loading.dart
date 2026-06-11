import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskShimmerLoading extends StatelessWidget {
  const TaskShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ), // Kotak checkbox mock
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.white,
                      ), // Baris judul mock
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.white,
                      ), // Baris deskripsi mock
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 20,
                  color: Colors.white,
                ), // Badge status mock
              ],
            ),
          ),
        );
      },
    );
  }
}
