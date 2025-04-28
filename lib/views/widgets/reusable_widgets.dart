import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String? Function(String?)? validator;
  final FocusNode? focus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator, this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      onTapOutside: (event) => focus?.unfocus(),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      color: Theme.of(context).colorScheme.primary,
      colorBlendMode: BlendMode.lighten,
      width: size,
      height: size,
    );
  }
}