// Copyright 2018 Duarte Silveira
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;

class ShareType {
  static const ShareType TYPE_PLAIN_TEXT = const ShareType._internal("text/plain");
  static const ShareType TYPE_IMAGE = const ShareType._internal("image/*");
  static const ShareType TYPE_FILE = const ShareType._internal("*/*");

  static List<ShareType> values() {
    List values = new List<ShareType>();
    values.add(TYPE_IMAGE);
    return values;
  }

  final String _type;

  const ShareType._internal(this._type);

  static ShareType fromMimeType(String mimeType) {
    for (ShareType shareType in values()) {
      if (shareType.toString() == mimeType) {
        return shareType;
      }
    }
    return TYPE_IMAGE;
  }

  @override
  String toString() {
    return _type;
  }
}

/// Plugin for summoning a platform share sheet.
class Share {
  static const String TITLE = "title";
  static const String TEXT = "text";
  static const String PATH = "path";
  static const String TYPE = "type";
  static const String IS_MULTIPLE = "is_multiple";

  final ShareType mimeType;
  final String title;
  final String text;
  final String path;
  final ByteData imageBytes;
  final List<Share> shares;

  Share.nullType()
      : this.mimeType = null,
        this.title = '',
        this.text = '',
        this.path = '',
        this.imageBytes = null,
        this.shares = const [];

  const Share.image(
      {this.mimeType = ShareType.TYPE_IMAGE,
      this.title,
      this.path = 'temp.jpg',
      this.imageBytes,
      this.text = ''}) : assert(mimeType != null),
       assert(path != null),
       this.shares = const[];

  // ignore: missing_return
  static Share _fromReceivedSingle(Map received, ShareType type) {
    return Share.image(
        path: received[PATH], title: received[TITLE], text: received[TEXT]);
  }

  @visibleForTesting
  static const MethodChannel channel =
      const MethodChannel('plugins.flutter.io/share');

  bool get isNull => this.mimeType == null;

  bool get isMultiple => this.shares.isNotEmpty;

  Future<void> share({Rect sharePositionOrigin}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      TYPE: mimeType.toString(),
      IS_MULTIPLE: isMultiple
    };

    final Uint8List list = imageBytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$path').create();
    await file.writeAsBytes(list);

    if (title != null && title.isNotEmpty) {
      params[TITLE] = title;
    }
    switch (mimeType) {
      case ShareType.TYPE_PLAIN_TEXT:
        params[TEXT] = text;
        break;

      case ShareType.TYPE_IMAGE:
      case ShareType.TYPE_FILE:
        params[PATH] = path;
        if (text != null && text.isNotEmpty) {
          params[TEXT] = text;
        }
        break;

    }
    print(params);
    return channel.invokeMethod('share', params);
  }

  @override
  String toString() {
    return 'Share{' +
        (this.isNull
            ? 'null }'
            : 'mimeType: $mimeType, title: $title, text: $text, path: $path, shares: $shares}');
  }
}
