import 'package:workmanager/workmanager.dart';
import '../../data/repositories/sync_repository.dart';
import '../../data/local/db_helper.dart';
import '../../data/datasources/local_quote_data_source.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/token_storage.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final dbHelper = DbHelper();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final localDataSource = LocalQuoteDataSource(dbHelper: dbHelper);
    final syncRepository =
        SyncRepository(apiClient: apiClient, localDataSource: localDataSource);

    try {
      await syncRepository.syncQuotes();
      return true;
    } catch (e) {
      return false;
    }
  });
}

class SyncWorker {
  static const String syncTaskName = 'com.joao.financeiro.syncTask';

  static void initialize() {
    Workmanager().initialize(callbackDispatcher);
  }

  static void scheduleSync() {
    Workmanager().registerPeriodicTask(
      '1',
      syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
