

import 'package:flutter_delivery_udemy/src/models/mercado_pago_card_holder.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_issuer.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_payment_method.dart';
import 'package:flutter_delivery_udemy/src/models/mercado_pago_security_code.dart';

class MercadoPagoCreditCard {

  //IDENTIFICADOR DE LA TARJETA
  String id;

  //IDENTIFICADOR DEL CLIENTE
  String customerId;

  String userId;

  //MES DE EXPIRACIÓN DE LA TARJETA
  int expirationMonth;

  //AÑO DE EXPOIRACION DE LA TARJETA
  int expirationYear;

  //PRIMEROS SEIS DIGITOS DE LA TARJETA
  String firstSixDigits;

  //ULTIMOS CUATRO DIGITOS DE LA TARJETA
  String lastFourDigits;

  //INFORMACION DE LOS MEDIOS DE PAGO
  MercadoPagoPaymentMethod paymentMethod = new MercadoPagoPaymentMethod();

  //INFORMACION DEL CODIGO DE SEGURIDAD
  MercadoPagoSecurityCode securityCode = new MercadoPagoSecurityCode();

  //INFORMACION DEL EMISOR
  MercadoPagoIssuer issuer = new MercadoPagoIssuer();

  //INFORMACION DEL DUEÑO DE LA TARJETA
  MercadoPagoCardHolder cardHolder = new MercadoPagoCardHolder();

  //FECHA DE CREACION DE LA TARJETA
  DateTime dateCreated;

  //ULTIMA FECHA DE ACTUALIZACION DE LA TARJETA
  DateTime dateLastUpdate;

  List<MercadoPagoCreditCard> creditCardList = new List();

  MercadoPagoCreditCard({
    this.id,
    this.customerId,
    this.userId,
    this.expirationMonth,
    this.expirationYear,
    this.firstSixDigits,
    this.lastFourDigits,
    this.paymentMethod,
    this.securityCode,
    this.issuer,
    this.cardHolder,
    this.dateCreated,
    this.dateLastUpdate,
  });

  MercadoPagoCreditCard.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoCreditCard.fromJsonMap(item);
      creditCardList.add(chat);
    });
  }

  MercadoPagoCreditCard.fromJsonMap( Map<String, dynamic> json ) {
    id                 = json['id'];
    customerId         = json['customer_id'];
    userId             = json['user_id'];
    expirationMonth    = (json['expiration_month'] != null) ? int.parse(json['expiration_month'].toString()) : 0;
    expirationYear     = (json['expiration_year'] != null) ? int.parse(json['expiration_year'].toString()) : 0;
    firstSixDigits     = json['first_six_digits'];
    lastFourDigits     = json['last_four_digits'];

    paymentMethod      = (json['payment_method'] != null) ? MercadoPagoPaymentMethod.fromJsonMap(json['payment_method']) : null;
    securityCode       = (json['security_code'] != null) ? MercadoPagoSecurityCode.fromJsonMap(json['security_code']) : null;

    issuer             = (json['issuer'] != null) ? MercadoPagoIssuer.fromJsonMap(json['issuer']) : null;

    cardHolder         = (json['cardholder'] != null) ?  MercadoPagoCardHolder.fromJsonMap(json['cardholder']) : null;

    dateCreated        = json['date_created'] is String ? DateTime.parse(json['date_created']) : json['date_created'];
    dateLastUpdate     = json['date_last_updated'] is String ? DateTime.parse(json['date_last_updated']) : json['date_last_updated'];
  }

  Map<String, dynamic> toJson() =>
      {
        'id'                    : id,
        'customer_id'           : customerId,
        'user_id'               : userId,
        'expiration_month'      : expirationMonth,
        'expiration_year'       : expirationYear,
        'first_six_digits'      : firstSixDigits,
        'last_four_digits'      : lastFourDigits,
        'payment_method'        : (paymentMethod != null) ? paymentMethod.toJson() : null,
        'security_code'         : (securityCode != null) ? securityCode.toJson() : null,
        'issuer'                : (issuer != null) ? issuer.toJson() : null,
        'cardholder'            : (cardHolder != null) ? cardHolder.toJson() : null,
        'date_created'          : dateCreated,
        'date_laste_updated'    : dateLastUpdate
      };
}