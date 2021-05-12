import 'package:flutter/material.dart';
import 'package:flutter_mqtt_exam/screens/screen.dart';
import 'package:flutter_mqtt_exam/services/mqtt_service.dart';
import '../widgets/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 2; i++) {
      _formKeys = GlobalKey<FormState>();
      _textControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < 2; i++) {
      _textControllers[i].dispose();
      _focusNodes[i].dispose();
    }
  }

  GlobalKey<FormState>? _formKeys;

  final _textControllers = <TextEditingController>[];

  final _focusNodes = <FocusNode>[];

  void _buildController(BuildContext context) {
    final check = _formKeys!.currentState!.validate();

    if (_textControllers[0].text.isNotEmpty &&
        _textControllers[1].text.isEmpty) {
      FocusScope.of(context).requestFocus(_focusNodes[1]);
    }
    if (check) {
      final username = _textControllers[0].text;
      final password = _textControllers[1].text;
      print('user name : $username\npassword: $password');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MessageScreen(
                    userName: username,
                    passWord: password,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 80.0,
                    horizontal: 40.0,
                  ),
                  child: Text(
                    'Welcome MQTT APP  Please entry ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InputWidget(
                  formKey: _formKeys!,
                  textController: _textControllers,
                  focusNodes: _focusNodes,
                  titles: ['User Name', 'Password'],
                  inputTypes: [
                    TextInputType.name,
                    TextInputType.visiblePassword
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _buildController(context),
          child: Icon(Icons.arrow_forward_ios),
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }
}
