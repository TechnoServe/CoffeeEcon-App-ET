import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/config/app_color.dart';

class AppNumberKeyboard extends StatelessWidget {
  const AppNumberKeyboard({
    required this.onNumberTap,
    required this.onClear,
    super.key,
  });

  final void Function(String) onNumberTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.04), // #0000000A
              offset: const Offset(0, -1),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Wrap(
          children: [
            // Divider with handle
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.stroke100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            // Keyboard content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemBuilder: (_, index) {
                  if (index == 9) {
                    return _KeyButton(
                      label: '.',
                      onTap: () => onNumberTap('.'),
                    );
                  }
                  if (index == 10) {
                    return _KeyButton(
                      label: '0',
                      onTap: () => onNumberTap('0'),
                    );
                  }
                  if (index == 11) {
                    return _KeyButton(
                      label: 'X',
                      onTap: onClear,
                      isClose: true,
                    );
                  }
                  return _KeyButton(
                    label: '${index + 1}',
                    onTap: () => onNumberTap('${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.onTap,
    this.isClose = false,
  });
  final String label;
  final bool isClose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.background60,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isClose
            ? SvgPicture.asset(
                AppAssets.ersase,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconBlack80,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
      );
}
