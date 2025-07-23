import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/utils/decimal_input_formater.dart';
import 'package:flutter_template/app/utils/helpers.dart';
import 'package:get/get.dart';

class LabeledTextField extends StatefulWidget {
  const LabeledTextField({
    required this.label,
    required this.hintText,
    this.suffixText,
    this.controller,
    this.keyboardType = TextInputType.number,
    this.isLabelEditable = false,
    this.validator,
    this.showAlert = false,
    this.onAlertTap,
    this.errorText,
    this.focusNode,
    this.minValue,
    this.onChanged,
    this.isRequired = true,
    this.onLabelChanged,
    this.labeledControllers,
    this.currentController,
    this.labelFocusNode,
    this.suffixIcon,
    super.key,
  });

  final String label;
  final String hintText;
  final String? suffixText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isLabelEditable;
  final bool showAlert;
  final VoidCallback? onAlertTap;
  final String? Function(String?)? validator;
  final String? errorText;
  final FocusNode? focusNode;
  final String? minValue;
  final Function(String)? onChanged;
  final bool isRequired;
  final ValueChanged<Map<String, dynamic>>? onLabelChanged;
  final List<LabeledController>? labeledControllers;
  final LabeledController? currentController;
  final Widget? suffixIcon;
  final FocusNode? labelFocusNode;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  bool _hasLabelError = false;
  bool _hasInputError = false;
  String? _inputErrorText;

  bool _editingLabel = false;
  late TextEditingController _labelController;
  bool _showAlert = false;
  late FocusNode _focusNode;
  late FocusNode _labelFocusNode;
  @override
  void initState() {
    super.initState();

    _labelController = TextEditingController(
      text: widget.currentController?.label ?? widget.label,
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _labelFocusNode = widget.labelFocusNode ?? FocusNode();

    _labelFocusNode.addListener(() {
      if (!_labelFocusNode.hasFocus && _editingLabel) {
        _finishEditLabel();
      }
    });

    widget.controller?.addListener(_validateInput);
    _validateInput();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_validateInput);
    _labelController.dispose();
    // Only dispose if we created it (not passed from parent)
    if (widget.focusNode == null) {
      _focusNode.dispose(); // <-- Dispose if not provided externally
    }
    if (widget.labelFocusNode == null) _labelFocusNode.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    if (_editingLabel) {
      _finishEditLabel(); // auto-save before unmount
    }
    super.deactivate();
  }

  void _startEditLabel() {
    setState(() {
      _editingLabel = true;
      _labelController.text = widget.currentController?.label ?? '';
    });
  }

  void _finishEditLabel() {
    final newLabel = _labelController.text.trim();

    if (!mounted) return;

    setState(() {
      widget.currentController?.label = newLabel;
      _editingLabel = false;
    });

    _checkDuplicateLabel(newLabel);

    // Restore focus to input field after label edit
    Future.delayed(Duration.zero, () {
      _labelFocusNode.unfocus();
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _checkDuplicateLabel(String newLabel) {
    final isDuplicate = widget.labeledControllers != null &&
        widget.labeledControllers!
            .where((c) => c != widget.currentController)
            .any((c) => c.label == newLabel);

    if (!mounted) return;

    setState(() {
      _hasLabelError = isDuplicate;
      _hasInputError = isDuplicate;
      _inputErrorText = isDuplicate ? 'Field label must be unique' : null;
    });

    widget.onLabelChanged?.call({
      'text': newLabel,
      'hasError': _hasInputError,
    });
  }

  void _validateInput() {
    // final value = widget.controller?.text ?? '';
    // bool isValid = widget.validator == null ? true : widget.validator!(value);
    setState(() {
      _showAlert = widget.showAlert;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _editingLabel
                  ? SizedBox(
                      width: 180,
                      child: TextField(
                        controller: _labelController,
                        autofocus: true,
                        focusNode: _labelFocusNode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF23262F),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (_) => _finishEditLabel(),
                        onEditingComplete: _finishEditLabel,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            32,
                          ), // Rough limit (3 words + 2 spaces)
                          FilteringTextInputFormatter.deny(
                            RegExp(r'\s{2,}'),
                          ), // No double spaces
                        ],
                        onChanged: (value) {
                          // Validate word count and length
                          final words = value.trim().split(RegExp(r'\s+'));
                          if (words.length > 3) {
                            _labelController.text = words.take(3).join(' ');
                            _labelController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: _labelController.text.length,
                              ),
                            );
                          }

                          for (final word in words) {
                            if (word.length > 10) {
                              final truncated = word.substring(0, 10);
                              _labelController.text =
                                  value.replaceAll(word, truncated);
                              _labelController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: _labelController.text.length,
                                ),
                              );
                              break;
                            }
                          }
                          _checkDuplicateLabel(value);
                        },
                      ),
                    )
                  : Text(
                      widget.currentController?.label.tr ?? widget.label.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF23262F),
                      ),
                    ),
              if (widget.isLabelEditable && !_editingLabel)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: InkWell(
                    onTap: _startEditLabel,
                    borderRadius: BorderRadius.circular(8),
                    child: SvgPicture.asset(
                      'assets/icons/Edit.svg',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              const Spacer(),
              if (widget.suffixText != null)
                Text(
                  widget.suffixText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFFB0B7C3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType == TextInputType.number
                ? const TextInputType.numberWithOptions(decimal: true)
                : widget.keyboardType,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF23262F),
            ),
            validator: (value) {
              if (!widget.isRequired) {
                return null;
              }
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return (widget.errorText ?? 'This field should not be empty')
                    .tr;
              }
              if (widget.minValue != null) {
                final numValue = num.tryParse(value);
                final minValue = num.tryParse(widget.minValue!);

                if (numValue! < minValue!) {
                  return "${widget.label} shouldn't be zero";
                }
              }
              return null;
            },
            inputFormatters: widget.keyboardType == TextInputType.number
                ? [DecimalNumberInputFormatter()]
                : null,
            decoration: InputDecoration(
              hintText: widget.hintText.tr,
              errorText: (_hasInputError ? _inputErrorText : null)?.tr,
              hintStyle: const TextStyle(
                color: Color(0xFFB0B7C3),
                fontWeight: FontWeight.w400,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB0B7C3)),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _showAlert
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                        top: 8,
                        bottom: 8,
                        left: 8,
                      ),
                      child: GestureDetector(
                        onTap: widget.onAlertTap,
                        child: Container(
                          // width: 20,
                          // height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF6E0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFEDF89)),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/icons/alert.svg',
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFDB022),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    )
                  : widget.suffixIcon,
            ),
            onChanged: widget.onChanged,
          ),
        ],
      );
}
