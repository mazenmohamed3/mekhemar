import 'package:flutter/material.dart';

import '../Text/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon; // Icon is optional, can be null
  final bool? showIcon; // Flag to show or hide the icon
  final Color? color;
  final Color? textColor;
  final bool? noAction;
  final bool? isLoading;
  final FocusNode? focusNode;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.showIcon,
    this.color,
    this.noAction,
    this.isLoading,
    this.textColor,
    this.focusNode, // Default is false, meaning no icon
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      focusNode: focusNode,
      style:
          color != null || noAction == true
              ? Theme.of(context).elevatedButtonTheme.style!.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                  noAction == true
                      ? Theme.of(context).colorScheme.secondary
                      : color,
                ),
              )
              : null,
      icon:
          (showIcon ?? false) && icon != null && noAction == false
              ? icon!
              : const SizedBox.shrink(),
      // Use an empty widget if icon is null or flag is false
      label:
          isLoading == true
              ? Transform.scale(
                scale: 0.75,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.surface,
                  ),
                ),
              )
              : CustomText(
                text: text,
                color:
                    noAction == true
                        ? Theme.of(context).colorScheme.surface
                        : null,
              ),
      onPressed: noAction == true || isLoading == true ? null : onPressed,
    );
  }
}
