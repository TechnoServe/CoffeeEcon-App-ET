import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconHolder extends StatelessWidget {
  const IconHolder({
    required this.svgAsset,
    super.key,
    this.onTap,
    this.iconColor,
    this.backgroundColor = const Color(0xFFF5F5F5),
  });

  final String svgAsset;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
              : null,
          width: 20,
          height: 20,
        ),
      ),
    );

    return onTap != null
        ? GestureDetector(
            onTap: onTap,
            child: container,
          )
        : container;
  }
}
