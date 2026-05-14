import 'package:financeiro_mobile/core/api/api_client.dart';
import 'package:financeiro_mobile/core/auth/token_storage.dart';
import 'package:financeiro_mobile/data/repositories/finance_repository.dart';
import 'package:financeiro_mobile/domain/models/family_account.dart';
import 'package:financeiro_mobile/presentation/bloc/finance/finance_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFinanceRepository extends FinanceRepository {
  FakeFinanceRepository()
      : super(apiClient: ApiClient(tokenStorage: TokenStorage()));

  @override
  Future<double> getConsolidatedBalance() async => 1000;

  @override
  Future<List<FamilyAccount>> getAccounts() async => const [
        FamilyAccount(
          id: '1',
          bankName: 'Bank A',
          accountType: 'Checking',
          balance: 1000,
        ),
      ];
}

void main() {
  test('FinanceBloc loads consolidated balance and accounts', () async {
    final bloc = FinanceBloc(financeRepository: FakeFinanceRepository());

    bloc.add(FetchBalancesRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<FinanceLoading>(),
        isA<FinanceLoaded>()
            .having((state) => state.consolidatedBalance, 'balance', 1000)
            .having((state) => state.accounts.length, 'accounts length', 1),
      ]),
    );

    await bloc.close();
  });
}
