#import "AudioStreamsPlugin.h"
#import <audio_streams/audio_streams-Swift.h>

@implementation AudioStreamsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAudioStreamsPlugin registerWithRegistrar:registrar];
}
@end
