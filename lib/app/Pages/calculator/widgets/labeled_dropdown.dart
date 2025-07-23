import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class LabeledDropdown<T> extends StatefulWidget {
  const LabeledDropdown({
    required this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
    this.validator,
  });
  final String label;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  final String? Function(T?)? validator;
  @override
  State<LabeledDropdown<T>> createState() => _LabeledDropdownState<T>();
}

class _LabeledDropdownState<T> extends State<LabeledDropdown<T>> {
  final ValueNotifier<bool> _dropdownOpenNotifier = ValueNotifier<bool>(false);
  bool _showError = false;

  @override
  void dispose() {
    _dropdownOpenNotifier.dispose();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   _dropdownOpenNotifier.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF23262F),
            ),
          ),
          const SizedBox(height: 8),
          FormField<T>(
            initialValue: widget.value,
            validator: widget.validator,
            builder: (FormFieldState<T> field) => SizedBox(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8),
              //   border: Border.all(color: const Color(0xFFE6E8EC)),
              //   color: const Color(0xFFFFFFFF),
              // ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2<T>(
                    isExpanded: true,
                    value: widget.value,
                    validator: (value) {
                      if (value == null) {
                        setState(() {
                          _showError = true;
                        });
                        return '';
                      } else {
                        setState(() {
                          _showError = false;
                        });
                        return null;
                      }
                    },
                    hint: Text(
                      widget.hintText.tr,
                      style: const TextStyle(
                        color: Color(0xFFB0B7C3),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    //                    onMenuStateChange: (isOpen) {
                    //   _dropdownOpenNotifier.value = isOpen; // This updates the notifier
                    // },
                    customButton: ValueListenableBuilder<bool>(
                      valueListenable: _dropdownOpenNotifier,
                      builder: (context, isOpen, child) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.value?.toString() ?? widget.hintText.tr,
                              style: widget.value == null
                                  ? const TextStyle(
                                      color: Color(0xFFB0B7C3),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    )
                                  : const TextStyle(
                                      color: Color(0xFF23262F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                            ),
                          ),
                          SvgPicture.asset(
                            isOpen
                                ? 'assets/icons/arrow-up.svg'
                                : 'assets/icons/arrow-down.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFB0B7C3),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      padding: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.background60,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      elevation: 4,
                    ),
                    items: widget.items,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE6E8EC),
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFB0B7C3),
                          width: 0.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 0.5,
                        ),
                      ),
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                    onChanged: (val) {
                      widget.onChanged(val);
                    },
                    style: const TextStyle(
                      color: Color(0xFF23262F),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    // dropdownColor: Colors.white,
                    // onTap: () {
                    //   // _dropdownOpenNotifier.value = true;
                    // },
                  ),
                ),
              ),
            ),
          ),
          if (_showError)
            Padding(
              padding: EdgeInsets.only(
                left: 8.w,
                top: 0,
              ),
              child: Text(
                (widget.errorText?.tr ?? 'This field should not be empty').tr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
              ),
            ),
        ],
      );

  @override
  void deactivate() {
    _dropdownOpenNotifier.value = false;
    super.deactivate();
  }
}
