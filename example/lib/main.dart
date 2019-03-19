import 'package:flutter/material.dart';
import 'dart:async';

import 'package:audio_streams/audio_streams.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioController controller;

  @override
  void initState() {
    super.initState();
    controller = new AudioController(CommonFormat.Int16, 16000, 1, true);
    initAudio();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAudio() async {
    await controller.intialize();
    controller.startAudioStream().listen((onData) {
      print(onData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}
