import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_tracking/core/repositories/i_location_repository.dart';
import 'package:weather_tracking/features/location/entities/location_entity.dart';
import 'package:weather_tracking/features/location/providers/location_provider.dart';

void main() {
  test(
    'currentLocationProvider returns current GPS location and caches it',
    () async {
      final repository = _FakeLocationRepository(currentLocation: _hcm);
      final container = ProviderContainer(
        overrides: [locationRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final location = await container.read(currentLocationProvider.future);

      expect(location, _hcm);
      expect(repository.cachedLocation, _hcm);
    },
  );

  test(
    'currentLocationProvider falls back to cached location when GPS fails',
    () async {
      final repository = _FakeLocationRepository(
        currentLocation: _hcm,
        cachedLocation: _hanoi,
        shouldFailCurrentLocation: true,
      );
      final container = ProviderContainer(
        overrides: [locationRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final location = await container.read(currentLocationProvider.future);

      expect(location, _hanoi);
    },
  );

  test(
    'currentLocationProvider throws when permission fails and cache is empty',
    () async {
      final repository = _FakeLocationRepository(
        currentLocation: _hcm,
        shouldFailCurrentLocation: true,
      );
      final container = ProviderContainer(
        overrides: [locationRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      expect(
        container.read(currentLocationProvider.future),
        throwsA(isA<LocationException>()),
      );
    },
  );

  test('citySearchProvider delegates city search to repository', () async {
    final repository = _FakeLocationRepository(currentLocation: _hcm);
    final container = ProviderContainer(
      overrides: [locationRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final results = await container.read(citySearchProvider('Ha Noi').future);

    expect(results, [_hanoi]);
  });
}

const _hcm = LocationEntity(
  name: 'Ho Chi Minh City',
  lat: 10.8231,
  lng: 106.6297,
  country: 'Vietnam',
);

const _hanoi = LocationEntity(
  name: 'Ha Noi',
  lat: 21.0278,
  lng: 105.8342,
  country: 'Vietnam',
);

class _FakeLocationRepository implements ILocationRepository {
  _FakeLocationRepository({
    required this.currentLocation,
    this.cachedLocation,
    this.shouldFailCurrentLocation = false,
  });

  final LocationEntity currentLocation;
  final bool shouldFailCurrentLocation;
  LocationEntity? cachedLocation;

  @override
  Future<void> cacheLocation(LocationEntity location) async {
    cachedLocation = location;
  }

  @override
  Future<LocationEntity?> getCachedLocation() async => cachedLocation;

  @override
  Future<LocationEntity> getCurrentLocation() async {
    if (shouldFailCurrentLocation) {
      throw const LocationException(
        LocationExceptionCode.permissionDenied,
        'Permission denied',
      );
    }
    return currentLocation;
  }

  @override
  Future<LocationEntity> reverseGeocode(double lat, double lng) async {
    return currentLocation.copyWith(lat: lat, lng: lng);
  }

  @override
  Future<List<LocationEntity>> searchCities(String query) async {
    return query.trim().isEmpty ? const [] : const [_hanoi];
  }
}
