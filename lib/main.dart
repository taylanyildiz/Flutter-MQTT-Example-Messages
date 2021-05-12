import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'screens/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InputModel()),
        ChangeNotifierProvider(create: (_) => MqtModel()),
      ],
      child: MaterialApp(
        title: 'Flutter MQTT App Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(title: 'Flutter MQTT App'),
      ),
    );
  }
}
