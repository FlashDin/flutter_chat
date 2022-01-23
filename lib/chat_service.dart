import 'dart:convert';

import 'package:flutter_chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Chat>> findAll(
      {String me = "",
        String you = "",
        int page = 0,
        int size = 100,
        String sort = "id",
        String direction = "asc"}) {
    CollectionReference collectionReference = firestore.collection('chat');
    final response = collectionReference
        .orderBy(sort, descending: direction != 'asc')
        .limit(size);
    return response.snapshots().map((event) => chatFromJson(event.docs.map((e) => e.data()).toList()));
  }
  
  Future<List<Chat>> findByUser(
      {String me = "",
      String you = "",
      int page = 0,
      int size = 100,
      String sort = "id",
      String direction = "asc"}) async {
    CollectionReference collectionReference = firestore.collection('chat');
    final response = await collectionReference
        .orderBy(sort, descending: direction != 'asc')
        .limit(size)
        .get();
    List<dynamic> ls = response.docs.map((e) => e.data()).toList();
    ls = ls.where((element) {
      Map<String, dynamic> map = element;
      return (map["me"] == me && map["you"] == you) ||
          (map["me"] == you && map["you"] == me);
    }).toList();
    return chatFromJson(ls);
  }

  Future<dynamic> save(Chat model) async {
    var uuid = Uuid();
    CollectionReference collectionReference = firestore.collection('chat');
    model.id = uuid.v4();
    String response = await collectionReference
        .add(chatToJson(model))
        .then((value) => "Save data")
        .catchError((error) => "Failed to save: $error");
    return response;
  }

  Future<dynamic> update(Chat model) async {
    CollectionReference collectionReference = firestore.collection('chat');
    String response = await collectionReference
        .doc(model.id)
        .update(chatToJson(model))
        .then((value) => "Update data")
        .catchError((error) => "Failed to update: $error");
    return response;
  }

  Future<dynamic> delete(String id) async {
    CollectionReference collectionReference = firestore.collection('chat');
    String response = await collectionReference
        .doc(id)
        .delete()
        .then((value) => "Delete data")
        .catchError((error) => "Failed to delete: $error");
    return response;
  }
}
