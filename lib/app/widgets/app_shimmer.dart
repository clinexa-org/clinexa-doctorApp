import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const AppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const AppShimmer.circular({
    super.key,
    required double size,
    this.shapeBorder = const CircleBorder(),
  })  : width = size,
        height = size;

  AppShimmer.rounded({
    super.key,
    this.width = double.infinity,
    required this.height,
    double borderRadius = 12,
  }) : shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surface.withOpacity(0.5),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.surfaceElevated,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
