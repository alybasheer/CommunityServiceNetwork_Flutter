import 'package:flutter/material.dart';
import 'package:fyp_source_code/utilities/reuse_components/app_colors.dart';
import 'package:fyp_source_code/utilities/reuse_components/spacing.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.highlightColor = const Color(0xFFF8FBFF),
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant AppShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        // Creates a smooth pulsing fade effect instead of the vertical sweep line
        final double pulseTarget =
            (_controller.value > 0.5
                ? 1.0 - _controller.value
                : _controller.value) *
            2.0;

        return Opacity(opacity: 0.4 + (pulseTarget * 0.6), child: child);
      },
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double? widthFactor;
  final BorderRadiusGeometry borderRadius;
  final Color color;

  const ShimmerBlock({
    super.key,
    required this.height,
    this.width,
    this.widthFactor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.color = const Color(0xFFE7ECF3),
  });

  const ShimmerBlock.circle({
    super.key,
    required double size,
    this.color = const Color(0xFFE7ECF3),
  }) : height = size,
       width = size,
       widthFactor = null,
       borderRadius = const BorderRadius.all(Radius.circular(999));

  @override
  Widget build(BuildContext context) {
    final block = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
    );

    if (widthFactor != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(widthFactor: widthFactor, child: block),
      );
    }

    return block;
  }
}

class ShimmerListTileSkeleton extends StatelessWidget {
  final bool showLeadingCircle;
  final bool showTrailingLine;
  final int subtitleLines;
  final EdgeInsets? padding;

  const ShimmerListTileSkeleton({
    super.key,
    this.showLeadingCircle = true,
    this.showTrailingLine = true,
    this.subtitleLines = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(AppSize.m),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorderGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLeadingCircle) const ShimmerBlock.circle(size: 44),
          if (showLeadingCircle) SizedBox(width: AppSize.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBlock(height: 16, widthFactor: 0.7),
                SizedBox(height: AppSize.xsH),
                ...List.generate(
                  subtitleLines,
                  (index) => Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 6),
                    child: ShimmerBlock(
                      height: 12,
                      widthFactor: index == subtitleLines - 1 ? 0.55 : 0.95,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showTrailingLine) ...[
            SizedBox(width: AppSize.s),
            const ShimmerBlock(
              height: 12,
              width: 48,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerHomeSkeleton extends StatelessWidget {
  final int requestCount;

  const ShimmerHomeSkeleton({super.key, this.requestCount = 4});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.m),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.m),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightBorderGray),
            ),
            child: Row(
              children: [
                const ShimmerBlock.circle(size: 72),
                SizedBox(width: AppSize.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ShimmerBlock(height: 16, widthFactor: 0.55),
                      SizedBox(height: AppSize.xsH),
                      const ShimmerBlock(height: 12, widthFactor: 0.42),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.lH),
          const ShimmerBlock(height: 18, widthFactor: 0.4),
          SizedBox(height: AppSize.sH),
          ...List.generate(
            requestCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: AppSize.sH),
              child: const ShimmerListTileSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
