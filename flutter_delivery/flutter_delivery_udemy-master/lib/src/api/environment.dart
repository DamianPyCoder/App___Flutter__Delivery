import 'package:flutter_delivery_udemy/src/models/mercado_pago_credentials.dart';

class Environment {

  static const String API_DELIVERY = "192.168.1.11:3000";
  static const String API_KEY_MAPS = "TU_API_KEY";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-98db4d5d-663a-453b-858e-f66dfd623666',
      accessToken: 'TEST-6028900970379574-062302-e3e5d11b7871ee742832e6351694608f-191014229'
  );

}