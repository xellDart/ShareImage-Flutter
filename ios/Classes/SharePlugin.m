#import "SharePlugin.h"

static NSString *const PLATFORM_CHANNEL = @"plugins.flutter.io/share";

@implementation FLTSharePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *shareChannel =
      [FlutterMethodChannel methodChannelWithName:PLATFORM_CHANNEL
                                  binaryMessenger:registrar.messenger];

  [shareChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    if ([@"share" isEqualToString:call.method]) {
      NSDictionary *arguments = [call arguments];
      [self share:call.arguments
             withController:[UIApplication sharedApplication].keyWindow.rootViewController];
      
      result(nil);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

+ (void)share:(NSDictionary*)sharedItems withController:(UIViewController *)controller {
    NSString *filePath = sharedItems[@"path"];
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *imagePath = [docsPath stringByAppendingPathComponent:filePath];
    NSURL *imageUrl = [NSURL fileURLWithPath:imagePath];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *shareImage = [UIImage imageWithData:imageData];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[ shareImage ]
                                      applicationActivities:nil];
    [controller presentViewController:activityViewController animated:YES completion:nil];
}

@end
