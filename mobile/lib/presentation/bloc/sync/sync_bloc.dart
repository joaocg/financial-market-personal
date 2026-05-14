import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/local_quote_data_source.dart';
import '../../../data/repositories/sync_repository.dart';
import '../../../domain/models/price_quote.dart';

abstract class SyncEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SyncStarted extends SyncEvent {}

class AddQuoteRequested extends SyncEvent {
  final PriceQuote quote;
  AddQuoteRequested(this.quote);
  @override
  List<Object?> get props => [quote];
}

abstract class SyncState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncState {}

class SyncInProgress extends SyncState {}

class SyncSuccess extends SyncState {}

class SyncFailure extends SyncState {
  final String message;
  SyncFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncRepository _syncRepository;
  final LocalQuoteDataSource _localDataSource;

  SyncBloc(
      {required SyncRepository syncRepository,
      required LocalQuoteDataSource localDataSource})
      : _syncRepository = syncRepository,
        _localDataSource = localDataSource,
        super(SyncInitial()) {
    on<SyncStarted>((event, emit) async {
      emit(SyncInProgress());
      try {
        await _syncRepository.syncQuotes();
        emit(SyncSuccess());
      } catch (e) {
        emit(SyncFailure('Manual sync failed'));
      }
    });

    on<AddQuoteRequested>((event, emit) async {
      await _localDataSource.insertQuote(event.quote);
      // Auto-trigger sync if possible, or wait for background worker
      add(SyncStarted());
    });
  }
}
