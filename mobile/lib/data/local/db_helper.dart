import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'financeiro.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE price_quotes (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id TEXT NOT NULL DEFAULT '',
        establishment_location_id TEXT NOT NULL DEFAULT '',
        product_barcode TEXT NOT NULL,
        price REAL NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        photo_path TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        sync_status TEXT NOT NULL,
        error_message TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE price_quotes ADD COLUMN product_id TEXT NOT NULL DEFAULT ''");
      await db.execute(
          "ALTER TABLE price_quotes ADD COLUMN establishment_location_id TEXT NOT NULL DEFAULT ''");
    }
  }
}
