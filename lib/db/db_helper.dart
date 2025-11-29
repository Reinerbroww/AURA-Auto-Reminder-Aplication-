import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reminder.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aura.db');

    return await openDatabase(
      path,
      version: 2, // ubah versi biar trigger onUpgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ------------------ CREATE TABLES ------------------
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reminder (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        link TEXT NOT NULL,
        time TEXT NOT NULL,
        buka_otomatis INTEGER NOT NULL,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES user (id)
      )
    ''');
  }

  // ------------------ UPGRADE HANDLER ------------------
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE reminder ADD COLUMN user_id INTEGER');
    }
  }

  // ------------------ REMINDER ------------------
  Future<int> insertReminder(Reminder reminder, int userId) async {
    final db = await database;
    final data = reminder.toMap();
    data['user_id'] = userId; // tambahkan user id
    return await db.insert('reminder', data);
  }

  Future<List<Reminder>> getRemindersByUser(int userId) async {
    final db = await database;
    final maps = await db.query(
      'reminder',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return maps.map((m) => Reminder.fromMap(m)).toList();
  }

  Future<int> deleteReminder(int id, int userId) async {
    final db = await database;
    return await db.delete(
      'reminder',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  // ------------------ USER ------------------
  Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert('user', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<int?> getUserId(String email) async {
    final db = await database;
    final res = await db.query(
      'user',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (res.isNotEmpty) return res.first['id'] as int;
    return null;
  }
}
