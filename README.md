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

```
<key>NSMicrophoneUsageDescription</key>
<string>stream from microphone?</string>

```
### Android

Not Supported
