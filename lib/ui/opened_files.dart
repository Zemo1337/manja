import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Files opened with Manja from other apps, e.g. a .manja profile shared over WhatsApp; Android only.
class OpenedFiles {
  static const _channel = MethodChannel('manja/opened_file');

  /// Calls [onFile] with the path of the file the app was started with, and of every file opened later.
  static void listen(void Function(String path) onFile) {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'opened' && call.arguments is String) onFile(call.arguments as String);
    });
    unawaited(
      _channel.invokeMethod<String>('take').then((path) {
        if (path != null) onFile(path);
      }, onError: (Object _) {}),
    );
  }
}
