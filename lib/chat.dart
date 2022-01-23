import 'dart:convert';

class Chat {
  String? id;
  String? me;
  String? you;
  String? message;

  Chat({this.id = "", this.me = "", this.you = "", this.message = ""});

  factory Chat.fromJson(dynamic map) {
    return Chat(
        id: map["id"], me: map["me"], you: map["you"], message: map["message"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "me": me, "you": you, "message": message};
  }

  @override
  String toString() {
    return 'Chat{id: $id, me: $me, you: $you, message: $message}';
  }
}

List<Chat> chatFromJson(List<dynamic> data) {
  return List<Chat>.from(data.map((item) => Chat.fromJson(item)));
}

String chatToJsonString(Chat data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

Map<String, dynamic> chatToJson(Chat data) {
  return data.toJson();
}
