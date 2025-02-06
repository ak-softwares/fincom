import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';

class PurchaseEntry extends StatelessWidget {
  const PurchaseEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Purchase Entry',),
      body: SingleChildScrollView(
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          spacing: Sizes.spaceBtwItems,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Purchase Number'),
            TextFormField(
              // controller: controller.email,
              // validator: (value) => TValidator.validateEmptyText(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: 'Purchase Number'
              )
            ),
            Text('Invoice Number'),
            TextFormField(
              // controller: controller.email,
              // validator: (value) => TValidator.validateEmptyText(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: 'Invoice Number'
              )
            ),
            Text('Date'),
            TextFormField(
              // controller: controller.email,
              // validator: (value) => TValidator.validateEmptyText(value),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Date'
                )
            ),
            Text('Select Products'),
            Text('Select Vendor'),
            Text('Select Payment Method'),
            ElevatedButton(
                onPressed: () {},
                child: Text('Save')
            )
          ],
        ),
      ),
    );
  }
}
