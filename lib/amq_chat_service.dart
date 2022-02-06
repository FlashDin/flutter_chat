import 'dart:io';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter_chat/chat_service.dart';
import 'chat.dart';

class AmqChatService {
  String baseUrl = "192.168.57.1";
  Client client = Client();
  ChatService _chatService = ChatService();

  AmqChatService() {
    client = client = Client(
        settings: ConnectionSettings(
            host: baseUrl,
            port: 5672,
            authProvider: const PlainAuthenticator("guest", "guest")));
  }

  Future receiver(Function(List<Chat>) chats, String me) async {
    print(me);
    ProcessSignal.sigint.watch().listen((_) async {
      print("[x] Close connection");
      await client.close();
      exit(0);
    });

    Channel channel = await client.channel();
    Queue queue = await channel.queue("queue.chat." + me);
    Consumer consumer = await queue.consume();
    // Exchange exchange = await channel.exchange("exchange.chat", ExchangeType.FANOUT, durable: true);
    // Consumer consumer = await exchange.bindQueueConsumer("queue.chat", ["queue.chat." + me]);
    print("[*] Waiting for messages.");
    consumer.listen((message) async {
      print(" [x] Received string: ${message.payloadAsString}");
      Map<dynamic, dynamic> res = message.payloadAsJson;
      List<Chat> ls = await _chatService
          .findByUser(
          me: res["me"] ?? "null",
          you: res["you"] ?? "null",
          page: 0,
          size: 100,
          sort: "createdDate",
          direction: "asc");
      chats(ls);
    });
  }

  void sender(Chat model) async {
    Channel channel = await client.channel();
    Queue queue = await channel.queue("queue.chat");
    queue.publish(chatToJson(model));
    print("[x] Sent message");
    // await client.close();
  }
}
