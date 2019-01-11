#import "IosHealthPlugin.h"
#import <ios_health/ios_health-Swift.h>

@implementation IosHealthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIosHealthPlugin registerWithRegistrar:registrar];
}
@end
