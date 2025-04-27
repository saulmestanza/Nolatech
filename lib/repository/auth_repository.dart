import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthRepository {
  Database? _db;
  SharedPreferences? _prefs;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    _db = await openDatabase(
      path,
      version: 1,
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
      },
    );
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final hashedPassword = hashPassword(password);
    try {
      await _db!.insert('users', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': hashedPassword,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    final result = await _db!.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      final userModel = UserModel.fromMap(result.first);
      return userModel;
    }
    return null;
  }

  Future<bool> login(String email, String password) async {
    final hashed = hashPassword(password);
    final result = await _db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashed],
    );

    if (result.isNotEmpty) {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await setLoggedUserId(int.parse(result.first["id"].toString()));
      return true;
    }
    return false;
  }

  Future<UserModel?> getLoggedUser() async {
    final userId = await getLoggedUserId();
    return await getUserById(userId);
  }

  Future<int> getLoggedUserId() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<void> setLoggedUserId(int userId) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<void> logout() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }
}
