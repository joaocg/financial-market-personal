import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/messaging_repository.dart';
import '../../../domain/models/query_result.dart';

abstract class MessagingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchQueriesRequested extends MessagingEvent {}

abstract class MessagingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingLoaded extends MessagingState {
  final List<QueryResult> queries;
  MessagingLoaded(this.queries);
  @override
  List<Object?> get props => [queries];
}

class MessagingError extends MessagingState {
  final String message;
  MessagingError(this.message);
  @override
  List<Object?> get props => [message];
}

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository _messagingRepository;

  MessagingBloc({required MessagingRepository messagingRepository})
      : _messagingRepository = messagingRepository,
        super(MessagingInitial()) {
    on<FetchQueriesRequested>((event, emit) async {
      emit(MessagingLoading());
      try {
        final queries = await _messagingRepository.getRecentQueries();
        emit(MessagingLoaded(queries));
      } catch (e) {
        emit(MessagingError('Failed to fetch WhatsApp queries'));
      }
    });
  }
}
