import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  NotificationsService._();
  static final NotificationsService _instance = NotificationsService._();

  final _messaging = FirebaseMessaging.instance;

  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    /// request permission
    requestPermission();
    /// build msg handlers
    msgHandlers();


  }
  Future<void> requestPermission()async{
     var settings = await _messaging.requestPermission(
       alert: true,
       badge: true,
       sound: true,
       provisional: false,
       announcement: false,
     );
     print("permission status: ${settings.authorizationStatus}");
  }
  Future<void> msgHandlers()async{
    FirebaseMessaging.onMessage.listen((message){
      /// show notification
      showMyNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(onHandleBackgroundMessage);
    var initialMsg = await _messaging.getInitialMessage();
    if(initialMsg!=null){
      onHandleBackgroundMessage(initialMsg);
    }
  }
onHandleBackgroundMessage(remoteMessage){
    /// on tap of message

}
showMyNotification(RemoteMessage message) {
    print("Message received: ${message.messageId}");

  RemoteNotification? remoteNotification = message.notification;
  AndroidNotification? androidNotification = message.notification?.android;

  if(remoteNotification!=null && androidNotification!=null && !kIsWeb){

    _localNotification.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "channelId",
          "channelName",
          channelDescription: "channelDescription",
          importance: Importance.max,
          //priority: Priority.high,
          icon: androidNotification.smallIcon
        )
      )
    );


  }

  }
}