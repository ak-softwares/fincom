import 'package:flutter/material.dart';

class ColoredAmount extends StatelessWidget {
  const ColoredAmount({
    super.key,
    required this.amount,
  });

  final double amount;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (amount == 0) {
      textColor = Colors.black;
    } else if (amount < 0) {
      textColor = Colors.red;
    } else {
      textColor = Colors.green;
    }

    return Text(
      amount.toString(),
      style: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
    );
  }
}
