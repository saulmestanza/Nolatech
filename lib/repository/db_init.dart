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
            is_available INTEGER,
            address TEXT,
            is_favorite INTEGER,
            price INTEGER,
            latitude REAL,
            longitude REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE reservations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            court_id INTEGER,
            time INTEGER,
            date TEXT,
            start_time TEXT,
            end_time TEXT,
            comment TEXT,
            instructor TEXT
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
          'address': 'Parque Lineal, Guayaquil 090615',
          'price': 40,
          'latitude': 23.4162,
          'longitude': 25.6628,
        });
        await db.insert('courts', {
          'title': "Epic Box",
          'type': "Cancha Tipo B",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
          'address': 'Parque Lineal, Guayaquil 090615',
          'price': 15,
          'latitude': -3.4653,
          'longitude': -62.2159,
        });
        await db.insert('courts', {
          'title': "Sport Box",
          'type': "Cancha Tipo B",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "12:00:00.000",
          'time_end': "16:00:00.000",
          'is_available': 1,
          'address': 'R4H2+H4X, Av del Periodista, Guayaquil 090512',
          'price': 20,
          'latitude': 1.3521,
          'longitude': 103.8198,
        });
        await db.insert('courts', {
          'title': "Sport Box",
          'type': "Cancha Tipo A",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
          'address': 'R4H2+H4X, Av del Periodista, Guayaquil 090512',
          'price': 25,
          'latitude': 51.5072,
          'longitude': 0.1276,
        });
        await db.insert('courts', {
          'title': "Ultimate Box",
          'type': "Cancha Tipo B",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "12:00:00.000",
          'time_end': "16:00:00.000",
          'is_available': 1,
          'address': 'R494+VR7, Av. de las Américas, Guayaquil 090512',
          'price': 15,
          'latitude': 36.5323,
          'longitude': -116.9325,
        });
        await db.insert('courts', {
          'title': "Ultimate Box",
          'type': "Cancha Tipo C",
          'imageUrl': "https://picsum.photos/600/300",
          'date': "2025-04-28",
          'time_start': "08:00:00.000",
          'time_end': "10:00:00.000",
          'is_available': 0,
          'address': 'R494+VR7, Av. de las Américas, Guayaquil 090512',
          'price': 50,
          'latitude': 19.0760,
          'longitude': 72.8777,
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        //
      },
    );
    return _db;
  }
}
