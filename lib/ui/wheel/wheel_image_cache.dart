import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import '../../data/photo_store.dart';

class WheelImageCache {
  WheelImageCache(this.photos, {required this.onLoaded});

  static const decodeWidth = 480;

  final PhotoStore photos;
  final VoidCallback onLoaded;
  final _images = <String, ui.Image>{};
  final _loading = <String>{};
  bool _disposed = false;

  ui.Image? operator [](String? path) => path == null ? null : _images[path];

  void retain(Set<String> paths) {
    for (final path in _images.keys.where((p) => !paths.contains(p)).toList()) {
      _images.remove(path)!.dispose();
    }
    for (final path in paths) {
      if (!_images.containsKey(path) && _loading.add(path)) _load(path);
    }
  }

  Future<void> _load(String path) async {
    try {
      final bytes = await photos.file(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: decodeWidth, allowUpscaling: false);
      final frame = await codec.getNextFrame();
      codec.dispose();
      if (_disposed) {
        frame.image.dispose();
        return;
      }
      _images[path] = frame.image;
      onLoaded();
    } catch (e) {
      debugPrint('Wheel photo $path could not be loaded: $e');
    } finally {
      _loading.remove(path);
    }
  }

  void dispose() {
    _disposed = true;
    for (final image in _images.values) {
      image.dispose();
    }
    _images.clear();
  }
}
