import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app_scope.dart';
import 'data/database.dart';
import 'data/photo_store.dart';
import 'domain/wheel_service.dart';
import 'ui/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final photos = PhotoStore(await getApplicationSupportDirectory());
  runApp(AppScope(db: db, wheel: WheelService(db), photos: photos, child: const ManjaManjaApp()));
}

class ManjaManjaApp extends StatelessWidget {
  const ManjaManjaApp({super.key});

  static const _seed = Color(0xFFE4572E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manja Manja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark),
      home: const HomeShell(),
    );
  }
}
