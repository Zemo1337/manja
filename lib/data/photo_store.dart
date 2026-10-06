import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

class PhotoStore {
  PhotoStore(this.baseDir);

  static const _folder = 'photos';
  static const _extensions = {'.jpg', '.jpeg', '.png', '.webp', '.heic', '.gif'};

  final Directory baseDir;
  final _random = Random();

  File file(String relativePath) => File(p.join(baseDir.path, relativePath));

  Future<String> save(String sourcePath) async {
    final dir = Directory(p.join(baseDir.path, _folder));
    await dir.create(recursive: true);
    final ext = p.extension(sourcePath).toLowerCase();
    final name = '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 32).toRadixString(16)}'
        '${_extensions.contains(ext) ? ext : '.jpg'}';
    await File(sourcePath).copy(p.join(dir.path, name));
    return p.posix.join(_folder, name);
  }

  Future<void> delete(String? relativePath) async {
    if (relativePath == null) return;
    final f = file(relativePath);
    if (await f.exists()) await f.delete();
  }
}
