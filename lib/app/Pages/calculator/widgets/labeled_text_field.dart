import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/utils/decimal_input_formater.dart';

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
  final ValueChanged<String>? onLabelChanged;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late String _labelText;
  bool _editingLabel = false;
  late TextEditingController _labelController;
  bool _showAlert = false;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _labelText = widget.label;
    _labelController = TextEditingController(text: _labelText);
    _focusNode = widget.focusNode ?? FocusNode();
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
    super.dispose();
  }

  void _startEditLabel() {
    setState(() {
      _editingLabel = true;
      _labelController.text = _labelText;
    });
  }

  void _finishEditLabel() {
    setState(() {
      _labelText = _labelController.text.trim().isEmpty
          ? widget.label
          : _labelController.text;
      _editingLabel = false;
    });
    widget.onLabelChanged?.call(_labelText);
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
                              32), // Rough limit (3 words + 2 spaces)
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s{2,}')), // No double spaces
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
                        },
                      ),
                    )
                  : Text(
                      _labelText,
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
                return widget.errorText ?? 'This field should not be empty';
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
              hintText: widget.hintText,
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
                  : null,
            ),
            onChanged: widget.onChanged,
          ),
        ],
      );
}
