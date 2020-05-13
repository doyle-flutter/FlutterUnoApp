// * pubspec.yaml
//  socket_io: ^0.9.3
//  socket_io_client: ^0.9.10
//  flutter_local_notifications: ^1.4.3


// * IOS(Objective-C) : Runner > AppDelegate.m
// ...
//  if (@available(iOS 10.0, *)) {
//   [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
//  }
// return [...];
// }
// @end

// * Android : AndroidManifest.xml
//    <uses-permission android:name="android.permission.INTERNET" />
//    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
//    <uses-permission android:name="android.permission.VIBRATE" />

// <application ... android:usesCleartextTraffic="true"> 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IO.Socket socket;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  AndroidNotificationDetails androidNotificationDetails;
  IOSNotificationDetails iosNotificationDetails;

  NotificationDetails notificationDetails;

  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => SecondScreen(payload),
//                ),
//              );
              },
            )
          ],
        ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
//    await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//    );
  }

  @override
  void initState() {

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    androidInitializationSettings = new AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    initializationSettings = new InitializationSettings(androidInitializationSettings, iosInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    androidNotificationDetails = new AndroidNotificationDetails(
      "chid",
      "chname",
      "chdes",
    );
    iosNotificationDetails = new IOSNotificationDetails();
    notificationDetails = new NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails
    );
    
    socket = IO.io('http://localhost:3000/',<String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on("receive_message", (data){
      print(data);
      flutterLocalNotificationsPlugin.show(0, "소리알림", "집에 큰소리가 울리고 있습니다", notificationDetails);

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.data_usage),
          onPressed: (){
            socket.emit("send_message", "VALUE");
          },
        ),
      ),
    );
  }
}
