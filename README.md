# Share Image plugin

A Flutter plugin to share images from your Flutter app via the platform's share dialog.  

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
ByteData data = imageFromNetwork.buffer.asByteData();
Share.image(
          imageBytes: data,
          mimeType: ShareType.TYPE_IMAGE,
          title: 'Title Image',
          text: 'Summary Image').share();
```

## Notes

Only image share is fully working for the moment
