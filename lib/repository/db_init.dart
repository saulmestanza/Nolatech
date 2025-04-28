import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbInit {
  Database? _db;
  final int version = 1;

  Future<Database?> get db async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    _db = await openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            phone TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE courts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            type TEXT,
            imageUrl TEXT,
            date TEXT,
            time_start TEXT,
            time_end TEXT,
            is_available INTEGER
          )
        ''');
        await db.insert('courts', {
          'title': "Epic Box",
          'type': "Cancha Tipo A",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "12:00:00.000",
          'time_end': "16:00:00.000",
          'is_available': 1,
        });
        await db.insert('courts', {
          'title': "Epic Box",
          'type': "Cancha Tipo A",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
        });
        await db.insert('courts', {
          'title': "Sport Box",
          'type': "Cancha Tipo B",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "12:00:00.000",
          'time_end': "16:00:00.000",
          'is_available': 1,
        });
        await db.insert('courts', {
          'title': "Sport Box",
          'type': "Cancha Tipo B",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
        });
        await db.insert('courts', {
          'title': "Ultimate Box",
          'type': "Cancha Tipo C",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "12:00:00.000",
          'time_end': "16:00:00.000",
          'is_available': 1,
        });
        await db.insert('courts', {
          'title': "Ultimate Box",
          'type': "Cancha Tipo C",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        //
      },
    );
    return _db;
  }
}
