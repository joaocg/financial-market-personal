import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/finance/finance_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Finance')),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FinanceLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FinanceBloc>().add(FetchBalancesRequested());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Consolidated Balance',
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(
                            '\$${state.consolidatedBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Accounts',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...state.accounts.map((account) => ListTile(
                        title: Text(account.bankName),
                        subtitle: Text(account.accountType),
                        trailing:
                            Text('\$${account.balance.toStringAsFixed(2)}'),
                      )),
                ],
              ),
            );
          } else if (state is FinanceError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Start by fetching balances'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<FinanceBloc>().add(FetchBalancesRequested());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
