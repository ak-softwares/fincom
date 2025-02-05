import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/coupon_model.dart';

class SingleCouponItem extends StatelessWidget {
  const SingleCouponItem({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 300,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4d79ff), Color(0xFF1d4ed8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coupon content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    coupon.description?.isNotEmpty == true
                        ? coupon.description!
                        : 'Discount Offer',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Coupon code and copy button inside a white container
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              coupon.code!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap:() {
                                Clipboard.setData(ClipboardData(text: coupon.code!.toUpperCase()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Coupon code ${coupon.code!.toUpperCase()} copied')),
                                );
                              },
                              child: Icon(Icons.copy, size: 20, color: Colors.black.withOpacity(0.7))
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // "USE CODE" strip
          Container(
            width: 60,
            decoration: BoxDecoration(
              color: TColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Center(
                child: Text(
                  'USE CODE',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
