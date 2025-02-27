import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../../personalization/controllers/customers_controller.dart';
import '../../../settings/app_settings.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../../models/coupon_model.dart';
import '../../models/order_model.dart';
import '../../models/payment_model.dart';
import '../../screens/orders/order.dart';
import '../cart_controller/cart_controller.dart';
import '../coupon/coupon_controller.dart';
import '../order/order_controller.dart';
import 'payment_controller.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  // Observable variables
  RxDouble subTotal = 0.0.obs;
  RxDouble shipping = 0.0.obs;
  RxBool isFreeShipping = false.obs;
  RxBool isCODDisabled =  false.obs;
  RxString codDisabledReason =  "".obs;
  RxDouble discount = 0.0.obs;
  RxDouble tax = 0.0.obs;
  RxDouble total = 0.0.obs;

  Rx<CouponModel> coupon = CouponModel().obs;
  Rx<PaymentModel> selectedPaymentMethod = PaymentModel.empty().obs;

  final networkManager = Get.put(NetworkManager());
  final cartController = Get.put(CartController());
  final userController = Get.put(CustomersController());
  final settingsController = Get.put(SettingsController());

  @override
  void onInit() {
    super.onInit();

    // Assign the value of totalCartPrice directly to subTotal
    subTotal.value = cartController.totalCartPrice.value;
    // Listen to changes in totalCartPrice and update subTotal accordingly
    ever(cartController.totalCartPrice, (_) {subTotal.value = cartController.totalCartPrice.value; updateTotal();});
    updateCheckout();
  }

  @override
  void onReady() {
    super.onReady();
    updateCheckout(); // Ensure COD and other logic are evaluated after UI setup
  }

  void updateCheckout(){
    checkIsCODDisabled();
    // Automatically deselect COD if it's selected and disabled
    if (isCODDisabled.value && selectedPaymentMethod.value.id == 'cod') {
      // Switch to another available payment method
      final alternativePaymentMethod = PaymentController().getAllPaymentMethod
          .firstWhere(
              (method) => method.id != 'cod', // Select a non-COD method
          orElse: () => PaymentController().getAllPaymentMethod.first);
      updateSelectedPaymentOption(alternativePaymentMethod);
    }
    updateTotal();
  }

  void checkIsCODDisabled() {
    if(cartController.cartItems.any((item) => item.isCODBlocked ?? false)) {
      codDisabledReason.value = 'Products';
      isCODDisabled.value = true;
    } else if(coupon.value.isCODBlocked ?? false){
      codDisabledReason.value = 'Coupon';
      isCODDisabled.value = true;
    } else if(userController.customer.value.isCODBlocked ?? false){
      codDisabledReason.value = 'User';
      isCODDisabled.value = true;
    } else if (settingsController.appSettings.value.blockedPincodes
        ?.contains(userController.customer.value.billing?.pincode) ?? false) {
      codDisabledReason.value = 'Pincode';
      isCODDisabled.value = true;
    } else {
      // Reset if no conditions block COD
      codDisabledReason.value = '';
      isCODDisabled.value = false;
    }
  }

  Future<void> initiateCheckout() async {
    String transactionId = '';
    // Log the beginning of the checkout process
    // FBAnalytics.logBeginCheckout(cartItems: cartController.cartItems);
    try {
      //start loader
      TFullScreenLoader.openLoadingDialog('Processing your order', Images.docerAnimation);

      //check internet connectivity
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate Address Phone and Email
      List<String> validationErrors = userController.customer.value.billing!.validateFields();
      if (validationErrors.isNotEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: '"${validationErrors.join(', ')}", Update in Address');
        return;
      }

      //validate coupon
      Get.put(CouponController()).validateCoupon(coupon.value);

      // Check COD is disabled or not
      checkIsCODDisabled();
      if(isCODDisabled.value) {
        TLoaders.errorSnackBar(title: 'Error', message: "COD is Unavailable for this ${codDisabledReason.value}");
      }

      // Check Payment Method
      final PaymentModel paymentMethod = selectedPaymentMethod.value;
      if (paymentMethod.id.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'Please select payment Method');
        return;
      } else if(paymentMethod.id == TTexts.razorpay) {
        // Start the payment process
        String paymentId = await Get.put(PaymentController()).startPayment(amount: total.value.toInt(), productName: 'Products');
        if (paymentId.isNotEmpty) {
          transactionId = paymentId;
          TLoaders.successSnackBar(title: 'Payment Successful:', message: 'Payment ID: $paymentId');
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(title: 'Error', message: "Payment failed!");
          return;
        }
      } else if(paymentMethod.id == TTexts.paytm) {
        // Handle Paytm payment method
      } else {
        // Handle other payment methods like - 'cod'
      }

      //Create Order
      final OrderModel createdOrder = await Get.put(OrderController()).saveOrderByCustomerId(transactionId: transactionId);

      FBAnalytics.logCheckout(cartItems: cartController.cartItems);
      //update the cart status
      cartController.clearCart();
      coupon.value = CouponModel.empty();
      updateCheckout();
      //Show success screen
      Get.offAll(() => TSuccessScreen(
          image: Images.orderCompletedAnimation,
          title: 'Payment Success! #${createdOrder.id}',
          subTitle: 'Your order status is ${createdOrder.status}',
          // In the onPressed callback of TSuccessScreen
          onPressed: () async {
            // Close current screen
            Get.close(1);
            // Navigate to TOrderScreen
            Get.to(() => const OrderScreen())?.then((value) {
              // After returning from TOrderScreen, navigate to home screen
              NavigationHelper.navigateToBottomNavigation();
              // Get.offAll(() => const BottomNavigation2());
            });
          }
      ));

    } catch(error) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }

  }

  void updateSelectedPaymentOption(PaymentModel paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  // Function to update subTotal
  void updateSubTotal(double value) {
    subTotal.value = value;
    updateTotal();
  }

  // Function to update discount based on coupon details
  void updateDiscount() {
    updateTotal();
  }

  // Function to update shipping
  void updateShipping(double value) {
    shipping.value = calculateShippingCost(value);
    updateTotal();
  }

  // Function to update tax
  void updateTax(double value) {
    tax.value = value;
    updateTotal();
  }

  // Function to calculate total
  void updateTotal() {
    discount.value = calculateDiscount(subTotal.value, coupon.value);
    shipping.value = calculateShippingCost(subTotal.value);
    total.value = (subTotal.value - discount.value) + shipping.value + tax.value;
  }

  // Function to calculate discount based on coupon
  double calculateDiscount(double subTotal, CouponModel coupon) {
    final discountValue = double.tryParse(coupon.amount ?? '') ?? 0;
    final maxDiscount = double.tryParse(coupon.maxDiscount ?? '') ?? 0;
    final discountType = coupon.discountType ?? '';
    if (coupon.isFreeShipping()) {
      isFreeShipping.value = true;
      return 0; // Or handle it according to your requirements
    } else {
      isFreeShipping.value = false;
      if (discountType.toLowerCase() == 'flat') {
        // Flat discount
        return discountValue;
      } else if (discountType.toLowerCase() == 'percent') {
        // Percentage discount
        final calDiscount = subTotal * (discountValue / 100);
        if(maxDiscount != 0){
          return calDiscount > maxDiscount ? maxDiscount : calDiscount;
        }else {
          return calDiscount;
        }
      } else {
        // Invalid discount type
        return 0; // Or handle it according to your requirements
      }
    }
  }

  // Function to calculate shipping cost
  double calculateShippingCost(double subtotal) {
    if(isFreeShipping.value){
      return 0;
    }else if(subtotal > 980) {
      return 0;
    }
    return AppSettings.shippingCharge;
  }
}