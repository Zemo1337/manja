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
    final (file, relative) = await _newFile(p.extension(sourcePath));
    await File(sourcePath).copy(file.path);
    return relative;
  }

  Future<String> saveBytes(List<int> bytes, String extension) async {
    final (file, relative) = await _newFile(extension);
    await file.writeAsBytes(bytes, flush: true);
    return relative;
  }

  Future<(File, String)> _newFile(String extension) async {
    final dir = Directory(p.join(baseDir.path, _folder));
    await dir.create(recursive: true);
    final ext = extension.toLowerCase();
    final name =
        '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 32).toRadixString(16)}'
        '${_extensions.contains(ext) ? ext : '.jpg'}';
    return (File(p.join(dir.path, name)), p.posix.join(_folder, name));
  }

  Future<void> delete(String? relativePath) async {
    if (relativePath == null) return;
    final f = file(relativePath);
    if (await f.exists()) await f.delete();
  }
}
