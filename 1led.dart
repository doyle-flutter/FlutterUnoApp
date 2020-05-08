// *Permisstion : 
//    <uses-permission android:name="android.permission.INTERNET"/>
//
//    <application
//        android:name="io.flutter.app.FlutterApplication"
//        android:label="unoapp"
//        android:icon="@mipmap/ic_launcher"
//        android:usesCleartextTraffic="true">

// *pub : https://pub.dev/packages/socket_io_client

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';


void main() => runApp(
  MaterialApp(
    home: UnoApp(),
  )
);

class UnoApp extends StatefulWidget {
  @override
  _UnoAppState createState() => _UnoAppState();
}

class _UnoAppState extends State<UnoApp> {

  bool _isClick = false;
  Color _lightOff = Colors.grey;
  Color _lightOn = Colors.yellowAccent;

  SocketIO socketIO;
  
  @override
  void initState() {
    socketIO = SocketIOManager().createSocketIO('http://192.168.0.5:3000/chat','/')
      ..init()
      ..subscribe('receive_message', (jsonData) async{
        await Future.microtask(() async{
          return await json.decode(jsonData);
        }).then((data){
          print(data);
          return;
        });
      })
      ..connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uno + Nodejs APP",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child:FloatingActionButton(
          child: Icon(Icons.lightbulb_outline, color: _isClick ? _lightOn : _lightOff),
          onPressed: () async{
            setState(() {
              _isClick = !_isClick;
            });
            await socketIO.sendMessage(
              'send_message',
              json.encode(
                  {
                    "message": "Hi ",
                    "name" :"Flutter"
                  }
              ));
          },
        ),
      ),
    );
  }
}
