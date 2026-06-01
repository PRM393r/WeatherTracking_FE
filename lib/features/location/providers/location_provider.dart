import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/repositories/i_location_repository.dart';
import '../entities/location_entity.dart';
import '../repositories/geolocator_location_repository.dart';

final locationRepositoryProvider = Provider<ILocationRepository>((ref) {
  return GeolocatorLocationRepository();
});

final currentLocationProvider = FutureProvider<LocationEntity>((ref) async {
  final repository = ref.watch(locationRepositoryProvider);

  try {
    final location = await repository.getCurrentLocation();
    await repository.cacheLocation(location);
    return location;
  } on LocationException {
    final cached = await repository.getCachedLocation();
    if (cached != null) return cached;
    rethrow;
  }
});

final cachedLocationProvider = FutureProvider<LocationEntity?>((ref) {
  return ref.watch(locationRepositoryProvider).getCachedLocation();
});

final reverseGeocodeProvider =
    FutureProvider.family<LocationEntity, LocationCoordinate>((
      ref,
      coordinate,
    ) {
      return ref
          .watch(locationRepositoryProvider)
          .reverseGeocode(coordinate.lat, coordinate.lng);
    });

final citySearchProvider = FutureProvider.family<List<LocationEntity>, String>((
  ref,
  query,
) {
  return ref.watch(locationRepositoryProvider).searchCities(query);
});
