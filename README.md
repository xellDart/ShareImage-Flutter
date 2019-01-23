# Share Anything plugin

A Flutter plugin to share content from your Flutter app via the platform's share dialog and receive shares from other apps on the platform (currently only on Android).  

Wraps the ACTION_SEND Intent, and ACTION_SEND + ACTION_SEND_MULTIPLE IntentReceiver on Android
 and UIActivityViewController on iOS.

## Usage

To use this plugin

1. add share
```
 share:
    git:
     url: https://github.com/xperiafan13-rom/ShareImage-Flutter.git
```
 as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

2. to send any kind of share, in your main.dart:
```
import 'package:share/share.dart';
```
 then, just instantiate a Share with the corresponding named constructor, with the relevant named arguments:
```

Share.image(path: , mimeType: , title: , text: );
```

## Notes

Currently only the Android part is complete (IOS part does the same as google's original version), but be on the lookout for new versions, as the IOS part is being worked on and will soon do all the same bells and whistles.
