import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final FocusNode? focus;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function()? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText,
    this.validator,
    this.focus,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focus,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (value) => widget.onChanged!(value),
      keyboardType: widget.keyboardType,
      onFieldSubmitted: (value) => widget.onFieldSubmitted!(value),
      onTapOutside: (event) {
        widget.focus?.unfocus();
        widget.onTapOutside!();
      },
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label.tr(),
        hintText: widget.hintText.tr(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText == true
            ? GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        )
            : null, // No suffix icon if obscureText is false
      ),
      validator: widget.validator,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}