import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:unoapp/LcdChat.dart';

class LcdPage extends StatefulWidget {
  @override
  _LcdPageState createState() => _LcdPageState();
}

class _LcdPageState extends State<LcdPage> {

  int num = 0;
  double sizeUp = 50.0;

  SocketIO socketIO;

  @override
  void initState() {
    socketIO = SocketIOManager().createSocketIO('http://:3000/chat','/')
      ..init()
      ..subscribe('receive_message', (jsonData) async{
      })
      ..connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("번호 : $num",style: TextStyle(fontSize: sizeUp),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                iconSize: sizeUp,
                icon: Icon(Icons.arrow_upward,size: sizeUp,color: Colors.blue,),
                onPressed: () async{
                  setState(() {
                    ++num;
                  });
                  await Future.microtask(() {
                    socketIO.sendMessage(
                        'send_message', json.encode(
                        {
                          "message": num.toString(),
                          "name": "James"
                        }
                    ));
                  });

                },
              ),
              IconButton(
                iconSize: sizeUp,
                icon: Icon(Icons.arrow_downward, color: Colors.red,),
                onPressed: () async{
                  if(num <= 1) return;
                  setState(() {
                    --num;
                  });
                  await Future.microtask(() {
                    socketIO.sendMessage(
                        'send_message', json.encode(
                        {
                          "message": num.toString(),
                          "name": "James"
                        }
                    ));
                  });

                  return;
                },
              ),
            ],
          ),
          Container(
            child: FlatButton(
              child: Text("Chat Page ->"),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage()
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
