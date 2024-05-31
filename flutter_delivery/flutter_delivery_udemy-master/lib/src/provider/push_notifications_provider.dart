import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_udemy/src/provider/users_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {



  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



  void initPushNotifications() async {


    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() async {

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print('NUEVA NOTIFICACION EN PRIMER PLANO');

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

    });

  }

  void saveToken(String idUser) async {
    String token = await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = new UsersProvider();
    await usersProvider.updateNotificationToken(idUser, token);
  }

  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {

    Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAaJGwl2Q:APA91bGmFuT0QFcJd6e7Evg6iaoXWrX1XrgeN3vPRIN535BfxQfR33t1AkFtnYqHyqYbQXL1ANAdRaU3TkuO_C3wJHAcaqUdpU_lsIRZxehcuHQvdVTIk_YNUYNLYUbWfebyMDI0ezXO'
        },
        body: jsonEncode(
            <String, dynamic> {
              'notification': <String, dynamic> {
                'body': body,
                'title': title,
              },
              'priority': 'high',
              'ttl': '4500s',
              'data': data,
              'to': to
            }
        )
    );
  }

  Future<void> sendMessageMultiple(List<String> toList, Map<String, dynamic> data, String title, String body) async {

    Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAaJGwl2Q:APA91bGmFuT0QFcJd6e7Evg6iaoXWrX1XrgeN3vPRIN535BfxQfR33t1AkFtnYqHyqYbQXL1ANAdRaU3TkuO_C3wJHAcaqUdpU_lsIRZxehcuHQvdVTIk_YNUYNLYUbWfebyMDI0ezXO'
        },
        body: jsonEncode(
            <String, dynamic> {
              'notification': <String, dynamic> {
                'body': body,
                'title': title,
              },
              'priority': 'high',
              'ttl': '4500s',
              'data': data,
              'registration_ids': toList
            }
        )
    );
  }


}