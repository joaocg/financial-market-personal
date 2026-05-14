import '../local/db_helper.dart';
import '../../domain/models/price_quote.dart';
import 'package:sqflite/sqflite.dart';

class LocalQuoteDataSource {
  final DbHelper _dbHelper;

  LocalQuoteDataSource({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  Future<int> insertQuote(PriceQuote quote) async {
    final db = await _dbHelper.database;
    return await db.insert('price_quotes', quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PriceQuote>> getPendingQuotes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'price_quotes',
      where: 'sync_status IN (?, ?)',
      whereArgs: [SyncStatus.pending.name, SyncStatus.failed.name],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => PriceQuote.fromMap(map)).toList();
  }

  Future<void> updateSyncStatus(int localId, SyncStatus status,
      {String? errorMessage}) async {
    final db = await _dbHelper.database;
    await db.update(
      'price_quotes',
      {
        'sync_status': status.name,
        'error_message': errorMessage,
      },
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> deleteSyncedQuotes() async {
    final db = await _dbHelper.database;
    await db.delete(
      'price_quotes',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.synced.name],
    );
  }
}
