import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_delivery_udemy/src/models/address.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_card_token.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_document_type.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_installment.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_issuer.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_payment.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_payment_method_installments.dart';
import 'package:flutter_delivery_udemy/src/models/order.dart';
import 'package:flutter_delivery_udemy/src/models/product.dart';
import 'package:flutter_delivery_udemy/src/models/user.dart';
import 'package:flutter_delivery_udemy/src/provider/mercado_pago_provider.dart';
import 'package:flutter_delivery_udemy/src/provider/push_notifications_provider.dart';
import 'package:flutter_delivery_udemy/src/provider/users_provider.dart';
import 'package:flutter_delivery_udemy/src/utils/my_snackbar.dart';
import 'package:flutter_delivery_udemy/src/utils/shared_pref.dart';
import 'package:http/http.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientPaymentsStatusController {

  BuildContext context;
  Function refresh;

  MercadoPagoPayment mercadoPagoPayment;

  String errorMessage;

  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  User user;
  SharedPref _sharedPref = new SharedPref();
  UsersProvider usersProvider = new UsersProvider();
  List<String> tokens = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    mercadoPagoPayment = MercadoPagoPayment.fromJsonMap(arguments);
    print('Mercado pago Payment: ${mercadoPagoPayment.toJson()}');

    if (mercadoPagoPayment.status == 'rejected') {
      createErrorMessage();
    }

    user = User.fromJson(await _sharedPref.read('user'));
    usersProvider.init(context, sessionUser: user);

    tokens = await usersProvider.getAdminsNotificationTokens();
    sendNotification();
    refresh();
  }

  void sendNotification() {

    List<String> registration_id = [];
    tokens.forEach((t) {
      if (t != null) {
        registration_id.add(t);
      }
    });

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    pushNotificationsProvider.sendMessageMultiple(
        registration_id,
        data,
        'COMPRA EXITOSA',
        'Un cliente ha realizado un pedido'
    );
  }

  void finishShopping() {
    Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
  }

  void  createErrorMessage() {
    if (mercadoPagoPayment.statusDetail == 'cc_rejected_bad_filled_card_number') {
      errorMessage = 'Revisa el número de tarjeta';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_bad_filled_date') {
      errorMessage = 'Revisa la fecha de vencimiento';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_bad_filled_other') {
      errorMessage = 'Revisa los datos de la tarjeta';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_bad_filled_security_code') {
      errorMessage = 'Revisa el código de seguridad de la tarjeta';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_blacklist') {
      errorMessage = 'No pudimos procesar tu pago';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_call_for_authorize') {
      errorMessage = 'Debes autorizar ante ${mercadoPagoPayment.paymentMethodId} el pago de este monto.';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_disabled') {
      errorMessage = 'Llama a ${mercadoPagoPayment.paymentMethodId} para activar tu tarjeta o usa otro medio de pago';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'No pudimos procesar tu pago';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'No pudimos procesar tu pago';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_duplicated_payment') {
      errorMessage = 'Ya hiciste un pago por ese valor';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_high_risk') {
      errorMessage = 'Elige otro de los medios de pago, te recomendamos con medios en efectivo';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_insufficient_amount') {
      errorMessage = 'Tu ${mercadoPagoPayment.paymentMethodId} no tiene fondos suficientes';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_invalid_installments') {
      errorMessage = '${mercadoPagoPayment.paymentMethodId} no procesa pagos en ${mercadoPagoPayment.installments} cuotas.';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_max_attempts') {
      errorMessage = 'Llegaste al límite de intentos permitidos';
    }
    else if (mercadoPagoPayment.statusDetail == 'cc_rejected_other_reason') {
      errorMessage = 'Elige otra tarjeta u otro medio de pago';
    }
  }

}