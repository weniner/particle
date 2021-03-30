import 'package:flutter/material.dart';
import 'package:particle/particle.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ParticlesContainer(
          child: Container(
            width: 300,
            height:300,
            color: Colors.blueAccent,
            child: Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}
