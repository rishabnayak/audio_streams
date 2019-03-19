# audio_streams

Support for Audio Streams in Flutter

iOS only for now!

Make sure that your App is using swift by using the following command:

```
flutter create -i swift
```
## Stream Types

Can only stream Linear PCM with a bit depth of 16 bits or 32 bits

## Installation

Open `pubspec.yaml` and adding `audio_streams` as a dependency

### iOS

Add a row to the following file `ios/Runner/Info.plist` and put the key for
the microphone there

```xml
<key>NSMicrophoneUsageDescription</key>
<string>stream from microphone?</string>

```
### Android

Not Supported

## Example


```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_speech/cloud_speech.dart';

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
    controller = new AudioController(CommonFormat.Int16, 8000, 2, true);
    initAudio();
  }

  Future<void> initAudio() async {
      await controller.intialize();
      controller.startAudioStream();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) {
            return RaisedButton(
              onPressed: () {
                controller.stopAudioStream();
              },
              child: Text('Stop'),
            );
          },
        ),
      ),
    );
  }
}
```
