import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat.dart';
import 'package:flutter_chat/chat_service.dart';
import 'package:flutter_chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Chat Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChatService _chatService = new ChatService();
  Chat _chat = new Chat(me: "sender", you: "receiver");
  List<TextEditingController> _textEditingControllers = [];

  @override
  void initState() {
    super.initState();
    _textEditingControllers.add(new TextEditingController(text: _chat.me));
    _textEditingControllers.add(new TextEditingController(text: _chat.you));
    _textEditingControllers.add(new TextEditingController(text: _chat.message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _chatService.findByUser(
                me: _chat.me ?? "null",
                you: _chat.you ?? "null",
                page: 0,
                size: 100,
                sort: "createdDate",
                direction: "asc"),
            builder:
                (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Something wrong with message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Chat> chats = snapshot.data as List<Chat>;
                return ListView.builder(
                    itemCount: chats.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 60, bottom: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Stack(
                          children: [
                            Align(
                              alignment: (chats[index].me == "receiver"
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (chats[index].me == "receiver"
                                      ? Colors.grey.shade300
                                      : Colors.blue[100]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  chats[index].message ?? "Empty message",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Align(
                              alignment: (chats[index].me == "receiver"
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 50, right: 16, left: 16),
                                child: Text(
                                  chats[index].me == "receiver"
                                      ? "receiver"
                                      : "sender",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Sender",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: _textEditingControllers[0],
                      onChanged: (value) => setState(() {
                        _chat.me = value;
                      }),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Receiver",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: _textEditingControllers[1],
                      onChanged: (value) => setState(() {
                        _chat.you = value;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: _textEditingControllers[2],
                      onChanged: (value) => setState(() {
                        _chat.message = value;
                      }),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _chatService.save(_chat).then((res) {
                        if (res != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Message sended")
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Message failed to send")
                          ));
                        }
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
