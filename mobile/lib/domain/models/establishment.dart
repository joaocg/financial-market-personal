import 'package:equatable/equatable.dart';

class Establishment extends Equatable {
  final String id;
  final String name;
  final List<EstablishmentLocation> locations;

  const Establishment({
    required this.id,
    required this.name,
    required this.locations,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    final locationsJson = json['locations'];
    return Establishment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      locations: locationsJson is List
          ? locationsJson
              .whereType<Map<String, dynamic>>()
              .map(EstablishmentLocation.fromJson)
              .toList()
          : const [],
    );
  }

  @override
  List<Object?> get props => [id, name, locations];
}

class EstablishmentLocation extends Equatable {
  final String id;
  final String establishmentId;
  final String displayName;
  final String? label;
  final String? city;
  final String? state;
  final String? latitude;
  final String? longitude;

  const EstablishmentLocation({
    required this.id,
    required this.establishmentId,
    required this.displayName,
    this.label,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
  });

  factory EstablishmentLocation.fromJson(Map<String, dynamic> json) {
    final establishmentName = json['establishment_name']?.toString();
    final displayName = json['display_name']?.toString();
    final label = json['label']?.toString();
    final city = json['city']?.toString();
    return EstablishmentLocation(
      id: json['id']?.toString() ?? '',
      establishmentId: json['establishment_id']?.toString() ?? '',
      displayName: displayName ??
          [establishmentName, label, city]
              .where((value) => value != null && value.trim().isNotEmpty)
              .join(' - '),
      label: label,
      city: city,
      state: json['state']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        establishmentId,
        displayName,
        label,
        city,
        state,
        latitude,
        longitude
      ];
}
