import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/finance_repository.dart';
import '../../../domain/models/family_account.dart';

abstract class FinanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBalancesRequested extends FinanceEvent {}

abstract class FinanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final double consolidatedBalance;
  final List<FamilyAccount> accounts;

  FinanceLoaded({required this.consolidatedBalance, required this.accounts});

  @override
  List<Object?> get props => [consolidatedBalance, accounts];
}

class FinanceError extends FinanceState {
  final String message;
  FinanceError(this.message);
  @override
  List<Object?> get props => [message];
}

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository _financeRepository;

  FinanceBloc({required FinanceRepository financeRepository})
      : _financeRepository = financeRepository,
        super(FinanceInitial()) {
    on<FetchBalancesRequested>((event, emit) async {
      emit(FinanceLoading());
      try {
        final balance = await _financeRepository.getConsolidatedBalance();
        final accounts = await _financeRepository.getAccounts();
        emit(FinanceLoaded(consolidatedBalance: balance, accounts: accounts));
      } catch (e) {
        emit(FinanceError('Failed to fetch balances'));
      }
    });
  }
}
