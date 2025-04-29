import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon; // Icon is optional, can be null
  final bool? showIcon; // Flag to show or hide the icon
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.showIcon,
    this.color, // Default is false, meaning no icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton.icon(
        style:
            color != null
                ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: WidgetStatePropertyAll(color),
                )
                : null,
        icon:
            (showIcon ?? false) && icon != null
                ? icon!
                : const SizedBox.shrink(),
        // Use an empty widget if icon is null or flag is false
        label: Text(text.tr()),
        onPressed: onPressed,
      ),
    );
  }
}
