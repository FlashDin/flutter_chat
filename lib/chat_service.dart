import 'dart:convert';

import 'package:flutter_chat/chat.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  String baseUrl = "http://192.168.57.1:8090/dn-websocket";
  StompClient stompClient = StompClient(config: StompConfig(url: ""));

  ChatService({Function(List<Chat>)? updateState}) {
    stompClient = StompClient(
      config: StompConfig.SockJS(
          url: baseUrl,
          onConnect: (p0) => onConnect(p0, updateState!),
          beforeConnect: () async {
            print('waiting to connect...');
            await Future.delayed(Duration(milliseconds: 200));
            print('connecting...');
          },
          onWebSocketError: (dynamic error) => print(error.toString())),
    );
  }

  void onConnect(StompFrame frame, Function(List<Chat>) updateState) {
    if (updateState == null) {
      print('Please set state function');
    } else {
      stompClient.subscribe(
          destination: '/topic/chat',
          callback: (frame) {
            updateState(chatFromJson(frame.body!));
          });
    }
  }

  void connect() {
    stompClient.activate();
  }

  void disconnect() {
    stompClient.deactivate();
    print("Disconnected");
  }

  void sendMessage(Chat model,
      {int page = 0,
      int size = 100,
      String sort = "id",
      String direction = "asc"}) {
    stompClient.send(
        destination: '/app/chat/save-get',
        body: json.encode(
            {'me': model.me, 'you': model.you, 'message': model.message}),
        headers: {
          'page': page.toString(),
          'size': size.toString(),
          'sort': sort,
          'direction': direction
        });
  }
}
