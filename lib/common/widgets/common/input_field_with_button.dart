import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';

class InputFieldWithButton extends StatelessWidget {
  const InputFieldWithButton({
    super.key,
    this.placeHolder,
    this.buttonText,
    required this.textEditingController,
    required this.onPressed,
  });

  final String? placeHolder;
  final String? buttonText;
  final TextEditingController textEditingController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        suffixIcon: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText ?? 'Add',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            )
        ),
        hintText: placeHolder ?? 'Enter order number',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant), // Ensure hint is visible
        isDense: true, // Prevent excessive padding
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Prevent squeezing
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        prefixIcon: Icon(Iconsax.add, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.defaultRadius), // Set border radius
          borderSide: BorderSide(color: Colors.transparent), // Transparent border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
          borderSide: BorderSide(
              color:Theme.of(context).colorScheme.outlineVariant,
              width: AppSizes.defaultBorderWidth
          ), // Light grey border when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: AppSizes.defaultBorderWidth), // Blue border when focused
        ),
      ),
    );
  }
}
