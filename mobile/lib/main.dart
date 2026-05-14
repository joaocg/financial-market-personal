import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/api_client.dart';
import 'core/auth/biometric_helper.dart';
import 'core/auth/token_storage.dart';
import 'core/sync/sync_worker.dart';
import 'data/datasources/local_quote_data_source.dart';
import 'data/local/db_helper.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/finance_repository.dart';
import 'data/repositories/market_repository.dart';
import 'data/repositories/messaging_repository.dart';
import 'data/repositories/sync_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/connectivity/connectivity_bloc.dart';
import 'presentation/bloc/finance/finance_bloc.dart';
import 'presentation/bloc/market/market_bloc.dart';
import 'presentation/bloc/messaging/messaging_bloc.dart';
import 'presentation/bloc/sync/sync_bloc.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    try {
      SyncWorker.initialize();
      SyncWorker.scheduleSync();
    } catch (_) {
      // Background sync is best-effort during local development and widget tests.
    }
  }
  runApp(const FinanceiroApp());
}

class FinanceiroApp extends StatelessWidget {
  const FinanceiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final dbHelper = DbHelper();
    final localQuoteDataSource = LocalQuoteDataSource(dbHelper: dbHelper);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: tokenStorage),
        RepositoryProvider.value(value: apiClient),
        RepositoryProvider.value(value: localQuoteDataSource),
        RepositoryProvider(
            create: (_) => AuthRepository(
                apiClient: apiClient, tokenStorage: tokenStorage)),
        RepositoryProvider(
            create: (_) => FinanceRepository(apiClient: apiClient)),
        RepositoryProvider(
            create: (_) => MarketRepository(apiClient: apiClient)),
        RepositoryProvider(
            create: (_) => MessagingRepository(apiClient: apiClient)),
        RepositoryProvider(
          create: (_) => SyncRepository(
              apiClient: apiClient, localDataSource: localQuoteDataSource),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              biometricHelper: BiometricHelper(),
            ),
          ),
          BlocProvider(
            create: (context) => FinanceBloc(
                financeRepository: context.read<FinanceRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                MarketBloc(marketRepository: context.read<MarketRepository>()),
          ),
          BlocProvider(
            create: (context) => MessagingBloc(
                messagingRepository: context.read<MessagingRepository>()),
          ),
          BlocProvider(
            create: (context) => SyncBloc(
              syncRepository: context.read<SyncRepository>(),
              localDataSource: context.read<LocalQuoteDataSource>(),
            ),
          ),
          BlocProvider(create: (_) => ConnectivityBloc()),
        ],
        child: MaterialApp(
          title: 'Financeiro Familiar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C66)),
            useMaterial3: true,
            inputDecorationTheme:
                const InputDecorationTheme(border: OutlineInputBorder()),
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return HomePage(user: state.user);
              }
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
