class LocationEntity {
  const LocationEntity({
    required this.name,
    required this.lat,
    required this.lng,
    required this.country,
  });

  final String name;
  final double lat;
  final double lng;
  final String country;

  String get displayName {
    if (country.isEmpty || name.contains(country)) return name;
    return '$name, $country';
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'lat': lat, 'lng': lng, 'country': country};
  }

  factory LocationEntity.fromJson(Map<dynamic, dynamic> json) {
    return LocationEntity(
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      country: json['country'] as String? ?? '',
    );
  }

  LocationEntity copyWith({
    String? name,
    double? lat,
    double? lng,
    String? country,
  }) {
    return LocationEntity(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LocationEntity &&
        other.name == name &&
        other.lat == lat &&
        other.lng == lng &&
        other.country == country;
  }

  @override
  int get hashCode => Object.hash(name, lat, lng, country);
}

class LocationCoordinate {
  const LocationCoordinate({required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  bool operator ==(Object other) {
    return other is LocationCoordinate && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => Object.hash(lat, lng);
}
