import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/user.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/connectivity/connectivity_bloc.dart';
import '../../bloc/finance/finance_bloc.dart';
import '../../bloc/messaging/messaging_bloc.dart';
import '../../bloc/sync/sync_bloc.dart';
import '../finance/dashboard_page.dart';
import '../market/market_page.dart';
import '../messaging/query_list_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<FinanceBloc>().add(FetchBalancesRequested());
    context.read<MessagingBloc>().add(FetchQueriesRequested());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      const MarketPage(),
      const QueryListPage(),
      const SyncStatusPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Financeiro'),
          NavigationDestination(
              icon: Icon(Icons.qr_code_scanner), label: 'Mercado'),
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline), label: 'WhatsApp'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Sync'),
        ],
      ),
    );
  }
}

class SyncStatusPage extends StatelessWidget {
  const SyncStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronizacao'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              final online = state.status == ConnectivityStatus.online;
              return ListTile(
                leading: Icon(online ? Icons.wifi : Icons.wifi_off),
                title: Text(online ? 'Online' : 'Offline'),
                subtitle: Text(
                  online
                      ? 'Cotacoes pendentes podem ser sincronizadas.'
                      : 'Novas cotacoes serao salvas no aparelho.',
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          BlocConsumer<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SyncFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is SyncSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sincronizacao concluida')),
                );
              }
            },
            builder: (context, state) {
              final loading = state is SyncInProgress;
              return FilledButton.icon(
                onPressed: loading
                    ? null
                    : () => context.read<SyncBloc>().add(SyncStarted()),
                icon: loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload_outlined),
                label: Text(loading ? 'Sincronizando...' : 'Sincronizar agora'),
              );
            },
          ),
        ],
      ),
    );
  }
}
