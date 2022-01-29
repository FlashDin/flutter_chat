import 'dart:convert';

import 'package:flutter_chat/chat.dart';
import 'package:http/http.dart' show Client;

class ChatService {
  String baseUrl = "http://192.168.57.1:8090/api/chat";
  Client client = Client();

  Future<List<Chat>> findByUser(
      {String me = "",
      String you = "",
      int page = 0,
      int size = 100,
      String sort = "id",
      String direction = "asc"}) async {
    String par = Uri(queryParameters: {
      "me": me,
      "you": you,
      "page": page.toString(),
      "size": size.toString(),
      "sort": sort,
      "direction": direction
    }).query;
    final response = await client.get(
      Uri.parse("$baseUrl?$par"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return chatFromJson(response.body);
  }

  Future<dynamic> save(Chat model) async {
    final response = await client.post(
      Uri.parse("$baseUrl"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: chatToJsonString(model),
    );
    return json.decode(response.body);
  }

  Future<dynamic> update(Chat model) async {
    final response = await client.put(
      Uri.parse("$baseUrl"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: chatToJsonString(model),
    );
    return json.decode(response.body);
  }

  Future<dynamic> delete(int id) async {
    final response = await client.get(
      Uri.parse("$baseUrl/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return json.decode(response.body);
  }
}
