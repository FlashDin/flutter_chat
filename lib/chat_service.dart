import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat/chat.dart';
import 'package:http/http.dart' show Client;

class ChatService {
  FirebaseDatabase database = FirebaseDatabase.instance;
  Client client = Client();

  Query findAll({int page = 0, int size = 100, String sort = "id"}) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("chat");
    Query query = ref.orderByChild(sort).limitToFirst(size);
    return query;
  }

  Future<List<Chat>> findByUser(
      {String me = "",
      String you = "",
      int page = 0,
      int size = 100,
      String sort = "id",
      String direction = "asc"}) {
    return findAll(page: page, size: size, sort: sort)
        .onValue
        .where((event) {
          Map<Object?, Object?> map =
              event.snapshot.value as Map<Object?, Object?>;
          return (map["me"] == me && map["you"] == you) ||
              (map["me"] == you && map["you"] == me);
        })
        .map((event) => chatFromJson(event.snapshot.value))
        .toList();
  }

  Future<dynamic> save(Chat model) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("chat").push();
    model.id = ref.key;
    ref.set(chatToJson(model));
    return "Save data";
  }

  Future<dynamic> update(Chat model) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("chat");
    ref.update(chatToJson(model));
    return "Update data";
  }

  Future<dynamic> delete(String id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("chat");
    ref.child(id).remove();
    return "Delete data";
  }
}
