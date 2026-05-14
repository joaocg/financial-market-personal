import '../../core/api/api_client.dart';
import '../../domain/models/family_account.dart';

class FinanceRepository {
  final ApiClient _apiClient;

  FinanceRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<FamilyAccount>> getAccounts() async {
    try {
      final response = await _apiClient.dio.get('/balances');
      if (response.statusCode == 200) {
        final List<dynamic> accountsJson = response.data['accounts'];
        return accountsJson
            .map((json) => FamilyAccount.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<double> getConsolidatedBalance() async {
    try {
      final response = await _apiClient.dio.get('/balances');
      if (response.statusCode == 200) {
        return (response.data['consolidated_balance'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}
