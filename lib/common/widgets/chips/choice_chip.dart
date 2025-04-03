import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key, this.text, this.selected = false, this.onSelected, this.color,
  });
  final String? text;
  final Color? color;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = text != null;
    return ChoiceChip(
      label: isColor ? Text(text!) : const SizedBox(),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: selected ? AppColors.white : null),
      avatar:           isColor ? null : Container(width: 50, height: 50, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(100))),
      labelPadding:     isColor ? null : const EdgeInsets.all(0),
      padding:          isColor ? null : const EdgeInsets.all(0),
      shape:            isColor ? null : const CircleBorder(),
      backgroundColor:  isColor ? null : color,
    );
  }
}
