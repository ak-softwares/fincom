import 'package:flutter/material.dart';
class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key, required this.title, this.size = 14.0, this.maxLines = 2, this.textAlign = TextAlign.left,
  });
  final String title;
  final double size;
  final int maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: size),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}