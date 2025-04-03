import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/category_controller/category_controller.dart';
import 'category_tap_bar.dart';


class ScrollingCategoryName extends StatelessWidget {
  const ScrollingCategoryName({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final categoryController = Get.put(CategoryController());
    const double imageDimension = 40;
    const double imageRadius = AppSizes.defaultRadius;

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!categoryController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
          if (categoryController.categories.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          categoryController.isLoadingMore(true);
          categoryController.currentPage++; // Increment current page
          await categoryController.getAllCategory();
          categoryController.isLoadingMore(false);
        }
      }
    });

    return Obx(() {
      if (categoryController.isLoading.value){
        return Column(
          children: [
            TSectionHeading(title: 'Popular Categories'),
            Row(
              children: [
                ShimmerEffect(height: imageDimension, width: 100, radius: imageRadius),
                SizedBox(width: AppSizes.spaceBtwItems),
                ShimmerEffect(height: imageDimension, width: 150, radius: imageRadius),
              ],
            ),
          ],
        );
      } else if(categoryController.categories.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final categories = categoryController.categories;
        return Padding(
          padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Popular Categories'),
              SizedBox(
                height: imageDimension,
                child: ListView.separated(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoryController.isLoadingMore.value ? categories.length + 1 : categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
                  itemBuilder: (context, index) {
                    if (index < categories.length) {
                      final category = categories[index];
                      return Container(
                        padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Change to your desired border color
                            width: 1.0, // Change to your desired border width
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(imageRadius), // Change to your desired corner radius
                          ),
                        ),
                        child: InkWell(
                          onTap: () => Get.to(CategoryTapBarScreen(categoryId: category.id ?? '')),
                          child: Text(category.name ?? '')
                        )
                      );
                    } else {
                      return const ShimmerEffect(height: imageDimension, width: 120, radius: imageRadius);
                    }
                  },
                ),
              ),
            ],
          ),
        );          }
    });
  }
}
