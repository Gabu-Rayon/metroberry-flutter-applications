import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/models/payment_method_model.dart';
import 'package:admin/app/utils/fire_store_utils.dart';

import '../../../utils/toast.dart';

class PaymentController extends GetxController {


  // paypal
  Rx<TextEditingController> paypalNameController = TextEditingController().obs;
  Rx<TextEditingController> paypalClientKeyController = TextEditingController().obs;
  Rx<TextEditingController> paypalSecretKeyController = TextEditingController().obs;
  Rx<Status> isPaypalActive = Status.active.obs;
  Rx<Status> isPaypalSandBox = Status.active.obs;

  // payStack
  Rx<TextEditingController> payStackNameController = TextEditingController().obs;
  Rx<TextEditingController> payStackSecretKeyController = TextEditingController().obs;
  Rx<Status> isPayStackActive = Status.active.obs;


  // razorpay
  Rx<TextEditingController> razorpayNameController = TextEditingController().obs;
  Rx<TextEditingController> razorpayKeyController = TextEditingController().obs;
  Rx<TextEditingController> razorpaySecretController = TextEditingController().obs;
  Rx<Status> isRazorpayActive = Status.active.obs;
  Rx<Status> isRazorPaySandBox = Status.active.obs;

  // stripe
  Rx<TextEditingController> stripeNameController = TextEditingController().obs;
  Rx<TextEditingController> clientPublishableKeyController = TextEditingController().obs;
  Rx<TextEditingController> stripeSecretKeyController = TextEditingController().obs;
  Rx<Status> isStripeActive = Status.active.obs;
  Rx<Status> isStripeSandBox = Status.active.obs;

  // mercadoPogo
  Rx<TextEditingController> mercadoPogoNameController = TextEditingController().obs;
  Rx<TextEditingController> mercadoPogoAccessTokenController = TextEditingController().obs;
  Rx<Status> isMercadoPogoActive = Status.active.obs;

  // payFast
  Rx<TextEditingController> payFastNameController = TextEditingController().obs;
  Rx<TextEditingController> payFastMerchantKeyController = TextEditingController().obs;
  Rx<TextEditingController> payFastMerchantIDController = TextEditingController().obs;
  Rx<TextEditingController> payFastReturnUrlController = TextEditingController().obs;
  Rx<TextEditingController> payFastNotifyUrlController = TextEditingController().obs;
  Rx<TextEditingController> payFastCancelUrlController = TextEditingController().obs;
  Rx<Status> isPayFastSandBox = Status.active.obs;
  Rx<Status> isPayFastActive = Status.active.obs;

  // flutterWave
  Rx<TextEditingController> flutterWaveNameController = TextEditingController().obs;
  Rx<TextEditingController> flutterWavePublicKeyKeyController = TextEditingController().obs;
  Rx<Status> isFlutterWaveActive = Status.active.obs;
  Rx<Status> isFlutterWaveSandBox = Status.active.obs;

  //cash
  Rx<TextEditingController> cashNameController = TextEditingController().obs;
  Rx<Status> isCashActive = Status.active.obs;

  //wallet
  Rx<TextEditingController> walletNameController = TextEditingController().obs;
  Rx<Status> isWalletActive = Status.active.obs;

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString title = "Payment".tr.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    isLoading(true);
   await  getPaymentData();
   isLoading(false);
    super.onInit();
  }


  getPaymentData() async {
    await FireStoreUtils.getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;


        //paypal
        if (value.paypal != null) {
          paypalNameController.value.text = paymentModel.value.paypal!.name!;
          paypalClientKeyController.value.text = paymentModel.value.paypal!.paypalClient!;
          paypalSecretKeyController.value.text = paymentModel.value.paypal!.paypalSecret!;
          isPaypalActive.value = paymentModel.value.paypal!.isActive == true ? Status.active : Status.inactive;
          isPaypalSandBox.value = paymentModel.value.paypal!.isSandbox == true ? Status.active : Status.inactive;
        }
        //razorpay
        if (value.paypal != null) {
          razorpayNameController.value.text = paymentModel.value.razorpay!.name!;
          razorpayKeyController.value.text = paymentModel.value.razorpay!.razorpayKey!;
          razorpaySecretController.value.text = paymentModel.value.razorpay!.razorpaySecret!;
          isRazorpayActive.value = paymentModel.value.razorpay!.isActive == true ? Status.active : Status.inactive;
          isRazorPaySandBox.value =  paymentModel.value.razorpay!.isSandbox == true ? Status.active : Status.inactive;

        }
        //stripe
        if (value.strip != null) {
          stripeNameController.value.text = paymentModel.value.strip!.name!;
          clientPublishableKeyController.value.text = paymentModel.value.strip!.clientPublishableKey!;
          stripeSecretKeyController.value.text = paymentModel.value.strip!.stripeSecret!;
          isStripeActive.value = paymentModel.value.strip!.isActive == true ? Status.active : Status.inactive;
          isStripeSandBox.value = paymentModel.value.strip!.isSandbox == true ? Status.active : Status.inactive;
        }

        //payStack
        if (value.payStack != null) {

          payStackNameController.value.text = paymentModel.value.payStack!.name!;
          payStackSecretKeyController.value.text = paymentModel.value.payStack!.payStackSecret!;
          isPayStackActive.value = paymentModel.value.payStack!.isActive == true ? Status.active : Status.inactive;
          // isPayStackSandBox.value = paymentModel.value.payStack!.isSandbox == true ? Status.active : Status.inactive;
        }

        //mercadoPogo
        if (value.paypal != null) {
          mercadoPogoNameController.value.text = paymentModel.value.mercadoPago!.name!;
          mercadoPogoAccessTokenController.value.text = paymentModel.value.mercadoPago!.mercadoPagoAccessToken!;
          isMercadoPogoActive.value = paymentModel.value.mercadoPago!.isActive == true ? Status.active : Status.inactive;
        }

        //payFast
        if (value.paypal != null) {




          payFastNameController.value.text = paymentModel.value.payFast!.name!;
          payFastMerchantKeyController.value.text = paymentModel.value.payFast!.merchantKey!;
          payFastMerchantIDController.value.text = paymentModel.value.payFast!.merchantId!;
          payFastReturnUrlController.value.text = paymentModel.value.payFast!.returnUrl!;
          payFastNotifyUrlController.value.text = paymentModel.value.payFast!.notifyUrl!;
          payFastCancelUrlController.value.text = paymentModel.value.payFast!.cancelUrl!;
          isPayFastActive.value = paymentModel.value.payFast!.isActive == true ? Status.active : Status.inactive;
          isPayFastSandBox.value = paymentModel.value.payFast!.isSandbox == true ? Status.active : Status.inactive;


        }

        //flutterWave
        if (value.paypal != null) {
          flutterWaveNameController.value.text = paymentModel.value.flutterWave!.name!;
          flutterWavePublicKeyKeyController.value.text = paymentModel.value.flutterWave!.publicKey!;
          // flutterWavePublicKeyKeyController.value.text = paymentModel.value.flutterWave!.flutterWaveKey!;
          isFlutterWaveActive.value = paymentModel.value.flutterWave!.isActive == true ? Status.active : Status.inactive;
          isFlutterWaveSandBox.value = paymentModel.value.flutterWave!.isSandBox == true ? Status.active : Status.inactive;
        }

        //cash
        if (value.cash != null) {
          cashNameController.value.text = paymentModel.value.cash!.name!;
          isCashActive.value = paymentModel.value.cash!.isActive == true ? Status.active : Status.inactive;

        } else{
          print('No data of Cash');
        }

        //wallet
        if (value.wallet != null) {
          walletNameController.value.text = paymentModel.value.wallet!.name!;
          isWalletActive.value = paymentModel.value.wallet!.isActive == true ? Status.active : Status.inactive;
        }
      }
    });
  }

  savePayment()async {
    // PayPal
    if (paypalNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayPal Name".tr);
    } else if (paypalClientKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayPal Client Key".tr);
    } else if (paypalSecretKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayPal Secret Key");
    }

    // PayStack
    else if (payStackNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayStack Name".tr);
    } else if (payStackSecretKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayStack Secret Key".tr);
    }

    // Razorpay (Eazopay)
    else if (razorpayNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Razorpay Name".tr);
    } else if (razorpayKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Razorpay Key".tr);
    } else if (razorpaySecretController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Razorpay Secret Key".tr);
    }

    // Stripe
    else if (stripeNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Stripe Name".tr);
    } else if (clientPublishableKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Stripe Client Publishable Key".tr);
    } else if (stripeSecretKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Stripe Secret Key".tr);
    }

    // MercadoPago
    else if (mercadoPogoNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Mercado Pago Name".tr);
    } else if (mercadoPogoAccessTokenController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Mercado Pago Access Token".tr);
    }

    // PayFast
    else if (payFastNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Name".tr);
    } else if (payFastMerchantKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Merchant Key".tr);
    } else if (payFastMerchantIDController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Merchant ID".tr);
    } else if (payFastReturnUrlController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Return URL".tr);
    } else if (payFastNotifyUrlController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Notify URL".tr);
    } else if (payFastCancelUrlController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add PayFast Cancel URL".tr);
    }

    // FlutterWave
    else if (flutterWaveNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add FlutterWave Name".tr);
    } else if (flutterWavePublicKeyKeyController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add FlutterWave Public Key".tr);
    }

    // Cash
    else if (cashNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Cash Name".tr);
    }

    // Wallet
    else if (walletNameController.value.text.isEmpty) {
      return ShowToast.errorToast("Please Add Wallet Name".tr);
    }

    // If all conditions are met, save the payment details
    else {
      Constant.waitingLoader();

      // PayPal
      paymentModel.value.paypal?.name = paypalNameController.value.text;
      paymentModel.value.paypal?.paypalClient = paypalClientKeyController.value.text;
      paymentModel.value.paypal?.paypalSecret = paypalSecretKeyController.value.text;
      paymentModel.value.paypal?.isActive = isPaypalActive.value == Status.active ? true : false;
      paymentModel.value.paypal?.isSandbox = isPaypalSandBox.value == Status.active ? true : false;

      // PayStack
      paymentModel.value.payStack?.name = payStackNameController.value.text;
      paymentModel.value.payStack?.payStackSecret = payStackSecretKeyController.value.text;
      paymentModel.value.payStack?.isActive = isPayStackActive.value == Status.active ? true : false;

      // Razorpay
      paymentModel.value.razorpay?.name = razorpayNameController.value.text;
      paymentModel.value.razorpay?.razorpayKey = razorpayKeyController.value.text;
      paymentModel.value.razorpay?.razorpaySecret = razorpaySecretController.value.text;
      paymentModel.value.razorpay?.isActive = isRazorpayActive.value == Status.active ? true : false;
      paymentModel.value.razorpay?.isSandbox = isRazorPaySandBox.value == Status.active ? true : false;

      // Stripe
      paymentModel.value.strip?.name = stripeNameController.value.text;
      paymentModel.value.strip?.clientPublishableKey = clientPublishableKeyController.value.text;
      paymentModel.value.strip?.stripeSecret = stripeSecretKeyController.value.text;
      paymentModel.value.strip?.isActive = isStripeActive.value == Status.active ? true : false;
      paymentModel.value.strip?.isSandbox = isStripeSandBox.value == Status.active ? true : false;

      // MercadoPago
      paymentModel.value.mercadoPago?.name = mercadoPogoNameController.value.text;
      paymentModel.value.mercadoPago?.mercadoPagoAccessToken = mercadoPogoAccessTokenController.value.text;
      paymentModel.value.mercadoPago?.isActive = isMercadoPogoActive.value == Status.active ? true : false;

      // PayFast
      paymentModel.value.payFast?.name = payFastNameController.value.text;
      paymentModel.value.payFast?.merchantKey = payFastMerchantKeyController.value.text;
      paymentModel.value.payFast?.merchantId = payFastMerchantIDController.value.text;
      paymentModel.value.payFast?.returnUrl = payFastReturnUrlController.value.text;
      paymentModel.value.payFast?.notifyUrl = payFastNotifyUrlController.value.text;
      paymentModel.value.payFast?.cancelUrl = payFastCancelUrlController.value.text;
      paymentModel.value.payFast?.isActive = isPayFastActive.value == Status.active ? true : false;
      paymentModel.value.payFast?.isSandbox = isPayFastSandBox.value == Status.active ? true : false;

      // FlutterWave
      paymentModel.value.flutterWave?.name = flutterWaveNameController.value.text;
      paymentModel.value.flutterWave?.publicKey = flutterWavePublicKeyKeyController.value.text;
      paymentModel.value.flutterWave?.isActive = isFlutterWaveActive.value == Status.active ? true : false;
      paymentModel.value.flutterWave?.isSandBox = isFlutterWaveSandBox.value == Status.active ? true : false;

      // Cash
      paymentModel.value.cash?.name = cashNameController.value.text;
      paymentModel.value.cash?.isActive = isCashActive.value == Status.active ? true : false;

      // Wallet
      paymentModel.value.wallet?.name = walletNameController.value.text;
      paymentModel.value.wallet?.isActive = isWalletActive.value == Status.active ? true : false;

      // Print details step by step
      print('PayPal: Name=${paymentModel.value.paypal?.name}, Client=${paymentModel.value.paypal?.paypalClient}, Secret=${paymentModel.value.paypal?.paypalSecret}, Active=${paymentModel.value.paypal?.isActive}, Sandbox=${paymentModel.value.paypal?.isSandbox}');
      print('PayStack: Name=${paymentModel.value.payStack?.name}, Secret=${paymentModel.value.payStack?.payStackSecret}, Active=${paymentModel.value.payStack?.isActive}');
      print('Razorpay: Name=${paymentModel.value.razorpay?.name}, Key=${paymentModel.value.razorpay?.razorpayKey}, Secret=${paymentModel.value.razorpay?.razorpaySecret}, Active=${paymentModel.value.razorpay?.isActive}, Sandbox=${paymentModel.value.razorpay?.isSandbox}');
      print('Stripe: Name=${paymentModel.value.strip?.name}, ClientPublishableKey=${paymentModel.value.strip?.clientPublishableKey}, Secret=${paymentModel.value.strip?.stripeSecret}, Active=${paymentModel.value.strip?.isActive}, Sandbox=${paymentModel.value.strip?.isSandbox}');
      print('MercadoPago: Name=${paymentModel.value.mercadoPago?.name}, AccessToken=${paymentModel.value.mercadoPago?.mercadoPagoAccessToken}, Active=${paymentModel.value.mercadoPago?.isActive}');
      print('PayFast: Name=${paymentModel.value.payFast?.name}, MerchantKey=${paymentModel.value.payFast?.merchantKey}, MerchantID=${paymentModel.value.payFast?.merchantId}, ReturnUrl=${paymentModel.value.payFast?.returnUrl}, NotifyUrl=${paymentModel.value.payFast?.notifyUrl}, CancelUrl=${paymentModel.value.payFast?.cancelUrl}, Active=${paymentModel.value.payFast?.isActive}, Sandbox=${paymentModel.value.payFast?.isSandbox}');
      print('FlutterWave: Name=${paymentModel.value.flutterWave?.name}, PublicKey=${paymentModel.value.flutterWave?.publicKey}, Active=${paymentModel.value.flutterWave?.isActive}, Sandbox=${paymentModel.value.flutterWave?.isSandBox}');
      print('Cash: Name=${paymentModel.value.cash?.name},cash active ${paymentModel.value.cash?.isActive} ' );
      print('Wallet : Name=${paymentModel.value.wallet?.name},cash active ${paymentModel.value.wallet?.isActive} ' );

      await FireStoreUtils.setPayment(paymentModel.value).then((value) {
      Get.back();
      ShowToast.successToast("Payment status updated".tr);
        });

      }
      }




}
