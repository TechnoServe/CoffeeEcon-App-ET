
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.isSelected, super.key,
    this.onChanged,
  });
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged?.call(!isSelected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isSelected ? Colors.transparent : Colors.transparent,
            // border: Border.all(
            //   color: isSelected ? Colors.teal : Colors.grey.shade300,
            //   width: 1.5,
            // ),
          ),
          child: isSelected
              ? SvgPicture.asset(
                  'assets/icons/check.svg',
                  width: 16,
                  height: 16,
                  // ignore: deprecated_member_use
                  color: Colors.teal,
                )
              : null,
        ),
      );
}
