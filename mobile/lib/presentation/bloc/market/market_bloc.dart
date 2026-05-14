import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/market_repository.dart';
import '../../../domain/models/establishment.dart';
import '../../../domain/models/product.dart';

abstract class MarketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductScanRequested extends MarketEvent {
  final String barcode;
  ProductScanRequested(this.barcode);
  @override
  List<Object?> get props => [barcode];
}

class ProductRegistrationRequested extends MarketEvent {
  final Product product;
  ProductRegistrationRequested(this.product);
  @override
  List<Object?> get props => [product];
}

class MarketBootstrapRequested extends MarketEvent {}

class EstablishmentCreationRequested extends MarketEvent {
  final String name;
  final String city;
  final String? state;
  final String? latitude;
  final String? longitude;

  EstablishmentCreationRequested({
    required this.name,
    required this.city,
    this.state,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [name, city, state, latitude, longitude];
}

abstract class MarketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketProductFound extends MarketState {
  final Product product;
  MarketProductFound(this.product);
  @override
  List<Object?> get props => [product];
}

class MarketReady extends MarketState {
  final List<Product> products;
  final List<Establishment> establishments;

  MarketReady({required this.products, required this.establishments});

  List<EstablishmentLocation> get locations => establishments
      .expand((establishment) => establishment.locations)
      .toList();

  @override
  List<Object?> get props => [products, establishments];
}

class EstablishmentLocationCreated extends MarketState {
  final EstablishmentLocation location;

  EstablishmentLocationCreated(this.location);

  @override
  List<Object?> get props => [location];
}

class MarketProductNotFound extends MarketState {
  final String barcode;
  MarketProductNotFound(this.barcode);
  @override
  List<Object?> get props => [barcode];
}

class MarketSuccess extends MarketState {}

class MarketError extends MarketState {
  final String message;
  MarketError(this.message);
  @override
  List<Object?> get props => [message];
}

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository _marketRepository;

  MarketBloc({required MarketRepository marketRepository})
      : _marketRepository = marketRepository,
        super(MarketInitial()) {
    on<ProductScanRequested>((event, emit) async {
      emit(MarketLoading());
      final product = await _marketRepository.getProduct(event.barcode);
      if (product != null) {
        emit(MarketProductFound(product));
      } else {
        emit(MarketProductNotFound(event.barcode));
      }
    });

    on<ProductRegistrationRequested>((event, emit) async {
      emit(MarketLoading());
      final product = await _marketRepository.saveProduct(event.product);
      if (product != null) {
        emit(MarketProductFound(product));
      } else {
        emit(MarketError('Nao foi possivel cadastrar o produto'));
      }
    });

    on<MarketBootstrapRequested>((event, emit) async {
      emit(MarketLoading());
      final products = await _marketRepository.listProducts();
      final establishments = await _marketRepository.listEstablishments();
      emit(MarketReady(products: products, establishments: establishments));
    });

    on<EstablishmentCreationRequested>((event, emit) async {
      emit(MarketLoading());
      final location = await _marketRepository.createEstablishment(
        name: event.name,
        city: event.city,
        state: event.state,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      if (location != null) {
        emit(EstablishmentLocationCreated(location));
      } else {
        emit(MarketError('Nao foi possivel cadastrar o mercado'));
      }
    });
  }
}
