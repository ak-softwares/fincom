import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/address_model.dart';

class TSingleAddress extends StatelessWidget {

  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
    this.hidePhone = false,
  });

  final AddressModel address;
  final bool hidePhone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: onTap,
          radius: 0,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(Sizes.md),
            width: double.infinity,
            showBorder: true,
            margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
            child: Stack(

              children: [
                const Positioned(
                    right: 5,
                    top: 0,
                    child: Icon(Iconsax.edit, size: 20,)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.name, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                    hidePhone
                        ? const SizedBox.shrink()
                        : Column(
                          children: [
                            const SizedBox(height: Sizes.sm),
                            Text(address.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                    hidePhone
                        ? const SizedBox.shrink()
                        : Column(
                          children: [
                            const SizedBox(height: Sizes.sm),
                            Text(address.email ?? '', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                    const SizedBox(height: Sizes.sm),
                    Text(address.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    const SizedBox(height: Sizes.sm),
                  ],
                )
              ],
            ),
          ),
        );
  }
}

