import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card.dart';
import '../../../../common/widgets/shimmers/product_shimmer.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/favorite/favorite_controller.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('favourite_screen');

    final ScrollController scrollController = ScrollController();
    final favoriteController = Get.put(FavoriteController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    favoriteController.refreshFavorites();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!favoriteController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (favoriteController.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          favoriteController.isLoadingMore(true);
          favoriteController.currentPage++; // Increment current page
          await favoriteController.getFavoriteProducts();
          favoriteController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! Wishlist is Empty...',
      animation: Images.pencilAnimation,
      showAction: true,
      actionText: 'Let\'s add some',
      onActionPress: () => NavigationHelper.navigateToBottomNavigation(),
    );

    return Obx(() => Scaffold(
          appBar: const TAppBar2(titleText: 'Wishlist', showCartIcon: true,),
          body: !authenticationRepository.isUserLogin.value
            ? const CheckLoginScreen(text: 'Please Login! before Add to ❤️ favorite!')
            : RefreshIndicator(
              color: TColors.refreshIndicator,
              onRefresh: () async => favoriteController.refreshFavorites(),
              child: ListView(
                controller: scrollController,
                padding: TSpacingStyle.defaultPagePadding,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const TSectionHeading(title: 'Favourite Products'),
                  ProductGridLayout(
                    controller: favoriteController,
                    emptyWidget: emptyWidget,
                    sourcePage: 'wishlist',
                  ),
                ],
              ),
            )
        ),
    );
  }
}


