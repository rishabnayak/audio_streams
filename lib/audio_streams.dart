import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final MethodChannel _channel = const MethodChannel('audio_streams');

List<int> audioData;

enum CommonFormat { Int16, Int32 }

class AudioValue {
  const AudioValue({
    this.isInitialized: false,
    this.isStreamingAudio: false,
  });

  const AudioValue.uninitialized()
      : this(isInitialized: false, isStreamingAudio: false);

  /// True after [AudioController.initialize] has completed successfully.
  final bool isInitialized;
  final bool isStreamingAudio;

  AudioValue copyWith({
    bool isInitialized,
    bool isStreamingAudio,
  }) {
    return AudioValue(
      isInitialized: isInitialized ?? this.isInitialized,
      isStreamingAudio: isStreamingAudio ?? this.isStreamingAudio,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isInitialized: $isInitialized,'
        'isStreamingAudio: $isStreamingAudio)';
  }
}

//Exception Handling
class AudioControllerException implements Exception {
  AudioControllerException(this.code, this.message);
  String code;
  String message;

  @override
  String toString() => '$runtimeType($code, $message)';
}

String _parseCommonFormat(CommonFormat format) {
  switch (format) {
    case CommonFormat.Int16:
      return "AVAudioCommonFormat.pcmFormatInt16";
    case CommonFormat.Int32:
      return "AVAudioCommonFormat.pcmFormatInt32";
  }
  throw ArgumentError('Unknown CommonFormat value');
}

int _parseChannelCount(int count) {
  switch (count) {
    case 1:
      return 1;
    case 2:
      return 2;
  }
  throw ArgumentError('Unknown ChannelCount value');
}

//AVAudioFormat Inputs
class AudioController extends ValueNotifier<AudioValue> {
  AudioController(this.commonFormat, this.sampleRate, this.channelCount, this.interleaved)
      : super(const AudioValue.uninitialized());

  final int sampleRate;
  final bool interleaved;
  final int channelCount;
  final CommonFormat commonFormat;

  Stream<List<int>> _audioStreamSubscription;

  //Control Features
  bool isStreaming;
  bool _isDisposed = false;

  Future<void> intialize() async {
    if (_isDisposed) {
      return Future<void>.value();
    }
    try {
      await _channel.invokeMethod(
        'initialize',
        <String, dynamic>{
          'commonFormat': _parseCommonFormat(commonFormat),
          'sampleRate': sampleRate,
          'interleaved': interleaved,
          'channelCount': _parseChannelCount(channelCount)
        },
      );
      value = value.copyWith(
        isInitialized: true,
      );
    } on PlatformException catch (e) {
      throw AudioControllerException(e.code, e.message);
    }
  }

  Stream<List<int>> startAudioStream() {
    if (!value.isInitialized || _isDisposed) {
      throw AudioControllerException(
        'Uninitialized AudioController',
        'startAudioStream was called on uninitialized AudioController.',
      );
    }
    if (value.isStreamingAudio) {
      throw AudioControllerException(
        'A mic has started streaming audio.',
        'startAudioStream was called while a mic was streaming audio.',
      );
    }

    try {
      value = value.copyWith(isStreamingAudio: true);
    } on PlatformException catch (e) {
      throw AudioControllerException(e.code, e.message);
    }
    const EventChannel audioChannel = EventChannel('audio');
    _audioStreamSubscription = audioChannel.receiveBroadcastStream().map((dynamic convert) => List<int>.from(convert));
    return _audioStreamSubscription;
  }
  //add a completer

  //Releases Microphone
  Future<void> stopAudioStream() async {
    if (!value.isInitialized || _isDisposed) {
      throw AudioControllerException(
        'Uninitialized AudioController',
        'stopAudioStream was called on uninitialized AudioController.',
      );
    }
    if (!value.isStreamingAudio) {
      throw AudioControllerException(
        "A mic isn't streaming audio.",
        'stopAudioStream was called while a mic was not streaming audio.',
      );
    }

    try {
      value = value.copyWith(isStreamingAudio: false);
    } on PlatformException catch (e) {
      throw AudioControllerException(e.code, e.message);
    }

    _audioStreamSubscription = null;
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    super.dispose();
  }
}
