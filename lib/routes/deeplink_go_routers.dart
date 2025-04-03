import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/navigation_bar/bottom_navigation_bar.dart';
import '../common/web_view/my_web_view.dart';
import '../features/shop/screens/orders/order.dart';
import '../features/shop/screens/products/product_detail.dart';
import '../utils/constants/api_constants.dart';
import 'routes_name_path.dart';

class DeeplinkGoRouter {
  // Define your routes with GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: RoutesPath.home,
    routes: <RouteBase>[
      GoRoute(
        path: RoutesPath.home,
        builder: (BuildContext context, GoRouterState state) {
          return const BottomNavigation();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'product/:slug', //RoutesPath.product,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final slug = state.pathParameters['slug'];
              return MaterialPage(child: ProductScreen(slug: slug));
            },
          ),
          GoRoute(
            path: 'tracking', //RoutesPath.tracking,
            builder: (BuildContext context, GoRouterState state) {
              final orderId = state.uri.queryParameters['order-id'];
              if (orderId != null) {
                return MyWebView(title: 'Track Order #$orderId', url: '${APIConstant.wooTrackingUrl}$orderId');
              } else {
                return const OrderScreen();
              }
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      return const MaterialPage(child: OrderScreen());
    },
  );
}
