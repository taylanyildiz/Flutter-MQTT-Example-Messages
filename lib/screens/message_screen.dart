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
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  Widget _buildMessageView(Messages messages) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.pink[200],
        borderRadius: messages.id == 0
            ? BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
      ),
      margin: messages.id == 0
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      child: Text(
        messages.msg!,
      ),
    );
  }

  Widget _buildTextFormSend(MQTTService service) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: 'Send message..'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller!.text.isNotEmpty) {
                    service.isMe = true;
                    service.puslish(_controller!.text);
                  }
                  setState(() {
                    _controller!.clear();
                  });
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MQTTModel>(context);
    final _service = MQTTService(
      host: '77.245.151.85',
      port: 1883,
      topic: 'sensor/home',
      model: state,
    );
    _service.initializeMQTTClient();
    _service.connectMQTT();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 80.0,
          title: Text('Messages'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 25.0),
                  itemCount: state.message.length,
                  itemBuilder: (context, index) =>
                      _buildMessageView(state.message[index]),
                ),
              ),
            ),
            _buildTextFormSend(_service),
          ],
        ),
      ),
    );
  }
}
