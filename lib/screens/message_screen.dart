import 'package:flutter/material.dart';
import 'package:flutter_mqtt_exam/models/models.dart';
import 'package:flutter_mqtt_exam/services/mqtt_service.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  final String? userName;
  final String? passWord;

  const MessageScreen({
    Key? key,
    this.userName,
    this.passWord,
  }) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController!.dispose();
  }

  MqttService? _service;

  TextEditingController? _messageController;

  Widget _buildMessage(MessageModel message, bool isMe) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
        color: Color(0xFFFFEFEE),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      child: Column(
        crossAxisAlignment:
            !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(message.time!),
          SizedBox(height: 5.0),
          Text(
            message.message!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  String? message;

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (mes) => message = mes,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration.collapsed(hintText: 'Send a message...'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (_messageController!.text.isNotEmpty) {
                  _service!.publish(_messageController!.text, 'sensor/home');
                  setState(() {
                    _messageController!.clear();
                  });
                }
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MqtModel state = Provider.of<MqtModel>(context);
    _service = MqttService(state: state);
    _service!.initializeMQTTClient(
        '77.245.151.85', 'sensor/home', widget.userName, widget.passWord);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 100,
          title: Text('Message'),
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: () => print(''),
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              label: Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 25.0),
                  itemCount: state.message.length,
                  itemBuilder: (context, index) {
                    print('sdf');
                    final msg = state.message[index];
                    final bool isMe = msg.id == 0;
                    return _buildMessage(msg, isMe);
                  },
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
