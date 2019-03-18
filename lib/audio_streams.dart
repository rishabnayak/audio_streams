import 'dart:async';

import 'package:flutter/services.dart';

class AudioStreams {
  static const MethodChannel _channel =
      const MethodChannel('audio_streams');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
