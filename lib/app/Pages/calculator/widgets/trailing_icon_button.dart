import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

enum TrailingButtonType { icon, text, iconWithText }
enum TrailingButtonActionType { action, dropdown }

class TrailingIconButton extends StatelessWidget {

  const TrailingIconButton({
    super.key,
    this.type = TrailingButtonType.icon,
    this.actionType = TrailingButtonActionType.action,
    this.svgPath,
    this.text,
    this.onPressed,
    this.iconColor = Colors.black,
    this.size = 48,
    this.backgroundColor = AppColors.background,
    this.dropdownItems,
  });
  final TrailingButtonType type;
  final TrailingButtonActionType actionType;
  final String? svgPath;
  final String? text;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double size;
  final Color? backgroundColor;
  final List<PopupMenuEntry<dynamic>>? dropdownItems;

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (type) {
      case TrailingButtonType.icon:
        content = svgPath != null
            ? SvgPicture.asset(
  svgPath!,
  colorFilter: iconColor != null
      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
      : null,
)
            : const SizedBox();
        break;
      case TrailingButtonType.text:
        content = Text(
          text ?? '',
          style: TextStyle(color: iconColor, fontWeight: FontWeight.w600),
        );
        break;
      case TrailingButtonType.iconWithText:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgPath != null)
              SvgPicture.asset(
  svgPath!,
  colorFilter: iconColor != null
      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
      : null,
),
            if (svgPath != null && text != null)
              const SizedBox(width: 6),
            if (text != null)
              Text(
                text!,
                style: TextStyle(color: iconColor, fontWeight: FontWeight.w600),
              ),
          ],
        );
        break;
    }

    final Widget button = Container(
      height: size,
      width: size,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(child: content),
    );

    if (actionType == TrailingButtonActionType.dropdown && dropdownItems != null) {
      return PopupMenuButton(
        itemBuilder: (context) => dropdownItems!,
        position: PopupMenuPosition.under,
        child: button, // You can use .over or .under
      );
    } else {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: button,
      );
    }
  }
}