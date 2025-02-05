import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:http/http.dart' as http;

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../settings/app_settings.dart';
import '../../models/payment_model.dart';
import 'checkout_controller.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final userController = Get.put(UserController());
  final checkoutController = Get.put(CheckoutController());

  static List<Map<String, String>> paymentJson = [
    {
      PaymentFieldName.id           : 'razorpay',
      PaymentFieldName.title        : 'Razorpay Payment Gateway',
      PaymentFieldName.description  : 'UPI/QR/Card/NetBanking',
      PaymentFieldName.image        : Images.razorpay,
      PaymentFieldName.key          : APIConstant.razorpayKey,
      PaymentFieldName.secret       : APIConstant.razorpaySecret,
    },
    {
      PaymentFieldName.id           : 'cod',
      PaymentFieldName.title        : 'COD (Cash on Delivery)',
      PaymentFieldName.description  : 'COD (Cash on Delivery)',
      PaymentFieldName.image        : Images.cod,
      PaymentFieldName.key          : '',
      PaymentFieldName.secret       : '',
    },
    // {
    //   PaymentFieldName.id           : 'paytm',
    //   PaymentFieldName.title        : 'Paytm Payment Gateway',
    //   PaymentFieldName.description  : 'The best payment gateway provider in India for e-payment through credit card, debit card & netbanking.',
    //   PaymentFieldName.image        : TImages.paytm,
    //   PaymentFieldName.key          : '',
    //   PaymentFieldName.secret       : '',
    // },
  ];

  List<PaymentModel> getAllPaymentMethod = PaymentModel.parsePaymentModels(paymentJson);

  final Razorpay _razorpay = Razorpay();

  PaymentController() {
    // Register event listeners during initialization
    _registerEventListeners();
  }

  void _registerEventListeners() {
    // Listen for payment success event
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      // Notify user about successful payment
      capturePayment(amount: checkoutController.total.value.toInt(), paymentID: response.paymentId ?? '');
      _completer?.complete(response.paymentId);
    });

    // Listen for payment failure event
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      // Notify user about payment failure
      _completer?.completeError("Payment failed: ${response.message}");
    });

    // Listen for payment cancel event
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      // Notify user about payment cancellation
      TLoaders.warningSnackBar(title: 'External Wallet Razorpay:', message: 'Wallet Name: ${response.walletName}');
      _completer?.completeError("Payment cancelled by user.");
    });
  }

  Completer<String>? _completer;

  Future<String> startPayment({required int amount, required String productName}) async {
    // Prepare payment options
    var options = {
      'key': checkoutController.selectedPaymentMethod.value.key,
      'amount': amount * 100, // * 100 Amount in smallest currency unit
      'name': AppSettings.appName,
      // 'order_id': 13456,
      'description': productName,
      'prefill': {
        'contact': userController.customer.value.phone,
        'email': userController.customer.value.email,
      },
    };

    // Create a completer to handle async operations
    _completer = Completer<String>();

    try {
      // Open the Razorpay payment interface
      _razorpay.open(options);
    } catch (e) {
      // Handle initialization errors
      _completer?.completeError("Payment initialization failed. Error: $e");
    }

    // Return the future from the completer
    return _completer!.future;
  }

  @override
  void onClose() {
    // Dispose of event listeners when the controller is closed
    _razorpay.clear();
    super.onClose();
  }

  Future<void> capturePayment({required int amount, required String paymentID}) async {
    try {
      final Uri uri = Uri.https('api.razorpay.com', '/v1/payments/$paymentID/capture');

      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.razorpayAuth,
        },
        body: jsonEncode({
          'amount': amount * 100,
          'currency': 'INR',
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Payment captured successfully: ${response.body}');
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['error']['description'];
        throw errorMessage ?? 'Failed to capture payment';
      }
    } catch (error) {
      rethrow;
    }
  }
}