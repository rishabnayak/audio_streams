# audio_streams

Support for Audio Streams in Flutter. Capable of streaming Linear PCM format with a bit depth of 16 bits
and 32 bits. Streams microphone audio data as Stream<List<Int>>.

iOS only for now!

Make sure that your App is created with Swift support! If not, then create a new empty project with swift support, by using the following command:

```
flutter create -i swift <project_name>
```

Then, copy over all your .dart files, assets & pubspec

## Stream Type

Linear PCM with a configurable bit depth of 16 or 32 bits

## Installation

Open `pubspec.yaml` and add `audio_streams` as a dependency

### iOS

Add a row to the following file `ios/Runner/Info.plist` and put in the key for
the microphone

```xml
<key>NSMicrophoneUsageDescription</key>
<string>stream from microphone?</string>

```
### Android

Not Supported

## Example


```dart
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
```
