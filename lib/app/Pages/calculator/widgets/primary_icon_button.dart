import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/core/config/constants/dropdown_data.dart';
import 'package:get/get.dart';

enum ButtonType { filled, outlined }

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    required this.text,
    required this.iconPath,
    required this.onPressed,
    super.key,
    this.type = ButtonType.filled,
  });
  final String text;
  final String iconPath;
  final VoidCallback onPressed;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    final isFilled = type == ButtonType.filled;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? const Color(0xFF11696D) : Colors.white,
          foregroundColor: isFilled ? Colors.white : const Color(0xFF23262F),
          side: BorderSide(
            color: isFilled ? Colors.transparent : const Color(0xFFB0B7C3),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isFilled ? Colors.white : const Color(0xFF23262F),
              ),
            ),
            const SizedBox(width: 11),
            SvgPicture.asset(
              iconPath,
              width: 18,
              height: 20,
              colorFilter: isFilled
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : const ColorFilter.mode(Color(0xFF23262F), BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
